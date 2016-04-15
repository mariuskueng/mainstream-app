//
//  Concerts.swift
//  mainstream-app
//
//  Created by Marius Küng on 14.04.16.
//  Copyright © 2016 Marius Küng. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class Concerts {
    private var concertDict = [String: [Concert]]()
    private let urlStr = "https://arcane-hollows-16881.herokuapp.com/"
    
    init() {
        
    }
    
    func loadConcerts () {
        Alamofire.request(.GET, urlStr).response { request, response, data, error in
            if data != nil && error == nil {
                let json = JSON(data: data!)

                for (date, concerts):(String, JSON) in json["concerts"] {
                    if self.concertDict[date] == nil {
                        self.concertDict[date] = [Concert]()
                    
                        for c in concerts {
                            self.concertDict[date]?.append(
                                Concert(
                                    artist: String(c.1["artist"]),
                                    venue: String(c.1["venue"]),
                                    city: String(c.1["city"])
                                )
                            )
                        }
                    }
                }
            }
        }
    }
    
    
    func getConcerts () -> [String: [Concert]] {
        return concertDict
    }

}