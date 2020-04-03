//
//  Person.swift
//  Project10
//
//  Created by Mike on 2019-04-29.
//  Copyright © 2019 Mike. All rights reserved.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
