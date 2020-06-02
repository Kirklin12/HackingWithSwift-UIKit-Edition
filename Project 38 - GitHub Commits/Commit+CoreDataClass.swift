//
//  Commit+CoreDataClass.swift
//  Project38
//
//  Created by Mike on 2020-05-30.
//  Copyright © 2020 Mike. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Commit)
public class Commit: NSManagedObject {
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
        print("Init called!")
    }
}
