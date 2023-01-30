//
//  EditItemViewController.swift
//  MediaManager
//
//  Created by Dominique Strachan on 1/6/23.
//

import UIKit

//protocol to show changes reflected when editing and saving media item
protocol EditItemDelegate: AnyObject {
    //parameters are info when editing media item
    func mediaItemEdited(title: String, rating: Double, year: Int, description: String)
}

class EditItemViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingSlider: UISlider!
    @IBOutlet weak var releaseYearTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    //MARK: Properties
    var mediaItem: MediaItem?
    //hold the new rating value as the user slides the slider
    var ratingValue = 10.0
    //delegate to hold in carrying out protocol
    weak var delegate: EditItemDelegate?
    
    //MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        //guarding to make sure have media item
        guard let mediaItem = mediaItem else { return }
        //setting UI outlets to contain the correct text
        self.titleTextField.text = mediaItem.title
        self.ratingLabel.text = "Rating \(mediaItem.rating)"
        self.ratingSlider.value = Float(mediaItem.rating)
        //set the keyboard type of the release year text field to be a number pad. This will help prevent people from putting in improper data for a release year
        self.releaseYearTextField.text = String(mediaItem.year)
        self.releaseYearTextField.keyboardType = .numberPad
        self.descriptionTextView.text = mediaItem.itemDescription
    }
    
    //MARK: Actions
    //changed sender to UISlider so can access UISlider properties and its values through sender.value
    //extension from addItemVC rounds slider values because slider values are floats
    @IBAction func ratingSliderAdjusted(_ sender: UISlider) {
            //sender.value is a float so converting it to a Double
            let roundedValue = Double(sender.value).roundTo(places: 1)
            //updating rating value to selected value
            ratingValue = roundedValue
            //updating label to follow rating value
            ratingLabel.text = "Rating: \(ratingValue)"
        }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        //guarding to make sure have info when editing media item
        guard let delegate = self.delegate,
              let title = self.titleTextField.text,
              let year = self.releaseYearTextField.text,
              let description = self.descriptionTextView.text
        else { return }
        //converting year to int
        if let year = Int(year) {
            //calling mediaItem edited function on delegate
            delegate.mediaItemEdited(title: title, rating: ratingValue, year: year, description: description)
            //removing vc after clicking done
            self.navigationController?.popViewController(animated: true)
            //handling error to prevent crash
        } else {
            //UIAlertController with needed params
            let alert = UIAlertController(title: "Uh oh!", message: "You input an invalid year", preferredStyle: .alert)
            //way to dismiss alert
            let dismissAction = UIAlertAction(title: "Ok", style: .cancel)
            alert.addAction(dismissAction)
            present(alert, animated: true)
        }
    }
}
