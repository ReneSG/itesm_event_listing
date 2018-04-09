//
//  EventDetailsViewController.swift
//  itesm_event_listing
//
//  Created by Rene Garcia Saenz on 3/13/18.
//  Copyright © 2018 Rene Garcia Saenz. All rights reserved.
//

import AlamofireImage
import FacebookShare
import GoogleAPIClientForREST
import GoogleSignIn
import UIKit

class EventDetailsViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {

    var event: Event!

    private let scopes = ["https://www.googleapis.com/auth/calendar"]

    private let service = GTLRCalendarService()
    let signInButton = GIDSignInButton()
    let output = UITextView()

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

        // Configure Google Sign-in.
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = scopes

        // Add the sign-in button
        let viewHeight = view.frame.size.height
        signInButton.frame = CGRect(x: self.view.center.x-(50), y: viewHeight - 110 , width: 80, height: 50)
        view.addSubview(signInButton)
        
        self.title = eventName.text
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            showAlert(title: "Authentication Error", message: error.localizedDescription)
            self.service.authorizer = nil
        } else {
            self.service.authorizer = user.authentication.fetcherAuthorizer()
            createEvent()
        }
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

    func createEvent() {
        if !UIApplication.shared.canOpenURL(URL(string: "comgooglecalendar://")!) {
            showMissingAppAlert(appName: "Google Calendar")
        } else {
            let newEvent = GTLRCalendar_Event()

            newEvent.summary = event.name
            newEvent.location = event.location

            let startDate = Calendar.current.date(byAdding: .day, value: -3, to: Date())
            let startDateTime = GTLRDateTime(date: startDate!, offsetMinutes: 5)
            let startEventDateTime = GTLRCalendar_EventDateTime()
            startEventDateTime.dateTime = startDateTime
            newEvent.start = startEventDateTime

            let endDate = Calendar.current.date(byAdding: .day, value: 4, to: Date())
            let endDateTime = GTLRDateTime(date: endDate!, offsetMinutes: 50)
            let endEventDateTime = GTLRCalendar_EventDateTime()
            endEventDateTime.dateTime = endDateTime
            newEvent.end = endEventDateTime
            print(newEvent.end!)

            let createEventQuery = GTLRCalendarQuery_EventsInsert.query(withObject: newEvent, calendarId: "primary")

            service.executeQuery(createEventQuery, completionHandler: {(_ callbackTicket: GTLRServiceTicket, _ event: GTLRCalendar_Event, _ callbackError: Error?) -> Void in
                print("Query executed")
                if callbackError == nil {
                    print("Event added succesfully")
                    print(newEvent.summary!);
                }
                else {
                    print("Failed to add event")
                    print(callbackError!)
                }} as? GTLRServiceCompletionHandler)

            // Redirect to Google Calendar
            gotoGoogleCalendar(date: startDate! as NSDate)
        }
    }

    func gotoGoogleCalendar(date: NSDate) {
        UIApplication.shared.open(NSURL(string: "comgooglecalendar://")! as URL)
    }

    func gotoAppStore(urlId : String) {
        UIApplication.shared.open(URL(string: "itms://itunes.apple.com/mx/app/\(urlId)")!)
    }

    // Helper for showing an alert
    func showAlert(title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.default,
            handler: nil
        )
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }

    // Helper for showing a missing App alert
    func showMissingAppAlert(appName : String) {
        var urlId = ""
        switch appName {
        case "Google Calendar":
            urlId = "google-calendar/id909319292?l=en&mt=8"
        default:
            urlId = "facebook/id284882215?l=en&mt=8"
        }
        let alert = UIAlertController(title: "Restore \(appName)?",
                                      message: "You followed a link that requires the app \(appName),which is no longer on your iPhone. You can restore it from the App Store.",
                                      preferredStyle: UIAlertControllerStyle.alert)
        let showAppStore = UIAlertAction(
            title: "Show in App Store",
            style: UIAlertActionStyle.default,
            handler: { action in self.gotoAppStore(urlId: urlId)}
        )
        let cancel = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil
        )
        alert.addAction(showAppStore)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
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
