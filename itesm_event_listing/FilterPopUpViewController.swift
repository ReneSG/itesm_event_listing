//
//  FilterPopUpViewController.swift
//  itesm_event_listing
//
//  Created by Rene Garcia Saenz on 4/9/18.
//  Copyright © 2018 Rene Garcia Saenz. All rights reserved.
//

import UIKit

class FilterPopUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btn_box(sender: UIButton)
    {
        if (sender.isSelected)
        {
            sender.setBackgroundImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
            sender.isSelected = false;
        }
        else
        {
            sender.setBackgroundImage(#imageLiteral(resourceName: "success"), for: .normal)
            sender.isSelected = true;
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
