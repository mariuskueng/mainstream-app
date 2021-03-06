//
//  CityFilterView.swift
//  mainstream-app
//
//  Created by Marius Küng on 19.05.16.
//  Copyright © 2016 Marius Küng. All rights reserved.
//

import UIKit

class CityFilterView: UITableViewController {
    var cities = [String]()
    var citiesSorted = [(String, [String])]()
    
    override func viewDidLoad() {
        var citiesDict = [String: [String]]()
        
        for city in cities {
            let index = city.startIndex.advancedBy(0)
            let letter = String(city[index])
            
            if (citiesDict[letter] == nil) {
                citiesDict[letter] = [city]
            } else {
                citiesDict[letter]?.append(city)
            }
        }
        citiesSorted = citiesDict.sort{$0.0 < $1.0}
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return citiesSorted.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesSorted[section].1.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return citiesSorted[section].0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cityCell", forIndexPath: indexPath)
        cell.textLabel?.text = citiesSorted[indexPath.section].1[indexPath.row]
        return cell
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // set destination view
        let destination = segue.destinationViewController as! ConcertTableViewController
        
        // If sender was nav button
        if (sender is UIBarButtonItem) {
            destination.filterCity = "Alle"
        }
        else {
            let cell = sender as! UITableViewCell
            // set filter variable in destination view
            destination.filterCity = (cell.textLabel?.text)!
        }
    }
}
