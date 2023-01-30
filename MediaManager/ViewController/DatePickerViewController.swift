//
//  DatePickerViewController.swift
//  MediaManager
//
//  Created by Dominique Strachan on 1/8/23.
//

import UIKit

//setting up to tell MediaItemDetailVC that reminder has been set
protocol DatePickerDelegate: AnyObject {
    func reminderDateEdited(date: Date)
}

class DatePickerViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var datePicker: UIDatePicker!
    
    //MARK: - Properties
    weak var delegate: DatePickerDelegate?
    var date: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpViews()
    }
    
    func setUpViews() {
        self.datePicker.preferredDatePickerStyle = .wheels
    }
    
    @IBAction func datePickerAdjusted(_ sender: UIDatePicker) {
        //capturing date picker's date value through sender.date
        self.date = sender.date
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        //Guard to make sure you have both a delegate and a date
        guard let delegate = delegate,
              let date = self.date else { return }
        //Assuming you have both, call your reminderDateEdited function and pass in your date
        delegate.reminderDateEdited(date: date)
        //pop your view controller
        navigationController?.popViewController(animated: true)
    }
}
