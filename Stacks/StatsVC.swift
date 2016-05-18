//
//  StatsVC.swift
//  Stacks
//
//  Created by James Gobert on 5/17/16.
//  Copyright © 2016 Mobile First Studios. All rights reserved.
//

import UIKit

class StatsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func closeBtn(sender: UIButton) {
    dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    

}
