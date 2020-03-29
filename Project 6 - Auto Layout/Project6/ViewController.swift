//
//  ViewController.swift
//  Project6
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
    var attempts = 10
    var correctAnswer = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showScore))
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
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
       
        let aw = UIAlertController(title: "Wrong", message: "That’s the flag of " + countries[sender.tag].capitalized, preferredStyle: .alert)
        let at = UIAlertController(title: "You win!", message: "Your final score is \(score + 1)", preferredStyle: .alert)
        
        if (attempts == 0){
            present(at, animated: true)
            attempts = 10
            score = 0
        } else if sender.tag == correctAnswer {
            score += 1
            askQuestion()
        } else {
            score -= 1
            present(aw, animated: true)
        }
        
        aw.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        at.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
    }
    
    @objc func showScore() {
        let vc = UIAlertController(title: "Score", message: "Your score is \(score)", preferredStyle: .alert)
        
        vc.addAction(UIAlertAction(title: "Continue", style: .default))
        
        present(vc, animated: true)
    }
}
