//
//  EventsCodable.swift
//  itesm_event_listing
//
//  Created by Andrés Villanueva on 4/9/18.
//  Copyright © 2018 Rene Garcia Saenz. All rights reserved.
//

import UIKit

class Event: Codable, NSCopying {
    var id: Int?
    var photoURL: String?
    var name: String?
    var startDate: String?
    var endDate: String?
    var location: String?
    var descrip: String?
    var requirements: String?
    var registrationUrl: String?
    var contactInformation: ContactInformation?
    
    init(id: Int?, photoURL: String?, name: String?, startDate: String?, endDate: String?, location: String?, descrip: String?, requirements: String?, registrationUrl: String?, contactInformation: ContactInformation?) {
        self.id = id
        self.photoURL = photoURL
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.location = location
        self.descrip = descrip
        self.requirements = requirements
        self.registrationUrl = registrationUrl
        self.contactInformation = contactInformation
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Event(id: id, photoURL: photoURL, name: name, startDate: startDate, endDate: endDate,location: location, descrip: descrip, requirements: requirements, registrationUrl: registrationUrl, contactInformation: contactInformation)
        return copy
    }
    
    // Ruta para guardar el archivo
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory,
                                                       in: .userDomainMask).first!
    
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("eventos")
}
