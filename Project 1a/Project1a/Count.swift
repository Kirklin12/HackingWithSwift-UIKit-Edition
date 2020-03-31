//
//  Count.swift
//  Project1a
//
//  Created by Mike on 2019-06-06.
//  Copyright © 2019 Mike. All rights reserved.
//

import UIKit

class Count: NSObject, Codable {
    var views: Int
    
    init(views: Int) {
        self.views = views
    }
}
