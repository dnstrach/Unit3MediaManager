//
//  HomeTableViewController.swift
//  MediaManager
//
//  Created by Dominique Strachan on 1/4/23.
//

import UIKit

class HomeTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reminderFired), name: Notification.Name(rawValue: "mediaReminderNotification"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        //checking to see if media items were added because haven't set up table view yet for items in sections
//        for item in MediaItemController.shared.mediaItems {
//           print(item.title)
//        }
        tableView.reloadData()
    }
    
    //MARK: - Methods 
    //setting up for selector parameter in addObserver
    @objc func reminderFired() {
        DispatchQueue.main.async {
           self.tableView.backgroundColor = .red
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
           self.tableView.backgroundColor = .systemBackground
           self.view.backgroundColor = .systemBackground
        }
        
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //rows: favs, movies, tvshows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath)

        //naming rows
        if indexPath.row == 0 {
            cell.textLabel?.text = "Favorites"
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "Movies"
        } else {
            cell.textLabel?.text = "TV Shows"
        }
        return cell
    }

    // MARK: - Navigation
    //segue to send media item to media item table view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //what you named segue
        if segue.identifier == "toMediaItemVC" {
            //indexpath for which row user selected
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            //destination
            let destination = segue.destination as! MediaItemTableViewController
            //items being passed over
             destination.items = MediaItemController.shared.sections[indexPath.row]
            
            //destination.section = indexPath.row
        }
    }

}
