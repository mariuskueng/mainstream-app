//
//  ViewController.swift
//  mainstream-app
//
//  Created by Marius Küng on 24.03.16.
//  Copyright © 2016 Marius Küng. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftDate

class ConcertTableViewController: UITableViewController {
    
    struct TableViewObjects {
        var date : String
        var concerts : [Concert]
    }
    
    var concerts = [TableViewObjects]()
    var concertDict = [String: [Concert]]()
    var cities = [String]()
    var selectedDate = NSDate()
    var filterCity = ""
    
    let dateFormatter = NSDateFormatter()
    let displayDate = NSDateFormatter()
    var apiUrl = "https://arcane-hollows-16881.herokuapp.com"
    
    @IBOutlet weak var cityButton: UIButton!
    @IBOutlet weak var dateTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // http://stackoverflow.com/questions/31136084/how-can-i-group-tableview-items-from-a-dictionary-in-swift
        
        displayDate.dateFormat = "dd.MM.yyyy"
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "Europe/Zurich")
        displayDate.timeZone = NSTimeZone(abbreviation: "Europe/Zurich")
            
//        apiUrl = "http://localhost:3000/"
        
        Alamofire.request(.GET, apiUrl).response {
            request, response, data, error in
            if data != nil && error == nil {
                let json = JSON(data: data!)
                
                // create a dict<date, concerts>
                for (concerts):(String, JSON) in json["concerts"] {
                    let date = String(concerts.1["_id"]).toDate(DateFormat.ISO8601)
                    let formattedDate = date!.toString(DateFormat.Custom("dd.MM.yyyy"))
                
                    if self.concertDict[formattedDate!] == nil {
                        self.concertDict[formattedDate!] = [Concert]()
                        
                        // add concerts to dict
                        for c in concerts.1["concerts"] {
                            self.concertDict[formattedDate!]?.append(
                                Concert(
                                    artist: String(c.1["artist"]),
                                    venue: String(c.1["venue"]),
                                    city: String(c.1["city"])
                                )
                            )
                        }
                        self.concertDict[formattedDate!]?.sortInPlace({$0.city < $1.city})
                    }
                }
                
                self.updateTableView(self.getTableViewObjects(self.concertDict))
                
                self.prepareFilters()
            }
        }

    }
    
    func prepareFilters() {
        let concerts = Array(self.concertDict.values).flatMap{$0}
        self.cities = Array(Set(concerts.map{ c in c.city })).sort(<)
    }
    
    @IBAction func textFieldEditing(sender: UITextField) {
        //Create the view
        let inputView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 240))
        
        let datePickerView  : UIDatePicker = UIDatePicker(frame: CGRectMake(0, 40, 0, 0))
        datePickerView.datePickerMode = UIDatePickerMode.Date
        inputView.addSubview(datePickerView) // add date picker to UIView
        
        let doneButton = UIButton(frame: CGRectMake((self.view.frame.size.width - 100), 0, 100, 50))
        doneButton.setTitle("Done", forState: UIControlState.Normal)
        doneButton.setTitle("Done", forState: UIControlState.Highlighted)
        doneButton.setTitleColor(UIColor(red: 27/255, green: 66/255, blue: 255/255, alpha: 1.0) /* #1b42ff */, forState: UIControlState.Normal)
        doneButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        
        let resetButton = UIButton(frame: CGRectMake(20, 0, 100, 50))
        resetButton.setTitle("Reset filter", forState: UIControlState.Normal)
        resetButton.setTitle("Reset filter", forState: UIControlState.Highlighted)
        resetButton.setTitleColor(UIColor(red: 27/255, green: 66/255, blue: 255/255, alpha: 1.0) /* #1b42ff */, forState: UIControlState.Normal)
        resetButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        
        inputView.addSubview(doneButton) // add Button to UIView
        inputView.addSubview(resetButton) // add Button to UIView
        
        doneButton.addTarget(self, action: #selector(ConcertTableViewController.doneButtonClicked), forControlEvents: UIControlEvents.TouchUpInside) // set button click event
        
        resetButton.addTarget(self, action: #selector(ConcertTableViewController.resetButtonClicked), forControlEvents: UIControlEvents.TouchUpInside) // set button click event
        
        sender.inputView = inputView
        datePickerView.addTarget(self, action: #selector(ConcertTableViewController.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        
        datePickerValueChanged(datePickerView)
    }
    
    func datePickerValueChanged(sender: UIDatePicker) {
        self.dateTextField.text = getFormattedDate(self.displayDate, date: sender.date)
        print("Date picker value changed")
        self.selectedDate = sender.date
    }
    
    func doneButtonClicked(sender: UIButton)
    {
        print("Done button clicked")
        filterByDate()
        self.dateTextField.text = getFormattedDate(self.displayDate, date: self.selectedDate)
        self.dateTextField.resignFirstResponder() // To resign the inputView on clicking done.
    }
    
    func resetButtonClicked(sender: UIButton)
    {
        print("Reset button clicked")
        updateTableView(getTableViewObjects(self.concertDict))
        self.dateTextField.text = ""
        self.dateTextField.resignFirstResponder() // To resign the inputView on clicking done.
    }
    
    func getFormattedDate(formatter: NSDateFormatter, date: NSDate) -> String {
        formatter.timeZone = NSTimeZone(abbreviation: "Europe/Zurich")
        return formatter.stringFromDate(date)
    }
    
    func filterByDate() {
        let date = getFormattedDate(self.displayDate, date: self.selectedDate)
        let filteredConcerts = [date: self.concertDict[date]]
        if ((filteredConcerts.values.first!?.count) != nil) {
            updateTableView(getTableViewObjects(filteredConcerts))
        }
        
    }
    
    func getTableViewObjects(dict: [String: [Concert]?]) -> [TableViewObjects] {
        // convert dict to array
        var concerts = [TableViewObjects]()
        for (key, value) in dict {
            concerts.append(TableViewObjects(date: key, concerts: value!))
        }
        return concerts
    }
    
    func updateTableView(concerts: [TableViewObjects]) {
        self.concerts = concerts
        
        // sort array after date ascending
        self.concerts.sortInPlace({self.displayDate.dateFromString($0.date)?.compare(self.displayDate.dateFromString($1.date)!) == NSComparisonResult.OrderedAscending})
        
        // reload table view to add data
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return concerts.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return concerts[section].concerts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ConcertTableViewCell") as! ConcertTableViewCell
        
        cell.artistLabel.text = concerts[indexPath.section].concerts[indexPath.row].artist
        cell.venueLabel.text = concerts[indexPath.section].concerts[indexPath.row].venue
        cell.cityLabel.text = concerts[indexPath.section].concerts[indexPath.row].city
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return concerts[section].date
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Create a new variable to store the instance of current controller
        let destination = segue.destinationViewController as! UINavigationController
        let cityFilterViewController = destination.topViewController as! CityFilterView
        // send data to controller
        cityFilterViewController.cities = self.cities
    }
    
    @IBAction func filterCity(segue: UIStoryboardSegue)
    {
        if self.filterCity == "Alle" {
            updateTableView(getTableViewObjects(self.concertDict))
        }
        else {
            var filteredConcerts = [String: [Concert]]()
            // iterate over days
            self.concertDict.forEach({
                filteredConcerts[$0] = $1.filter() {concert in
                    concert.city == self.filterCity
                }
                
                if (filteredConcerts[$0]!.count == 0) {
                    filteredConcerts.removeValueForKey($0)
                }
            })
            
            updateTableView(getTableViewObjects(filteredConcerts))
        }
    }

}

