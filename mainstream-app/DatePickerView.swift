//
//  DatePickerView.swift
//  mainstream-app
//
//  Created by Marius Küng on 25.05.16.
//  Copyright © 2016 Marius Küng. All rights reserved.
//

import UIKit
import SwiftDate

class DatePickerView: UIViewController {
    
    var dateStrings = ["String"]
    var dates = [NSDate]()
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        dates = dateStrings.map {dateString in
            return dateString.toDate(DateFormat.Custom("dd.MM.yyyy"))!
        }
        dates.sortInPlace(<)
        
        self.datePicker.minimumDate = dates.first
        self.datePicker.maximumDate = dates.last
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func datePickerValueChanged(sender: UIDatePicker) {
        print(sender.date)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // set destination view
        let destination = segue.destinationViewController as! ConcertTableViewController
        destination.selectedDate = self.datePicker.date
    }
    
    
}