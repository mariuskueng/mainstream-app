//
//  ViewController.swift
//  mainstream-app
//
//  Created by Marius Küng on 24.03.16.
//  Copyright © 2016 Marius Küng. All rights reserved.
//

import UIKit

class ConcertTableViewController: UITableViewController {
    
    struct Objects {
        
        var sectionName : String!
        var sectionObjects : [Concert]!
    }
    
    var objectArray = [Objects]()
    
    @IBOutlet weak var cityButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // http://stackoverflow.com/questions/31136084/how-can-i-group-tableview-items-from-a-dictionary-in-swift
        
        let concerts = Concerts()
        concerts.loadConcerts()
        
        print(concerts.getConcerts())
        
        for (key, value) in concerts.getConcerts() {
            print("\(key) -> \(value)")
            objectArray.append(Objects(sectionName: key, sectionObjects: value))
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
        return objectArray.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectArray[section].sectionObjects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ConcertTableViewCell") as! ConcertTableViewCell
        
        cell.artistLabel.text = objectArray[indexPath.section].sectionObjects[indexPath.row].artist
        cell.venueLabel.text = objectArray[indexPath.section].sectionObjects[indexPath.row].venue
        cell.cityLabel.text = objectArray[indexPath.section].sectionObjects[indexPath.row].city
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return objectArray[section].sectionName
    }


}

