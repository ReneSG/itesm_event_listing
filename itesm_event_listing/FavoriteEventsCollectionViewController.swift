//
//  FavoriteEventsCollectionViewController.swift
//  itesm_event_listing
//
//  Created by renysg on 4/9/18.
//  Copyright © 2018 Rene Garcia Saenz. All rights reserved.
//

import UIKit
import CoreData

class FavoriteEventsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout,protocoloFavorito{    
    var eventsFavoritos = [Event]()
    var eventsCodable = [Event]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDatos()

        self.title = "Favoritos"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - collection view data source

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventsFavoritos.count
    } 

    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "idCell", for: indexPath) as! EventCollectionViewCell
        
        cell.eventName.text = eventsFavoritos[indexPath.row].name
        cell.eventImage.af_setImage(withURL: URL(string: eventsFavoritos[indexPath.row].photoURL!)!)
        cell.layer.borderWidth = CGFloat(0.5)
        cell.layer.borderColor = UIColor.black.cgColor
        cell.delagate = self
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewSize = collectionView.frame.size.width
        
        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView?.reloadData()
        loadDatos()
    }
    
    func loadDatos()
    {
        eventsFavoritos.removeAll()
        guard let listaEventos = retrieveEvents() else {return}
        self.eventsFavoritos = listaEventos
    }

    func retrieveEvents() -> [Event]? {
        guard let data = NSKeyedUnarchiver.unarchiveObject(withFile: Event.ArchiveURL.path) as? Data else { return nil }
        do {
            
            let products = try
                PropertyListDecoder().decode([Event].self, from: data)
            return products
        }
        catch {
            print(error)
            return nil
        }
    }
    
    // Mark: FavoriteProtocol methods
    func addFavorito(cell: EventCollectionViewCell) {
        guard let indexPath = self.collectionView?.indexPath(for: cell) else {
            return
        }
        
        let evento = eventsFavoritos[indexPath.row].copy() as! Event
        
        eventsCodable.append(evento)
        
        storeEvents()
    }
    
    func storeEvents() {
        do {
            let data = try PropertyListEncoder().encode(eventsCodable)
            let success = NSKeyedArchiver.archiveRootObject(data, toFile:
                Event.ArchiveURL.path)
            print(success ? "Successful save" : "Save failed")
        }
        catch {
            print("Save failed")
        }
    }
    
    // Mark: FavoriteDeleteProtocol methods
    func deleteFavorito(cell: EventCollectionViewCell) {
        guard let indexPath = self.collectionView?.indexPath(for: cell) else {
            return
        }
        
        let indiceBorrar = indexPath.row

        eventsFavoritos.remove(at: indiceBorrar)
        //Guardar los events
        storeEvents()
        loadDatos()
        collectionView?.reloadData()
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationView = segue.destination as! EventDetailsViewController
        destinationView.event = eventsFavoritos[(collectionView?.indexPathsForSelectedItems![0].row)!]
        tabBarController?.tabBar.isHidden = true
        
    }
    
}
