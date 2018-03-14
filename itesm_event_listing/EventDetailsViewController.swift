//
//  EventDetailsViewController.swift
//  itesm_event_listing
//
//  Created by Rene Garcia Saenz on 3/13/18.
//  Copyright © 2018 Rene Garcia Saenz. All rights reserved.
//

import AlamofireImage
import FacebookShare
import UIKit

class EventDetailsViewController: UIViewController {
    
    var event: Event!

    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventStartDate: UILabel!
    @IBOutlet weak var eventStartTime: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        eventImage.af_setImage(withURL: URL(string: event.photoURL)!)
        eventName.text = event.name
        eventLocation.text = event.location
        eventStartDate.text = event.startDate
        eventStartTime.text = event.startTime
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func shareOnFacebook(_ sender: Any) {
        if !UIApplication.shared.canOpenURL(URL(string: "fbauth2://")!) {
            print("Facebook is not installed")
        } else {
            let shareDialog = ShareDialog(content: PhotoShareContent(photos: [Photo(image: eventImage.image!, userGenerated: true)]))
            shareDialog.mode = .native
            shareDialog.failsOnInvalidData = true
            shareDialog.completion = { result in
            // Handle share results
            }
            
            do {
                try shareDialog.show()
            } catch {
                print("Error displaying share dialog")
            }
        }
    }
    
    @IBAction func shareOnTwitter(_ sender: Any) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
