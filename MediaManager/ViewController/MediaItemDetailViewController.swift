//
//  MediaItemDetailViewController.swift
//  MediaManager
//
//  Created by Dominique Strachan on 1/5/23.
//

import UIKit

//protocol so that mediaItem is removed when going back to table view
protocol DeleteItemDelegate: AnyObject {
    func deleteItem(mediaItem: MediaItem)
}

////ADDED CODE
////protocol so that unFav mediaItem is removed when going back to table view
//protocol FavoriteItemDelegate: AnyObject {
//    func removeFavItem(mediaItem: MediaItem)
//}

class MediaItemDetailViewController: UIViewController {

    //MARK: - Outlets
    //outlets for UI elements except edit bar button
    @IBOutlet weak var mediaItemLabel: UILabel!
    @IBOutlet weak var mediaItemRatingLabel: UILabel!
    @IBOutlet weak var mediaItemYearLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionTextBox: UITextView!
    @IBOutlet weak var addToFavButton: UIButton!
    @IBOutlet weak var addWatchReminderButton: UIButton!
    @IBOutlet weak var markAsWatchedButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    //MARK: - Properties
    //placeholder variable that will hold a media item. This should be optional, because until the segue is called and an item is passed over, it will have a value of nil.
    var mediaItem: MediaItem?
    weak var deleteDelegate: DeleteItemDelegate?
//    //ADDED CODE
//    weak var removeFavDelegate: FavoriteItemDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
//        //ADDED CODE
//        setFavButtonTitle()
    }
    
    func setUpViews() {
        //Guard to make sure there is in fact a media item
        guard let mediaItem else { return }
        
        //Update each of the labels with the correct data from the media item
        self.mediaItemLabel.text = mediaItem.title
        self.mediaItemRatingLabel.text = String(mediaItem.rating)
        self.mediaItemYearLabel.text = "Released in \(String(mediaItem.year))"
        self.descriptionTextBox.text = mediaItem.itemDescription
        //Set the description text view to not be editable
        descriptionTextBox.isEditable = false
        
        //ADDED CODE
        if mediaItem.reminderDate == nil {
            addWatchReminderButton.setTitle("Add Watch Reminder", for: .normal)
        } else {
            addWatchReminderButton.setTitle("Edit Watch Reminder", for: .normal)
        }
        
        
        //If the media item is a movie, set the delete button to say Delete Movie, other wiser, set it to say Delete TV Show
        if mediaItem.mediaType == "Movie" {
            self.deleteButton.setTitle("Delete Movie", for: .normal)
        } else {
            self.deleteButton.setTitle("Delete TV Show", for: .normal)
        }
        
        //If the media item is a favorite, set the add to favorites button to say Remove From Favorites, otherwise, set it to say Add To Favorites
        if mediaItem.isFavorite == true {
            self.addToFavButton.setTitle("Remove from Favorites", for: .normal)
        } else {
            self.addToFavButton.setTitle("Add to Favorites", for: .normal)
        }
        
        //If the media item is marked as watched, set the mark as watched button to say Mark As Unwatched, otherwise, set it to say Mark As Watched
        if mediaItem.wasWatched == true {
            self.markAsWatchedButton.setTitle("Mark as Unwatched", for: .normal)
        } else {
            self.markAsWatchedButton.setTitle("Mark as Watched", for: .normal)
        }
    }
    
    //MARK: Actions
    @IBAction func favButtonTapped(_ sender: Any) {
        //Guard to make sure you do in fact have access to a media item
        guard let mediaItem = mediaItem else { return }
        
        //If the item’s isFavorite property is set to true, set it to false, otherwise, set it to true
        mediaItem.isFavorite = !mediaItem.isFavorite
        //calling on update function before updating any views
        MediaItemController.shared.updateMediaItem()
//        //ADDED CODE
//        removeFavDelegate?.removeFavItem(mediaItem: mediaItem)
        //depending on the new status of the isFavorite property, update the add favorite button’s title
        //guard let mediaItem = mediaItem else { return }
        if mediaItem.isFavorite {
            DispatchQueue.main.async {
                self.addToFavButton.setTitle("Remove From Favorites", for: .normal)
            }
        } else {
            DispatchQueue.main.async {
                self.addToFavButton.setTitle("Add To Favorites", for: .normal)
            }
        }
//        //ADDED CODE
//        setFavButtonTitle()
    }
    
