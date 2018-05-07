//
//  EventsCollectionViewController.swift
//  itesm_event_listing
//
//  Created by Rene Garcia Saenz on 4/9/18.
//  Copyright © 2018 Rene Garcia Saenz. All rights reserved.
//

import UIKit


private let reuseIdentifier = "Cell"


class EventsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIViewControllerPreviewingDelegate, protocoloFavorito {
    

    var events = [Event]()
    var eventsCodable = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(traitCollection.forceTouchCapability == .available) {
            registerForPreviewing(with: self, sourceView: view)
        }
        APIManager.sharedInstance.getEvents { (events) in
            self.events = events
            self.collectionView?.reloadData()
        }
        
        self.title = "Cartelera"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            let destinationView = segue.destination as! EventDetailsViewController
            destinationView.event = events[(collectionView?.indexPathsForSelectedItems![0].row)!]
            tabBarController?.tabBar.isHidden = true
        }
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
        cell.isFavorite = false
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

        let evento = events[indexPath.row].copy() as! Event
        
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
        
        let evento = events[indexPath.row].copy() as! Event
        
        let indexCodable = eventsCodable.index(where: {$0.id! == evento.id!})
        
        let intValue = eventsCodable.startIndex.distance(to: (indexCodable)!)
        
        //Borrar el arreglo
        eventsCodable.remove(at: intValue)
        
        //Guardar los events
        storeEvents()
    }
    
    
    // MARK: UIViewControllerPreviewingDelegate methods
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = collectionView?.indexPathForItem(at: location) else { return nil }
        
        guard let cell = collectionView?.cellForItem(at: indexPath) else { return nil }
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "EventDetail") as? EventDetailsViewController else { return nil }
        
        detailVC.event = events[indexPath.row]
        detailVC.preferredContentSize = CGSize(width: 0.0, height: 425)
        previewingContext.sourceRect = cell.frame
        return detailVC
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
        tabBarController?.tabBar.isHidden = true
        showDetailViewController(navigationController!, sender: self)
    }
    
    // MARK: Orientation
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    override var shouldAutorotate: Bool {
        return false
    }
}
