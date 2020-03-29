//
//  Count.swift
//  Project1a
//
//  Created by Mike on 2019-06-06.
//  Copyright © 2019 Mike. All rights reserved.
//

import UIKit

class Picture: NSObject, Codable {
    var name: String
    var views: Int
    
    init(name: String, views: Int) {
        self.name = name
        self.views = views
    }
}
