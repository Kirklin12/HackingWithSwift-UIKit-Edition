//
//  ViewController.swift
//  Project18
//
//  Created by Mike on 2019-11-03.
//  Copyright © 2019 Mike. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //print(1,2,3,4,5, separator: "-", terminator: ".")
        //assert(1 == 2, "Math failure!")
        
        for i in 1...100 {
            print("got number \(i).")
        }
    }
}

//Learned:
//Exception breakpoints to catch errors.
//assert() function, checking that value is always there.
//Conditional breakpoints to pause only under specific condition.
