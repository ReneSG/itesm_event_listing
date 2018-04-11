//
//  EventTableViewCell.swift
//  itesm_event_listing
//
//  Created by Rene Garcia Saenz on 3/13/18.
//  Copyright © 2018 Rene Garcia Saenz. All rights reserved.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
