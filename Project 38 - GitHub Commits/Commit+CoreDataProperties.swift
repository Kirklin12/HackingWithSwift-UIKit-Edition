//
//  Commit+CoreDataProperties.swift
//  Project38
//
//  Created by Mike on 2020-06-01.
//  Copyright © 2020 Mike. All rights reserved.
//
//

import Foundation
import CoreData

extension Commit {
    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Commit> {
        return NSFetchRequest<Commit>(entityName: "Commit")
    }

    @NSManaged public var date: Date
    @NSManaged public var message: String
    @NSManaged public var sha: String
    @NSManaged public var url: String
    @NSManaged public var author: Author
}
