//
//  ActionViewController.swift
//  Extension
//
//  Created by Mike on 2019-11-04.
//  Copyright © 2019 Mike. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {
    @IBOutlet var script: UITextView!
    
    var pageTitle = ""
    var pageURL = ""
    
    let defaults = UserDefaults.standard // 2
    
    // 3
    var userScripts = [UserScript]()
    var userScriptToShow = String()
    var userScriptText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 3
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let saveBtn = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveUserScript))
        navigationItem.leftBarButtonItems = [doneBtn, saveBtn]
        
        let showScriptsBtn = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showScripts))
        let openUserScriptsBtn = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(openUserScripts))
        navigationItem.rightBarButtonItems = [showScriptsBtn, openUserScriptsBtn]
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    self?.pageTitle = javaScriptValues["Title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                        self?.script.text = self?.defaults.string(forKey: self!.pageURL) //2
                        
                        // 3
                        self?.userScripts = NSKeyedUnarchiver.unarchiveObject(with: self?.defaults.object(forKey: "userScripts") as! Data) as! [UserScript]
                    }
                }
            }
        }
    }
    
    // 3
    override func viewWillAppear(_ animated: Bool) {
        if !userScriptToShow.isEmpty {
            script.text = userScriptToShow
        }
    }

    @IBAction func done() {
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script.text]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        extensionContext?.completeRequest(returningItems: [item])
        
        saveScriptOnPage()
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0) // view.safeAreaInsets.bottom (home button area) is exclusively for iPhone 10+, it will alway be 0 for previous iPhone models
            
            script.scrollIndicatorInsets = script.contentInset
            
            let selectedRange = script.selectedRange
            script.scrollRangeToVisible(selectedRange)
        }
    }
    
    func setScript(action: UIAlertAction) {
        guard let actionTitle = action.title else { return }
        //actionTitle
        if actionTitle == "Show page title" {
            script.text = "alert(document.title);"
        }
        if actionTitle == "Show page url" {
            script.text = "alert(document.URL);"
       }
    }
    
    // 1
    @objc func showScripts() {
        let ac = UIAlertController(title: "Scripts", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Show page title", style: .default, handler: setScript))
        ac.addAction(UIAlertAction(title: "Show page url", style: .default, handler: setScript))
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    // 2
    func saveScriptOnPage() {
        defaults.set(script.text, forKey: pageURL)
    }
    
    // 3
    @objc func saveUserScript() {
        let ac = UIAlertController(title: "Save script", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Save", style: .default) { [weak self, weak ac] _ in
            guard var scriptTitle = ac?.textFields?[0].text else { return }
            
            if scriptTitle == "" {
                scriptTitle = "Unnamed"
            }
            
            let userScript = UserScript(title: scriptTitle, text: self!.script.text)
            self?.userScripts.append(userScript)
            
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: self?.userScripts)
            self?.defaults.set(encodedData, forKey: "userScripts")
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .default))
        present(ac, animated: true)
    }
    
    // 3
    @objc func openUserScripts() {
        let vc = TableViewController()
        vc.userScripts = userScripts
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
