//
//  InterfaceController.swift
//  Project37 WatchKit Extension
//
//  Created by Mike on 2020-05-25.
//  Copyright © 2020 Mike. All rights reserved.
//

import WatchConnectivity
import WatchKit
import Foundation

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    @IBOutlet var welcomeText: WKInterfaceLabel!
    @IBOutlet var hideButton: WKInterfaceButton!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    
    override func willActivate() {
        super.willActivate()
        
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    @IBAction func hideWelcomeText() {
        welcomeText.setHidden(true)
        hideButton.setHidden(true)
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        WKInterfaceDevice().play(.click)
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
}
