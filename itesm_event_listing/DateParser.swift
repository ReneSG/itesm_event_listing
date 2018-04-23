//
//  DateParser.swift
//  itesm_event_listing
//
//  Created by Rene Garcia Saenz on 4/23/18.
//  Copyright © 2018 Rene Garcia Saenz. All rights reserved.
//

import UIKit

class DateParser {
    
    static let sharedInstance = DateParser()
    let dateFormatter = DateFormatter()
    
    func parse(dateAsString: String?) -> Date? {
        let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: dateAsString!)
    }
    
    func parseDateWithDayAndMonthAndTime(dateAsString: String?) -> String {
        let inputFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        dateFormatter.dateFormat = inputFormat
        let eventDate = dateFormatter.date(from: dateAsString!)
        dateFormatter.dateFormat = "dd/MMM' - 'HH:mm"
        return dateFormatter.string(from: eventDate!)
    }
}
