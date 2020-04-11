//
//  Script.swift
//  Extension
//
//  Created by Mike on 2020-04-11.
//  Copyright © 2020 Mike. All rights reserved.
//

import UIKit

class UserScript: NSObject {
    var title: String
    var text: String
    
    init(title: String, text: String) {
        self.title = title
        self.text = text
    }
}
