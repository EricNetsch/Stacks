//
//  NewStackVC.swift
//  Stacks
//
//  Created by James Gobert on 5/9/16.
//  Copyright © 2016 Mobile First Studios. All rights reserved.
//

import UIKit

class NewStackVC: UIViewController {

    @IBOutlet weak var newStackTxtField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newStackTxtField.layer.cornerRadius = 10

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeNewStack(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }


}
