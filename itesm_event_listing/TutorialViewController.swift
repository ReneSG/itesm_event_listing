//
//  TutorialViewController.swift
//  itesm_event_listing
//
//  Created by renysg on 5/7/18.
//  Copyright © 2018 Rene Garcia Saenz. All rights reserved.
//

import UIKit
import MediaPlayer

class TutorialViewController: UIViewController {
    
    var tutorialVideo : MPMoviePlayerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "Tutorial", ofType: "MOV")
        let url = NSURL(fileURLWithPath: path!)
        self.tutorialVideo = MPMoviePlayerController.init(contentURL: url as URL!)
        
        self.tutorialVideo?.view.frame = self.view.frame
        self.tutorialVideo!.prepareToPlay()
        self.view.addSubview(self.tutorialVideo!.view)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
