//
//  NotificationScheduler.swift
//  MediaManager
//
//  Created by Dominique Strachan on 1/8/23.
//

import UserNotifications

class NotificationScheduler {
    
    //function is called in update func in MediaItemController
    func scheduleNotifications(mediaItem: MediaItem) {
        
        //Guard to make sure you can get the reminderDate and identifier
        guard let reminderDate = mediaItem.reminderDate,
            let identifier = mediaItem.id?.uuidString else { return }
        
        //At any point in time, when a user creates a reminder to watch a movie, there might have already been a reminder. So, you will want to override that, which means, whenever you go to schedule a notification, you first need to clear any existing one for that item).
        clearNotifications(mediaItem: mediaItem)
        
        //content, trigger, fireDateComponents and request needed to create a notification request
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "Don't forget to watch \(mediaItem.title ?? "--missing movie/show title--")"
        content.sound = .default
        content.categoryIdentifier = "MediaItemNotification"
        
        let fireDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: fireDateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
       
        //add a notification request
        //this method requires a request. To create a request you need an identifier (which you already have), content, and a trigger, etc…
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Unable to add notification request, \(error.localizedDescription)")
            }
        }
    }
    
    func clearNotifications(mediaItem: MediaItem) {
        
        //guard to make sure you can get the uuidString off of your mediaItem
        guard let identifier = mediaItem.id?.uuidString else { return }
        //remove all pending notification requests that contain that identifier
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}
