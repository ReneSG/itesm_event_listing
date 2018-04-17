//
//  EventTableViewCell.swift
//  itesm_event_listing
//
//  Created by Rene Garcia Saenz on 3/13/18.
//  Copyright © 2018 Rene Garcia Saenz. All rights reserved.
//

import UIKit

protocol protocoloFavorito {
    func addFavorito(cell: EventTableViewCell)
}

class EventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var btFavorite: UIButton!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    
    var delagate : protocoloFavorito?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func botonFavorito(_ sender: UIButton) {
        btFavorite.setImage(#imageLiteral(resourceName: "fav_fill"),for: UIControlState.selected)
            delagate?.addFavorito(cell: self)
        
    }
}
