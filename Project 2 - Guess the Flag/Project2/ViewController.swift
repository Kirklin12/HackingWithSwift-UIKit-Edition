//
//  ViewController.swift
//  Project2
//
//  Created by Mike on 2019-03-14.
//  Copyright © 2019 Mike. All rights reserved.
//

import UserNotifications
import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var attempts = 10
    var correctAnswer = 0
    var timerCount = 7
    
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
        
        // Notifications
        registerLocalNotification()
        Timer.scheduledTimer(withTimeInterval: 86395.0, repeats: true) { timer in
            if self.timerCount > 0 {
                self.scheduleLocalNotification()
                self.timerCount -= 1
            } else {
                timer.invalidate()
            }
        }
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
        let at = UIAlertController(title: "Game over!", message: "Your final score is \(score + 1)", preferredStyle: .alert)
        
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
    
    // Notifications
    func registerLocalNotification() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Yay!")
            } else {
                print("D'oh!")
            }
        }
    }
    
    @objc func scheduleLocalNotification() {
        registerCatrgories()
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Don't forget to play 'Guess The Flag'!"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func registerCatrgories() {
       let center = UNUserNotificationCenter.current()
       center.delegate = self
       
       let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
       let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers:[], options: [])
       
       center.setNotificationCategories([category])
   }
}
