//
//  Concert.swift
//  mainstream-app
//
//  Created by Marius Küng on 24.03.16.
//  Copyright © 2016 Marius Küng. All rights reserved.
//

import Foundation

class Concert {
    var date: String
    var artist: String
    var venue: String
    var city: String
    
    init(date: String, artist: String, venue: String, city: String) {
        self.date = date
        self.artist = artist
        self.venue = venue
        self.city = city
    }
}