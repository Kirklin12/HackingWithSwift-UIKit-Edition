//
//  ViewController.swift
//  Project2a
//
//  Created by Mike on 2019-03-14.
//  Copyright © 2019 Mike. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var expression = ""
    var attempts = 2
    var flag = 0
    var correctAnswer = 0
    
    struct Highscore: Codable {
        var value: Int
    }
    
    var highscore = Highscore(value: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showScore))
        
        let defaults = UserDefaults.standard
        //defaults.removeObject(forKey: "highscore")
        
        if let savedData = defaults.object(forKey: "highscore") as? Data {
            let jsonDecoder = JSONDecoder()

            do {
                highscore = try jsonDecoder.decode(Highscore.self, from: savedData)
            } catch {
                print("Failed to load count data.")
            }
        }
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        print(highscore.value)
        
        askQuestion()
    }

    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = countries[correctAnswer].uppercased() + " (Your score is \(score))"
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        attempts -= 1
        if sender.tag == correctAnswer {
            score += 1
        } else {
            score -= 1
        }
        
        if (attempts == 0){
            
            if score > 0 {
                expression = "win"
            } else {
                expression = "lose"
            }
            
            if score > highscore.value {
                highscore.value = score
                print("highscore: \(highscore.value)")
                save()
                customAlert(title: "You win with a new high score!", message: "Your new high score is \(highscore.value)", handler: askQuestion)
            } else {
                customAlert(title: "You \(expression)!", message: "Your final score is \(score). Your high score is \(highscore.value)", handler: askQuestion)
            }
            
            attempts = 4
            score = 0
        } else {
            if sender.tag != correctAnswer {
                customAlert(title: "Wrong", message: "That’s the flag of " + countries[sender.tag].capitalized, handler: nil)
            }
            askQuestion()
        }

        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            sender.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    
    func customAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Continue", style: .default, handler: handler))
        present(alertController, animated: true)
    }
    
    @objc func showScore() {
        let vc = UIAlertController(title: "Score", message: "Your score is \(score)", preferredStyle: .alert)
        
        vc.addAction(UIAlertAction(title: "Continue", style: .default))
        
        present(vc, animated: true)
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let saveData = try? jsonEncoder.encode(highscore) {
            let defaults = UserDefaults.standard
            defaults.set(saveData, forKey: "highscore")
        } else {
            print("Failed to save data.")
        }
    }
}
