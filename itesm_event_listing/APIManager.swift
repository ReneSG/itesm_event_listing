//
//  APIManager.swift
//  itesm_event_listing
//
//  Created by Rene Garcia Saenz on 3/13/18.
//  Copyright © 2018 Rene Garcia Saenz. All rights reserved.
//

import UIKit
import Alamofire

class APIManager {
    let baseUrl = "https://cartelera-api.herokuapp.com/events"
    static let sharedInstance = APIManager()
    
    func getEvents(completion: @escaping ([Event]) -> Void) {
        Alamofire.request(baseUrl).validate().responseJSON { (response) in
            if let json = response.value as? [[String: Any]] {
                var events = [Event]()
                for eventJSON in json {
                    let event =  Event(id: eventJSON["id"] as! Int,
                                       photoURL: eventJSON["photo"] as! String,
                                       name: eventJSON["name"] as! String,
                                       startDate: "january",
                                       startTime: "123",
                                       location: eventJSON["location"] as? String)
                    events.append(event)
                    completion(events)
                }
            }
        }
    }
}
