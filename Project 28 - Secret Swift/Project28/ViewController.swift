//
//  ViewController.swift
//  Project28
//
//  Created by Mike on 2020-04-25.
//  Copyright © 2020 Mike. All rights reserved.
//

import LocalAuthentication
import UIKit

class ViewController: UIViewController {
    @IBOutlet var secret: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Nothing to see here"
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
        
        // 1
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveSecretMessage))
        navigationItem.leftBarButtonItem?.isEnabled = false
        navigationItem.leftBarButtonItem?.tintColor = UIColor.clear
        
        // 2
        KeychainWrapper.standard.set("password123", forKey: "Password")
    }

    @IBAction func AuthenticateTapped(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        
         // &error means 'don't pass the error itself, pass in where that value is in RAM'
        if context .canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self?.unlockSecretMessage()
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified; please try again.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(ac, animated: true)
                    }
                }
            }
        } else {
            // 2
            let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication. Please, use password instead.", preferredStyle: .alert)
            ac.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
                textField.isSecureTextEntry = true
            })
            
            let unlockAction = UIAlertAction(title: "Unlock", style: .default) {
                [weak self, weak ac] action in
                guard let password = ac?.textFields?[0].text else { return }
                self?.submitPassword(password)
            }
            
            ac.addAction(unlockAction)
            ac.addAction(UIAlertAction(title: "Cancel", style: .default))
            present(ac, animated: true)
        }
    }
    
    // 2
    func submitPassword(_ password: String) {
        if password == KeychainWrapper.standard.string(forKey: "Password") {
            unlockSecretMessage()
        } else {
            let ac = UIAlertController(title: "Authentication failed", message: "Password incorrect; please try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Retry", style: .default, handler: AuthenticateTapped))
            ac.addAction(UIAlertAction(title: "Cancel", style: .default))
            present(ac, animated: true)
        }
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEnd = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEnd, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        secret.scrollIndicatorInsets = secret.contentInset
        
        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }
    
    func unlockSecretMessage() {
        secret.isHidden = false
        title = "Secret stuff!"
        
        secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
        
        navigationItem.leftBarButtonItem?.isEnabled = true // 1
        navigationItem.leftBarButtonItem?.tintColor = nil
    }
    
    @objc func saveSecretMessage() {
        guard secret.isHidden == false else { return }
        
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        secret.resignFirstResponder()
        secret.isHidden = true
        title = "Nothing to see here"
        
        navigationItem.leftBarButtonItem?.isEnabled = false // 1
        navigationItem.leftBarButtonItem?.tintColor = UIColor.clear
    }
}
