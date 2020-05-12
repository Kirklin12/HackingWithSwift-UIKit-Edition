//
//  Whistle.swift
//  Project33
//
//  Created by Mike on 2020-05-12.
//  Copyright © 2020 Mike. All rights reserved.
//

import CloudKit
import UIKit

class Whistle: NSObject {
    var recordID: CKRecord.ID!
    var genre: String!
    var comments: String!
    var audio: URL!
}
