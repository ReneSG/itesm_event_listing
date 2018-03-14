//
//  Event.swift
//  itesm_event_listing
//
//  Created by Rene Garcia Saenz on 3/13/18.
//  Copyright © 2018 Rene Garcia Saenz. All rights reserved.
//

import UIKit

class Event: NSObject {
    var id: Int
    var photoURL: String
    var name: String
    var startDate: String
    var startTime: String
    var location: String?
    
    init(id: Int, photoURL: String, name: String, startDate: String, startTime: String, location: String?) {
        self.id = id
        self.photoURL = photoURL
        self.name = name
        self.startDate = startDate
        self.startTime = startTime
        self.location = location
    }
}
