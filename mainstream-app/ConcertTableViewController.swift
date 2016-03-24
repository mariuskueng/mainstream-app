//
//  ViewController.swift
//  mainstream-app
//
//  Created by Marius Küng on 24.03.16.
//  Copyright © 2016 Marius Küng. All rights reserved.
//

import UIKit

class ConcertTableViewController: UITableViewController {
    
    var concerts = [Concert]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        concerts.append(Concert(date: "", artist: "DIIV", venue: "Mascotte", city: "Zürich"))
        concerts.append(Concert(date: "", artist: "The Libertines / Reverend And The Makers", venue: "X-Tra", city: "Zürich"))
        concerts.append(Concert(date: "", artist: "The Sisters Of Mercy / LSD on CIA", venue: "Fri-Son", city: "Fribourg"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return concerts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let concert = tableView.dequeueReusableCellWithIdentifier("ConcertTableViewCell") as! ConcertTableViewCell
        
        concert.artistLabel.text = concerts[indexPath.row].artist
        concert.venueLabel.text = concerts[indexPath.row].venue
        concert.cityLabel.text = concerts[indexPath.row].city
        
        return concert
    }


}

