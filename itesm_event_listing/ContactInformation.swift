//
//  ContactInformation.swift
//  itesm_event_listing
//
//  Created by Rene Garcia Saenz on 4/19/18.
//  Copyright © 2018 Rene Garcia Saenz. All rights reserved.
//

import UIKit

class ContactInformation: Codable {
    var name: String?
    var email: String?
    var phone: String?
    var twitterUrl: String?
    var fbUrl: String?
    
    init(name: String?, email: String?, phone: String?, twitterUrl: String?, fbUrl: String?) {
        self.name = name
        self.email = email
        self.phone = phone
        self.twitterUrl = twitterUrl
        self.fbUrl = fbUrl
    }
}
