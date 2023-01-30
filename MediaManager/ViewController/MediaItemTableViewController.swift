//
//  MediaItemTableViewController.swift
//  MediaManager
//
//  Created by Dominique Strachan on 1/5/23.
//


//You may notice, however, if you were to navigate from the detail view back to the media item table view, any changes you made to the title or rating would not be reflected here. Don’t worry about this just yet. After part 3, you will have some different ideas on how you can fix this, and I challenge you to make that fix at the completion of the project.

import UIKit

class MediaItemTableViewController: UITableViewController {

    //MARK: - Properties
    //array of data so can be optional or empty array
    //placeholder needs for number of rows and cell for row at
    var items: [MediaItem] = []
    
//    //if fthe section int is zero then its the favorite's section
//    var section: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
        super.viewWillAppear(true)
        tableView.reloadData()
        
//        if section == 0 {
//            items = items.filter({$0.isFavorite == true})
//
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mediaItemCell", for: indexPath)

        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = String(item.rating)

        return cell
    }
    
    //error
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let mediaItem = MediaItemController.shared.sections[indexPath.section][indexPath.row]
//            MediaItemController.shared.deleteMediaItem(mediaItem)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//        }
//    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMediaItemDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow
            else { return }
            let destination = segue.destination as! MediaItemDetailViewController
            //tell the destination that it’s delegate variable can be set to self
            //setting destinations delegate variable to MediaItemTableViewController
            //must create extension below or error
            destination.deleteDelegate = self
            //destination.removeFavDelegate = self
            //not referencing the source of truth in the MediaItemController, because that has ALL items. Instead, you will want to reference the placeholder variable in this file, holding all the items that were sent to it
            destination.mediaItem = items[indexPath.row]
        }
    }
} //end of class

//providing instructions for deleteItem function
extension MediaItemTableViewController: DeleteItemDelegate {
    func deleteItem(mediaItem: MediaItem) {
        guard let index = items.firstIndex(of: mediaItem) else {
            return }
        items.remove(at: index)
        tableView.reloadData()
    }
}

////ADDED CODE
//extension MediaItemTableViewController: FavoriteItemDelegate {
//    func removeFavItem(mediaItem: MediaItem) {
//        guard let index = items.firstIndex(of: mediaItem) else {
//            return }
//        items[index].isFavorite = false
//        //items.remove(at: index)
//        tableView.reloadData()
//    }
//}