//    //ADDED CODE
//    func setFavButtonTitle () {
//        guard let mediaItem = mediaItem else { return }
//        if mediaItem.isFavorite {
//            DispatchQueue.main.async {
//                self.addToFavButton.setTitle("Remove From Favorites", for: .normal)
//            }
//        } else {
//            DispatchQueue.main.async {
//                self.addToFavButton.setTitle("Add To Favorites", for: .normal)
//            }
//        }
//    }

    
    @IBAction func markWatchedButtonTapped(_ sender: Any) {
        //Guard to make sure you do in fact have access to a media item
        guard let mediaItem = mediaItem else { return }
        
        //If the item’s wasWatched property is set to true, set it to false, otherwise, set it to true.
        mediaItem.wasWatched = !mediaItem.wasWatched
        //call the updateMediaItem function in MediaItemController before updating any views
        MediaItemController.shared.updateMediaItem()
        //depending on the new status of the wasWatched property, update the mark as watched button’s title
        if mediaItem.wasWatched {
            self.markAsWatchedButton.setTitle("Mark as Unwatched", for: .normal)
        } else {
            self.markAsWatchedButton.setTitle("Mark as Watched", for: .normal)
        }
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        //able to guard because created deleteItem function in media controller passing in media item and saving to coredata and fetchmediaItems
        //Guard to make sure you do in fact have access to a media item
        guard let mediaItem = mediaItem else { return }
        //passing mediaItem for delete function
        MediaItemController.shared.deleteMediaItem(mediaItem)
        //telling delegate whoever is assigned to that role, that the deleteItem function is being called and should do assigned instructions
        deleteDelegate?.deleteItem(mediaItem: mediaItem)
        //prevent user from staying on deleted item view after deleting
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //guarding to make sure we have media item
        guard let mediaItem = mediaItem else { return }
        
        //identifier
        if segue.identifier == "toEditItemVC" {
            //destination
            let destination = segue.destination as! EditItemViewController
            //delegate for displaying edited media item
            destination.delegate = self
            //object being passed over
            destination.mediaItem = mediaItem
        } else if segue.identifier == "toReminderView" {
            let destination = segue.destination as! DatePickerViewController
            destination.delegate = self
            destination.date = mediaItem.reminderDate
        }
    }
} //end of class

//extension to conform to EditDetailDelegate
extension MediaItemDetailViewController: EditItemDelegate {
    func mediaItemEdited(title: String, rating: Double, year: Int, description: String) {
        //Guard to make sure you have access to the MediaItemDetailViewController’s mediaItem.
        guard let mediaItem = self.mediaItem else { return }
        //Update that mediaItem with the new title, rating, release year, and description
        mediaItem.title = title
        mediaItem.rating = rating
        mediaItem.year = Int64(year)
        mediaItem.itemDescription = description
        
        MediaItemController.shared.updateMediaItem()
        //will update UI
        setUpViews()
    }
}

//giving reminderDateEdited function its directions
//setting up MediaItemDetailVC to contain DatePickerDelegate class or else can not assign this VC as delegate
extension MediaItemDetailViewController: DatePickerDelegate {
    func reminderDateEdited(date: Date) {
        //guard to make sure you have a media item
        guard let mediaItem = self.mediaItem else { return }
        //Set the media item’s reminder date to the date passed into the reminderDateEdited function
        mediaItem.reminderDate = date
        //Change the addWatchReminderButton to say Edit Watch Reminder
        addWatchReminderButton.setTitle("Edit Watch Reminder", for: .normal)
        //after adding notification scheduler in update func in mediacontroller can now call on it here
        MediaItemController.shared.updateMediaItemReminderDate(mediaItem)
    }
}


