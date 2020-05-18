//
//  Move.swift
//  Project34
//
//  Created by Mike on 2020-05-18.
//  Copyright © 2020 Mike. All rights reserved.
//

import GameplayKit
import UIKit

class Move: NSObject, GKGameModelUpdate {
    var value: Int = 0
    var column: Int
    
    init(column: Int) {
        self.column = column
    }
}
