//
//  EventsTableViewController.swift
//  itesm_event_listing
//
//  Created by Rene Garcia Saenz on 3/13/18.
//  Copyright © 2018 Rene Garcia Saenz. All rights reserved.
//

import UIKit

class EventsTableViewController: UITableViewController, protocoloFavorito{
    
    
    var events = [Event]()
    
    var eventsCodable = [EventsCodable]()

    override func viewDidLoad() {
        super.viewDidLoad()
        APIManager.sharedInstance.getEvents { (events) in
            self.events = events
            self.tableView.reloadData()
        }
        
        self.title = "Cartelera"
    }

    func addFavorito(cell: EventTableViewCell) {
        //Sacar el renglon en donde esta el favorito
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            return
        }
    
        
        let id = events[indexPath.row].id
        let photoURL = events[indexPath.row].photoURL
        let name = events[indexPath.row].name
        let startDate = events[indexPath.row].startDate
        let startTime = events[indexPath.row].startTime
        let location = events[indexPath.row].location
        
        let evento = EventsCodable(id: id, photoURL: photoURL, name: name, startDate: startDate, startTime: startTime, location: location)
        
        eventsCodable.append(evento)
        
        //print("Button tapped on row \(indexPath.row)")
        
        storeEvents()
    }
    
    func storeEvents() {
        do {
            let data = try PropertyListEncoder().encode(eventsCodable)
            let success = NSKeyedArchiver.archiveRootObject(data, toFile:
                EventsCodable.ArchiveURL.path)
            print(success ? "Successful save" : "Save failed")
        }
        catch {
            print("Save failed")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCell", for: indexPath) as! EventTableViewCell

        cell.eventLocation.text = events[indexPath.row].location
        cell.eventName.text = events[indexPath.row].name
        cell.eventImage.af_setImage(withURL: URL(string: events[indexPath.row].photoURL)!)
        
        cell.delagate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationView = segue.destination as! EventDetailsViewController
        destinationView.event = events[(tableView.indexPathForSelectedRow?.row)!]
    }

}
