//
//  APIRequest.swift
//  mainstream-app
//
//  Created by Marius Küng on 14.04.16.
//  Copyright © 2016 Marius Küng. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class APIRequest: NSObject {
    func performRequest() {
        let urlStr = "https://arcane-hollows-16881.herokuapp.com/"

        Alamofire.request(.GET, urlStr).response { request, response, data, error in
            if data != nil && error == nil {
                let json = JSON(data: data!)
                print("Received JSON: %@", json)
            }
        }
    }
}