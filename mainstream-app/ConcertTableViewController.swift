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
    let displayDateFormat = DateFormat.Custom("dd.MM.YYYY")
    
    var apiUrl = "https://arcane-hollows-16881.herokuapp.com"
    
    @IBOutlet weak var cityButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // http://stackoverflow.com/questions/31136084/how-can-i-group-tableview-items-from-a-dictionary-in-swift
            
//        apiUrl = "http://localhost:3000/"
        
        Alamofire.request(.GET, apiUrl).response {
            request, response, data, error in
            if data != nil && error == nil {
                let json = JSON(data: data!)
                
                // create a dict<date, concerts>
                for (concerts):(String, JSON) in json["concerts"] {
                    let date = String(concerts.1["_id"]).toDate(DateFormat.ISO8601)
                    let formattedDate = date!.toString(self.displayDateFormat)
                
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
    
    func getFormattedDate(formatter: NSDateFormatter, date: NSDate) -> String {
        formatter.timeZone = NSTimeZone(abbreviation: "Europe/Zurich")
        return formatter.stringFromDate(date)
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
        
        let displayDate = NSDateFormatter()
        displayDate.dateFormat = "dd.MM.yyyy"

        // sort array after date ascending
        self.concerts.sortInPlace({displayDate.dateFromString($0.date)?.compare(displayDate.dateFromString($1.date)!) == NSComparisonResult.OrderedAscending})
        
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
        print(segue.identifier)
        if segue.identifier == "segueToDatePicker" {
            print("segue to datepickerview")
            let destination = segue.destinationViewController as! UINavigationController
            let datePickerViewController = destination.topViewController as! DatePickerView
            
            let dates = Array(self.concertDict.keys).flatMap{$0}
            datePickerViewController.dateStrings = dates
        }
        if segue.identifier == "segueToCityFilter" {
            print("segue to cityfilterview")
            // Create a new variable to store the instance of current controller
            let destination = segue.destinationViewController as! UINavigationController
            let cityFilterViewController = destination.topViewController as! CityFilterView
            // send data to controller
            cityFilterViewController.cities = self.cities
        }
    }
    
    @IBAction func filterCity(segue: UIStoryboardSegue)
    {
        if self.filterCity == "Alle" {
            updateTableView(getTableViewObjects(self.concertDict))
            self.cityButton.setTitle("Alle Städte", forState: .Normal)
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
            self.cityButton.setTitle(self.filterCity, forState: .Normal)
        }
    }
    
    @IBAction func filterByDate(segue: UIStoryboardSegue)
    {
        print("Selected date: \(selectedDate)")
        let date = self.selectedDate.toString(displayDateFormat)!
        self.dateButton.setTitle(date, forState: .Normal)
        let filteredConcerts = [date: self.concertDict[date]]
        if ((filteredConcerts.values.first!?.count) != nil) {
            updateTableView(getTableViewObjects(filteredConcerts))
        }
    }
    @IBAction func resetAllFilters(sender: AnyObject) {
        updateTableView(getTableViewObjects(self.concertDict))
    }

}

