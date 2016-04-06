//
//  Concert.swift
//  mainstream-app
//
//  Created by Marius Küng on 24.03.16.
//  Copyright © 2016 Marius Küng. All rights reserved.
//

import Foundation

class Concert {
//    var date: String
    var artist: String
    var venue: String
    var city: String
    
    init(artist: String, venue: String, city: String) {
        self.artist = artist
        self.venue = venue
        self.city = city
    }
    
    static func getConcerts () -> [String: [Concert]] {
        return [
            "01.04.2016": [
                Concert(artist: "Secret Sight / Aie Ça Gicle", venue: "Hirscheneck", city: "Basel"),
                Concert(artist: "The Holydrug Couple / Moreeats", venue: "Treppenhaus", city: "Rorschach"),
                Concert(artist: "The Ar-Kaics / James & The Ultrasounds", venue: "Horst", city: "Kreuzlingen")
            ],
            "02.04.2016": [
                Concert(artist: "Gangstarr Foundation feat. Jeru The Damaja, Afu Ra & Big Shug", venue: "Kaserne", city: "Basel"),
                Concert(artist: "Louis Barabbas & The Bedlam Six", venue: "Parterre", city: "Basel"),
                Concert(artist: "DIIV / Ulrika Spacek", venue: "Mascotte", city: "Zürich")
            ],
            "03.04.2016": [
                Concert(artist: "Farao / Dralms", venue: "1. Stock", city: "Münchenstein"),
                Concert(artist: "Louis Barabbas & The Bedlam Six", venue: "El Lokal", city: "Zürich"),
                Concert(artist: "Pere Ubu", venue: "Sedel", city: "Luzern")
            ]
        ]
    }
}