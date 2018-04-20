//
//  EventsCodable.swift
//  itesm_event_listing
//
//  Created by Andrés Villanueva on 4/9/18.
//  Copyright © 2018 Rene Garcia Saenz. All rights reserved.
//

import UIKit

class Event: Codable {
    var id: Int?
    var photoURL: String?
    var name: String?
    var startDate: String?
    var location: String?
    var descrip: String?
    var requirements: String?
    var registrationUrl: String?
    
    init(id: Int, photoURL: String, name: String, startDate: String, location: String?, descrip: String?, requirements: String?, registrationUrl: String?) {
        self.id = id
        self.photoURL = photoURL
        self.name = name
        self.startDate = startDate
        self.location = location
        self.descrip = descrip
        self.requirements = requirements
        self.registrationUrl = registrationUrl
    }
    
    // Ruta para guardar el archivo
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory,
                                                       in: .userDomainMask).first!
    
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("eventos")
    
    enum CodingKeys : String, CodingKey {
        case id
        case photoURL
        case name
        case startDate
        case location
        case descrip
        case requirements
        case registrationUrl
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(photoURL, forKey: .photoURL)
        try container.encode(name, forKey: .name)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(location, forKey: .location)
        try container.encode(descrip, forKey: .descrip)
        try container.encode(requirements, forKey: .requirements)
        try container.encode(registrationUrl, forKey: .registrationUrl)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int?.self, forKey: .id)
        photoURL = try container.decode(String?.self, forKey: .photoURL)
        name = try container.decode(String?.self, forKey: .name)
        startDate = try container.decode(String?.self, forKey: .startDate)
        location = try container.decode(String?.self, forKey: .location)
        descrip = try container.decode(String?.self, forKey: .descrip)
        requirements = try container.decode(String?.self, forKey: .requirements)
        registrationUrl = try container.decode(String?.self, forKey: .registrationUrl)
    }
}
