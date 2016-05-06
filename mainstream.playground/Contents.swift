//: Playground - noun: a place where people can play

import UIKit

var formatter = NSDateFormatter()
formatter.dateFormat = "dd.MM.YYYY"
let dateTimePrefix: String = formatter.stringFromDate(NSDate(timeIntervalSince1970: 1473804000))

let dateFormatter = NSDateFormatter()
dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
let anotherDate = dateFormatter.dateFromString("2016-04-26T22:00:00.000Z")

