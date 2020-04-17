//
//  UserScript.swift
//  Extension
//
//  Created by Mike on 2020-04-16.
//  Copyright © 2020 Mike. All rights reserved.
//

import UIKit

class UserScript: NSObject, NSCoding {
    var title: String?
    var text: String?
    
    init(title: String, text: String) {
        self.title = title
        self.text = text
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.text, forKey: "text")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.title = aDecoder.decodeObject(forKey: "title") as? String
        self.text = aDecoder.decodeObject(forKey: "text") as? String
    }
}
