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
    var concerts = [TableViewObjects]()
    let dateFormatter = NSDateFormatter()
    
    @IBOutlet weak var cityButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // http://stackoverflow.com/questions/31136084/how-can-i-group-tableview-items-from-a-dictionary-in-swift
        
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        Alamofire.request(.GET, "https://arcane-hollows-16881.herokuapp.com").response {
            request, response, data, error in
            if data != nil && error == nil {
                let json = JSON(data: data!)
                
                // create a dict<date, concerts>
                for (date, concerts):(String, JSON) in json["concerts"] {
                    if self.concertDict[date] == nil {
                        self.concertDict[date] = [Concert]()
                        
                        // add concerts to dict
                        for c in concerts {
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
                    self.concerts.append(TableViewObjects(sectionName: key, sectionObjects: value))
                }
                
                // sort array after date ascending
                self.concerts.sortInPlace({$0.sectionName < $1.sectionName})
                
                // reload table view to add data
                self.tableView.reloadData()
            }
        }
//
//        let allConcerts = Array(concerts.values).flatMap{$0}
//        let cities = allConcerts.map{ c in c.city}
//        print(cities)
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
        let dateString = self.dateFormatter
            .stringFromDate(NSDate(timeIntervalSince1970:
                Double(concerts[section].sectionName)!
            ))
        return dateString
    }


}

