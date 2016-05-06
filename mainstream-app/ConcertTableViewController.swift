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

class ConcertTableViewController: UITableViewController {
    
    struct TableViewObjects {
        var sectionName : String!
        var sectionObjects : [Concert]!
    }
    
    var concertDict = [String: [Concert]]()
    var concertsStorage = [TableViewObjects]()
    var concerts = [TableViewObjects]()
    var cities = []
    var dates = []
    let dateFormatter = NSDateFormatter()
    let displayDate = NSDateFormatter()
    var apiUrl = "https://arcane-hollows-16881.herokuapp.com"
    var selectedDate = NSDate()
    
    @IBOutlet weak var cityButton: UIButton!
    @IBOutlet weak var dateTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // http://stackoverflow.com/questions/31136084/how-can-i-group-tableview-items-from-a-dictionary-in-swift
        
        displayDate.dateFormat = "dd.MM.yyyy"
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//        apiUrl = "http://localhost:5000/"
        
        Alamofire.request(.GET, apiUrl).response {
            request, response, data, error in
            if data != nil && error == nil {
                let json = JSON(data: data!)
                
                // create a dict<date, concerts>
                for (concerts):(String, JSON) in json["concerts"] {
                    let date = String(concerts.1["_id"])
                    if self.concertDict[date] == nil {
                        self.concertDict[date] = [Concert]()
                        
                        // add concerts to dict
                        for c in concerts.1["concerts"] {
                            self.concertDict[date]?.append(
                                Concert(
                                    artist: String(c.1["artist"]),
                                    venue: String(c.1["venue"]),
                                    city: String(c.1["city"])
                                )
                            )
                        }
                        self.concertDict[date]?.sortInPlace({$0.city < $1.city})
                    }
                }
                
                // convert dict to array
                for (key, value) in self.concertDict {
                    self.concertsStorage.append(TableViewObjects(sectionName: key, sectionObjects: value))
                }
                
                // sort array after date ascending
                self.concertsStorage.sortInPlace({$0.sectionName < $1.sectionName})
                
                self.concerts = self.concertsStorage
                
                // reload table view to add data
                self.tableView.reloadData()
                
                self.prepareFilters()
            }
        }

    }
    
    func prepareFilters() {
        let concerts = Array(self.concertDict.values).flatMap{$0}
        self.cities = concerts.map{ c in c.city }
        self.dates = Array(self.concertDict.keys).flatMap{$0}
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
        doneButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        doneButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        
        inputView.addSubview(doneButton) // add Button to UIView
        
        doneButton.addTarget(self, action: #selector(ConcertTableViewController.doneButtonClicked), forControlEvents: UIControlEvents.TouchUpInside) // set button click event
        
        sender.inputView = inputView
        datePickerView.addTarget(self, action: #selector(ConcertTableViewController.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        
        datePickerValueChanged(datePickerView)
    }
    
    func datePickerValueChanged(sender: UIDatePicker) {
        self.dateTextField.text = getFormattedDate(sender.date)
        print("Date picker value changed")
        self.selectedDate = sender.date
    }
    
    func doneButtonClicked(sender:UIButton)
    {
        print("Done button clicked")
//        filterByDate()
        self.dateTextField.text = getFormattedDate(self.selectedDate)
        self.dateTextField.resignFirstResponder() // To resign the inputView on clicking done.
    }
    
    func getFormattedDate(date: NSDate) -> String {
        return self.dateFormatter.stringFromDate(date)
    }
    
    func filterByDate() {
        self.concerts = self.concerts.filter{$0.sectionName == getFormattedDate(self.selectedDate)}
        
        
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
        return concerts[section].sectionObjects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ConcertTableViewCell") as! ConcertTableViewCell
        
        cell.artistLabel.text = concerts[indexPath.section].sectionObjects[indexPath.row].artist
        cell.venueLabel.text = concerts[indexPath.section].sectionObjects[indexPath.row].venue
        cell.cityLabel.text = concerts[indexPath.section].sectionObjects[indexPath.row].city
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = self.dateFormatter.dateFromString(concerts[section].date!)
        let dateString = self.displayDate
            .stringFromDate(date!)
        return dateString
    }


}

