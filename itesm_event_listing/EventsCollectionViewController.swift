//
//  EventsCollectionViewController.swift
//  itesm_event_listing
//
//  Created by Rene Garcia Saenz on 4/9/18.
//  Copyright © 2018 Rene Garcia Saenz. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class EventsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, protocoloFavorito {

    var events = [Event]()
    var eventsCodable = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        APIManager.sharedInstance.getEvents { (events) in
            self.events = events
            self.collectionView?.reloadData()
        }
        
        self.title = "Cartelera"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationView = segue.destination as! EventDetailsViewController
        destinationView.event = events[(collectionView?.indexPathsForSelectedItems![0].row)!]
        tabBarController?.tabBar.isHidden = true
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "idCell", for: indexPath) as! EventCollectionViewCell
        
        cell.eventName.text = events[indexPath.row].name
        cell.eventImage.af_setImage(withURL: URL(string: events[indexPath.row].photoURL!)!)
        cell.delagate = self
        cell.layer.borderWidth = CGFloat(0.5)
        cell.layer.borderColor = UIColor.black.cgColor
        return cell
    }

    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewSize = collectionView.frame.size.width
        
        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
    }
    
    // Mark: FavoriteProtocol methods
    func addFavorito(cell: EventCollectionViewCell) {
        guard let indexPath = self.collectionView?.indexPath(for: cell) else {
            return
        }
        let id = events[indexPath.row].id
        let photoURL = events[indexPath.row].photoURL
        let name = events[indexPath.row].name
        let startDate = events[indexPath.row].startDate
        let startTime = events[indexPath.row].startTime
        let location = events[indexPath.row].location
        
        let evento = Event(id: id!, photoURL: photoURL!, name: name!, startDate: startDate!, startTime: startTime!, location: location!)
        
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
}
