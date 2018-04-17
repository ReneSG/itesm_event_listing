//
//  FavoriteEventsTableViewController.swift
//  itesm_event_listing
//
//  Created by renysg on 4/9/18.
//  Copyright © 2018 Rene Garcia Saenz. All rights reserved.
//

import UIKit
import CoreData

class FavoriteEventsTableViewController: UITableViewController {
    
    var eventsFavoritos = [EventsCodable]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDatos()

        self.title = "Favoritos"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return eventsFavoritos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCell", for: indexPath) as! FavoriteTableViewCell
        
        cell.eventName.text = eventsFavoritos[indexPath.row].name
        cell.eventLocation.text = eventsFavoritos[indexPath.row].location
        cell.eventImage.af_setImage(withURL: URL(string: eventsFavoritos[indexPath.row].photoURL!)!)
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        loadDatos()
    }
    
    func loadDatos()
    {
        eventsFavoritos.removeAll()
        guard let listaEventos = retrieveEvents() else {return}
        
        self.eventsFavoritos = listaEventos
        
        print("hola")
    }

    func retrieveEvents() -> [EventsCodable]? {
        guard let data = NSKeyedUnarchiver.unarchiveObject(withFile: EventsCodable.ArchiveURL.path) as? Data else { return nil }
        do {
            
            let products = try
                PropertyListDecoder().decode([EventsCodable].self, from: data)
            return products
        }
        catch {
            print("Retrieved failed")
            return nil
        }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
