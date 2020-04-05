//
//  ViewController.swift
//  Project5a
//
//  Created by Mike on 2019-03-22.
//  Copyright © 2019 Mike. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var allWords = [String]()
    
    struct Words: Codable {
        var lastWord = String()
        var usedWords = [String]()
    }
    
    var words = Words(lastWord: "", usedWords: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        //defaults.removeObject(forKey: "words")

        
        if let savedData = defaults.object(forKey: "words") as? Data {
            
            let jsonDecoder = JSONDecoder()
            
            do {
                words = try jsonDecoder.decode(Words.self, from: savedData)
            } catch {
                print("Failed to load data")
            }
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        startGame(new: true)
    }

    @objc func startGame(new: Bool) {
        if new {
            title = words.lastWord
            if words.lastWord == "" {
                title = allWords.randomElement()
                words.lastWord = title!
            }
        } else {
            title = allWords.randomElement()
            words.lastWord = title!
            words.usedWords.removeAll(keepingCapacity: true)
        }
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = words.usedWords[indexPath.row]
        return cell
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit (_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    words.usedWords.insert(answer.lowercased(), at: 0)
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    save()
                    
                    return
                } else {
                    showErrorMessage(errorTitle: "Word not recognized", errorMessage: "You can't just make them up, you know!")
                }
            } else {
                showErrorMessage(errorTitle: "Word already used", errorMessage: "Be more original!")
            }
        } else {
            guard let title = title else { return }
            showErrorMessage(errorTitle: "Word not possible", errorMessage: "You can't spell that word from \(title.lowercased()).")
        }
    }
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        print(word)
        if (title?.lowercased() != word){
             return !words.usedWords.contains(word)
        } else { return false }
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        if (word.count < 3){ return false }
        
        return misspelledRange.location == NSNotFound
    }
    
    func showErrorMessage(errorTitle: String, errorMessage: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let saveData = try? jsonEncoder.encode(words) {
            let defaults = UserDefaults.standard
            defaults.set(saveData, forKey: "words")
        } else {
            print("Failed to save data")
        }
    }
}
