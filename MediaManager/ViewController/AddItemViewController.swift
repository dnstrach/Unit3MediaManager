//
//  AddItemViewController.swift
//  MediaManager
//
//  Created by Dominique Strachan on 1/4/23.
//

import UIKit

class AddItemViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: - Outlets
    @IBOutlet weak var movieCheckButton: UIButton!
    @IBOutlet weak var tvShowCheckButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var yearPicker: UIPickerView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingSlider: UISlider!
    @IBOutlet weak var isFavSegmented: UISegmentedControl!
    @IBOutlet weak var isWatchedSegmented: UISegmentedControl!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    //MARK: - Properties
    //stores user selected year value and default set equal to current year
    var yearPickerValue = Calendar.current.component(.year, from: Date())
    //variable for tracking if mediaItem is a movie or show with default value
    var isMovie = true
    //tracking value from UI rating slider with default value
    var ratingValue = 10.0
    //tracking if media item is fav with default value
    var isFavorite = true
    //tracking if media item was watched with default value
    var wasWatched = true
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        //addItemVC is delegate and datasource for year picker
        self.yearPicker.delegate = self
        self.yearPicker.dataSource = self
        
        //showing tv show btn as unchecked or else both are checked
        self.tvShowCheckButton.imageView?.image = UIImage(systemName: "circle")
    }
    
    //MARK: - Delegate Methods
    //1 because only changing the year
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //using calendar components method to calculate current year
        let currentYear = Calendar.current.component(.year, from: Date())
        //year 1799 is at index 0
        //subtracting current year - 1799 will populate correct row index
        return currentYear - 1799
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //current year - row index
        //example 2023 - 0 --> first row
        let year = Calendar.current.component(.year, from: Date()) - row
        return String(year)
    }
    
    //tracking which year the user selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //example user picked year 2010: 2023 - 13 because 2010 is on row 13
        yearPickerValue = Calendar.current.component(.year, from: Date()) - row
    }
    
    //MARK: Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        //checking for required info to create media item or will return blank instead of crashing
        guard let title = titleTextField.text,
           let mediaType = isMovie ? "Movie" : "TV Show",
           let itemDescription = descriptionTextView.text else { return }

        //creating new media item and adding it to array and coredata through create function
        MediaItemController.shared.createMediaItem(title: title, mediaType: mediaType, year: yearPickerValue, itemDescription: itemDescription, rating: ratingValue, wasWatched: wasWatched, isFavorite: isFavorite)

        //dismissing add view controller after clicking save btn
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func movieCheckButtonTapped(_ sender: Any) {
        //if movie then check in circle
        self.movieCheckButton.imageView?.image = UIImage(systemName: "checkmark.circle")
        //if movie then open circle for show
        self.tvShowCheckButton.imageView?.image = UIImage(systemName: "circle")
        //tapping movie button means movie is set to true
        self.isMovie = true
    }
    
    @IBAction func tvShowCheckButtonTapped(_ sender: Any) {
        //if show then check in circle
        self.tvShowCheckButton.imageView?.image = UIImage(systemName: "checkmark.circle")
        //if movie then open circle for movie
        self.movieCheckButton.imageView?.image = UIImage(systemName: "circle")
        //tapping show button means movie is set to false
        self.isMovie = false
    }
    
    //changed sender to UISlider so can access UISlider properties and its values through sender.value
    //extension at bottom rounds slider values because slider values are floats
    @IBAction func ratingSliderChanged(_ sender: UISlider) {
        //sender.value is a float so converting it to a Double
        let roundedValue = Double(sender.value).roundTo(places: 1)
        //updating rating value to selected value
        ratingValue = roundedValue
        //updating label to follow rating value
        ratingLabel.text = "Rating: \(ratingValue)"
    }
    
    //changed sender to UISegmentedControl to access its properties
    @IBAction func isFavSwitched(_ sender: UISegmentedControl) {
        //selectedSegmentIndex is built into UI segment control
        //0 is first option - yes
        if sender.selectedSegmentIndex == 0 {
            isFavorite = true
        //1 is second option - no
        } else {
            isFavorite = false
        }
    }
    
    @IBAction func isWatchedSwitched(_ sender: UISegmentedControl) {
        //selectedSegmentIndex is built into UI segment control
        //0 is first option - yes
        if sender.selectedSegmentIndex == 0 {
            wasWatched = true
        //1 is second option - no
        } else {
            wasWatched = false
        }
    }

} //end of class

//to round slider values to decimal places
//The function takes in a parameter called places, and uses the pow function to determine the divisor. For example, if the places was 2, it would calculate 10.0 to the power of 2.0 and result in 100.0. On the other hand, if the places were 3, it would calculate 10.0 to the power of 3.0 and result in 1000.0. Because we want to round to 1 place, the result would be 10.0. Then, it will take our value, let’s say 9.12345 and multiply it by the divisor (in this case 10.0), which will result in 91.2345. It will then round that number and get 91.0. Finally, it will divide 91.0 by 10.0 and result in 9.1
extension Double {
    //roundTo function can be called on any double
   func roundTo(places:Int) -> Double {
      let divisor = pow(10.0, Double(places))
      return (self * divisor).rounded() / divisor
   }
}
