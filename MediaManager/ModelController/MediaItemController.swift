//
//  MediaItemController.swift
//  MediaManager
//
//  Created by Dominique Strachan on 1/4/23.
//

import CoreData

class MediaItemController {
    
    //shared instance
    static let shared = MediaItemController()
    
    //will be called everytime MediaItemController is instantiated which will take place upon the shared instance
    private init() {
        fetchMediaItems()
    }
    
    //creating fetch request for fetchMediaItems function that fetches any entity that is a MediaItem
    private lazy var fetchRequest: NSFetchRequest<MediaItem> = {
        let request = NSFetchRequest<MediaItem>(entityName: "MediaItem")
        request.predicate = NSPredicate(value: true)
        return request
    }()
    //media items hold the array of stuff
    var mediaItems: [MediaItem] = []
    var favorites: [MediaItem] = []
    var movies: [MediaItem] = []
    var tvShows: [MediaItem] = []
    //computated property?
    var sections: [[MediaItem]] { [favorites, movies, tvShows] }
    //create a constant called notificationScheduler and set it to an instance of NotificationScheduler()
    let notificationScheduler = NotificationScheduler()
    
    func fetchMediaItems() {
        //each time user fetches media items, favs, movies and shows will be set to an empty array
        favorites = []
        movies = []
        tvShows = []
        //fetching media items using the Core Data fetch function with newly created fetchRequest from above. Applying the results to your mediaItems array.
        let mediaItems = (try? CoreDataStack.context.fetch(self.fetchRequest)) ?? []
        self.mediaItems = mediaItems
        sectionOffMediaItems()
    }
    
    func sectionOffMediaItems() {
        //looping through mediaItems array
        for item in mediaItems {
            //checking if item is checked as fav and send to favorites array in fetchMediaItems function
            if item.isFavorite {
                favorites.append(item)
            }
            //checking if item is categorized as movie and send to movies array else send it's a show so send to tvShows array in fetchMediaItems function
            if item.mediaType == "Movie" {
                movies.append(item)
            } else {
                tvShows.append(item)
            }
        }
    }
    
    func createMediaItem(title: String, mediaType: String, year: Int, itemDescription: String, rating: Double, wasWatched: Bool, isFavorite: Bool) {
        
        //initializing mediaItem
        let mediaItem = MediaItem(title: title, mediaType: mediaType, year: year, itemDescription: itemDescription, rating: rating, wasWatched: wasWatched, isFavorite: isFavorite)
        
        //appending to array mediaItems array above
        mediaItems.append(mediaItem)
        
        CoreDataStack.saveContext()
        //calling on function to empty sections or recreate them so that mediaItem is in the correct section array
        fetchMediaItems()
    }
    
    //This will save any changes that have been made to a media item, and then update all the data in your source of truth.
    func updateMediaItem() {
        CoreDataStack.saveContext()
        fetchMediaItems()
    }
    
    func deleteMediaItem(_ mediaItem: MediaItem) {
        if let index = movies.firstIndex(of: mediaItem) {
            movies.remove(at: index)
        } else if let index = tvShows.firstIndex(of: mediaItem) {
            tvShows.remove(at: index)
        }
        
        CoreDataStack.context.delete(mediaItem)
        CoreDataStack.saveContext()
        //updating source of truth
        fetchMediaItems()
    }
    
    func updateMediaItemReminderDate(_ mediaItem: MediaItem) {
        notificationScheduler.scheduleNotifications(mediaItem: mediaItem)
        CoreDataStack.saveContext()
    }
    
}
