//
//  CreatedStack.swift
//  Stacks
//
//  Created by James Gobert on 5/9/16.
//  Copyright © 2016 Mobile First Studios. All rights reserved.
//

import UIKit

class CreatedStack: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func closeCreatedStack(sender: UIButton) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
  

}
