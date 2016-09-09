//
//  Article+CoreDataProperties.swift
//  Kiwix
//
//  Created by Chris on 1/10/16.
//  Copyright © 2016 Chris. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Article {

    @NSManaged var isBookmarked: Bool
    @NSManaged var isMainPage: Bool
    @NSManaged var lastPosition: Float
    @NSManaged var lastReadDate: NSDate?
    @NSManaged var bookmarkDate: NSDate?
    @NSManaged var title: String?
    @NSManaged var snippet: String?
    @NSManaged var url: String
    @NSManaged var book: Book?
    @NSManaged var tags: NSSet?
    @NSManaged var thumbImageURL: String?
}
