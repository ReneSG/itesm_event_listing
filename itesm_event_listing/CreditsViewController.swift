//
//  CreditsViewController.swift
//  itesm_event_listing
//
//  Created by renysg on 5/7/18.
//  Copyright © 2018 Rene Garcia Saenz. All rights reserved.
//

import UIKit

class CreditsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
