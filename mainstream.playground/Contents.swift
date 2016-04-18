//: Playground - noun: a place where people can play

import UIKit

var formatter = NSDateFormatter()
formatter.dateFormat = "dd.MM.yyyy"
let dateTimePrefix: String = formatter.stringFromDate(NSDate(timeIntervalSince1970: 1473804000))