//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

var today = NSDate()

var dateAsString = "24-12-2015 23:59"

let dateFormatter = NSDateFormatter()
dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
var newDate = dateFormatter.dateFromString(dateAsString)

let anotherDateFormatter = NSDateFormatter()
anotherDateFormatter.locale = NSLocale(localeIdentifier: "de_DE")
anotherDateFormatter.dateFormat = "dd.MM.YYYY"
var anotherDate = anotherDateFormatter.dateFromString("24.12.2015")