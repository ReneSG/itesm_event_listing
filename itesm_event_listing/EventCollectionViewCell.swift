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
    func deleteFavorito(cell: EventCollectionViewCell)
}

class EventCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var btFavorite: UIButton!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventName: UILabel!
    
    @IBOutlet weak var btFavoriteFav: UIButton!
    
    var delagate : protocoloFavorito?
    var isFavorite: Bool!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func botonFavorito(_ sender: UIButton) {
        if !isFavorite
        {
            btFavorite.setImage(#imageLiteral(resourceName: "fav_full-1"),for: .normal)
            isFavorite = true
            delagate?.addFavorito(cell: self)

        }
        else
        {
            //print("Hola")
            btFavorite.setImage(#imageLiteral(resourceName: "fav_empty-1"),for: .normal)
            isFavorite = false
            delagate?.deleteFavorito(cell: self)
        }
        
    }
    
    @IBAction func botonFavoritoDesdeFavorito(_ sender: UIButton) {
        if (btFavoriteFav.currentImage?.isEqual(#imageLiteral(resourceName: "fav_full-1")))!
        {
            delagate?.deleteFavorito(cell: self)
        }
        

    }
}
