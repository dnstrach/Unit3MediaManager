//
//  MediaItem+Convenience.swift
//  MediaManager
//
//  Created by Dominique Strachan on 1/4/23.
//

//import Foundation
import CoreData


extension MediaItem {
    
    //what is @discardableResult? - allows you to use the return value if you want while you can decide as well to just ignore it. This keeps your code clean and removes any related warnings in your project.
    @discardableResult convenience init(title: String, mediaType: String, year: Int, itemDescription: String, rating: Double, wasWatched: Bool, isFavorite: Bool, reminderDate: Date? = nil, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.id = UUID()
        self.title = title
        self.mediaType = mediaType
        self.year = Int64(year)
        self.itemDescription = itemDescription
        self.rating = rating
        self.wasWatched = wasWatched
        self.isFavorite = isFavorite
        self.reminderDate = reminderDate
    }
}
