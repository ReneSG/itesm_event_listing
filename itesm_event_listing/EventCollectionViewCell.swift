//
//  EventTableViewCell.swift
//  itesm_event_listing
//
//  Created by Rene Garcia Saenz on 3/13/18.
//  Copyright © 2018 Rene Garcia Saenz. All rights reserved.
//

import UIKit

protocol protocoloFavorito {
    func addFavorito(cell: EventCollectionViewCell)
}

class EventCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var btFavorite: UIButton!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventName: UILabel!
    
    var delagate : protocoloFavorito?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func botonFavorito(_ sender: UIButton) {
        btFavorite.setImage(#imageLiteral(resourceName: "fav_fill"),for: .normal)
        delagate?.addFavorito(cell: self)
    }
}
