//
//  EventDetailsViewController.swift
//  itesm_event_listing
//
//  Created by Rene Garcia Saenz on 3/13/18.
//  Copyright © 2018 Rene Garcia Saenz. All rights reserved.
//

import AlamofireImage
import Social
import GoogleAPIClientForREST
import GoogleSignIn
import EventKit
import UIKit

class EventDetailsViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {

    var event: Event!
    let output = UITextView()
    let eventStore = EKEventStore()
    private let googleCalendar = GTLRCalendarService()
    private let scopes = ["https://www.googleapis.com/auth/calendar"]
    
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventStartDate: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventDescrip: UILabel!
    @IBOutlet weak var eventRegistrationUrl: UILabel!
    @IBOutlet weak var eventRequirements: UILabel!
    @IBOutlet weak var organizerName: UILabel!
    @IBOutlet weak var organizerEmail: UILabel!
    @IBOutlet weak var organizerPhone: UILabel!
    @IBOutlet weak var organizerFbUrl: UILabel!
    @IBOutlet weak var organizerTwitterUrl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure view information
        self.title = eventName.text
        scroller.contentSize = mainView.frame.size
        
        eventImage.af_setImage(withURL: URL(string: event.photoURL!)!)
        eventName.text = event.name
        eventLocation.text = event.location
        eventStartDate.text = DateParser.sharedInstance.parseDateWithDayAndMonthAndTime(dateAsString: event.startDate)
        
        eventDescrip.text = event.descrip
        eventRequirements.text = event.requirements
        eventRegistrationUrl.text = event.registrationUrl
        organizerName.text = event.contactInformation?.name
        organizerEmail.text = event.contactInformation?.email
        organizerPhone.text = event.contactInformation?.phone
        organizerFbUrl.text = event.contactInformation?.fbUrl
        organizerTwitterUrl.text = event.contactInformation?.twitterUrl


        // Configure Google Sign-in
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = scopes
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addEventToCalendar(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let iOSCalendar = UIAlertAction (
            title: "Add to Calendar",
            style: UIAlertActionStyle.default,
            handler: { action in self.createCalendarEvent()}
        )
        let googleCalendar = UIAlertAction(
            title: "Add to Google Calendar",
            style: UIAlertActionStyle.default,
            handler: { action in GIDSignIn.sharedInstance().signIn()}
        )
        let cancel = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil
        )
        
        alert.addAction(iOSCalendar)
        alert.addAction(googleCalendar)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    func openApp(url : String) {
        UIApplication.shared.open(NSURL(string: url)! as URL)
    }
    
    func createCalendarEvent() {
        eventStore.requestAccess(to: .event) { (success, error) in
            if  error == nil {
                let calendarEvent = EKEvent.init(eventStore: self.eventStore)
                
                calendarEvent.title = self.event.name
                calendarEvent.location = self.event.location
                calendarEvent.calendar = self.eventStore.defaultCalendarForNewEvents
                
                let startDate = DateParser.sharedInstance.parse(dateAsString: self.event.startDate)
                calendarEvent.startDate = startDate
                
                calendarEvent.endDate = self.event.endDate == nil ? startDate?.addingTimeInterval(60*60) :             DateParser.sharedInstance.parse(dateAsString: self.event.endDate)
                
                let alarm = EKAlarm.init(absoluteDate: Date.init(timeInterval: -1800, since: calendarEvent.startDate))
                calendarEvent.addAlarm(alarm)
                
                do {
                    try self.eventStore.save(calendarEvent, span: .thisEvent)
                } catch let error as NSError {
                    print("Failed to save event with error : \(error)")
                }
            } else {
                print("Error = \(String(describing: error?.localizedDescription))")
            }
        }
        openApp(url : "calshow://")
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            let alert = UIAlertController(
                title: "Authentication Error",
                message: error.localizedDescription,
                preferredStyle: UIAlertControllerStyle.alert
            )
            let ok = UIAlertAction(
                title: "OK",
                style: UIAlertActionStyle.default,
                handler: nil
            )
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
            self.googleCalendar.authorizer = nil
        } else {
            self.googleCalendar.authorizer = user.authentication.fetcherAuthorizer()
            createGoogleCalendarEvent()
        }
    }
    
    func createGoogleCalendarEvent() {
        if !UIApplication.shared.canOpenURL(URL(string: "comgooglecalendar://")!) {
            showMissingGoogleCalendar()
        }
        else {
            let gCalendarEvent = GTLRCalendar_Event()
            
            gCalendarEvent.summary = self.event.name
            gCalendarEvent.location = self.event.location

            let startDate = DateParser.sharedInstance.parse(dateAsString: event.startDate)
            let startDateTime = GTLRDateTime(date: startDate!)
            let startEventDateTime = GTLRCalendar_EventDateTime()
            startEventDateTime.dateTime = startDateTime
            startEventDateTime.timeZone = "America/Monterrey"
            gCalendarEvent.start = startEventDateTime
            
            let endDate = event.endDate == nil ? startDate?.addingTimeInterval(60*60) :             DateParser.sharedInstance.parse(dateAsString: event.endDate)
            
            let endDateTime = GTLRDateTime(date: endDate!, offsetMinutes: 50)
            let endEventDateTime = GTLRCalendar_EventDateTime()
            endEventDateTime.dateTime = endDateTime
            endEventDateTime.timeZone = "America/Monterrey"
            gCalendarEvent.end = endEventDateTime
            
            let createEventQuery = GTLRCalendarQuery_EventsInsert.query(withObject: gCalendarEvent, calendarId: "primary")
            
            googleCalendar.executeQuery(createEventQuery, completionHandler: {(_ callbackTicket: GTLRServiceTicket, _ event: GTLRCalendar_Event, _ callbackError: Error?) -> Void in
                print("Query executed")
                if callbackError == nil {
                    print("Event added succesfully")
                    print(gCalendarEvent.summary!);
                }
                else {
                    print("Failed to add event")
                    print(callbackError!)
                }} as? GTLRServiceCompletionHandler)
            
            openApp(url : "comgooglecalendar://")
        }
    }
    
    func showMissingGoogleCalendar() {
        let alert = UIAlertController(title: "Restore \"Google Calendar\"?",
                                      message: "You followed a link that requires the app \"Google Calendar\", which is no longer on your iPhone. You can restore it from the App Store.",
                                      preferredStyle: UIAlertControllerStyle.alert)
        let showAppStore = UIAlertAction(
            title: "Show in App Store",
            style: UIAlertActionStyle.default,
            handler: { action in self.openApp(url: "itms://itunes.apple.com/mx/app/google-calendar/id909319292?l=en&mt=8")}
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
    
    @IBAction func shareEvent(_ sender: Any) {
        var objectsToShare = [AnyObject]()
        
        if let name = eventName.text {
            let textItem =  "Te comparto este evento: \(name)"
            objectsToShare.append(textItem as AnyObject)
        }
        if let image = eventImage.image {
             let imageItem = image
            objectsToShare.append(imageItem)
        }
        
        let event = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        self.present(event, animated: true, completion: nil)
        event.excludedActivityTypes = [.assignToContact,.postToVimeo,.postToWeibo,.postToFlickr,.postToTencentWeibo,.openInIBooks,.addToReadingList]
        event.completionWithItemsHandler = {
            (type, success,items,error)->Void in
            if success{
                print("Event shared")
            }
        }
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
