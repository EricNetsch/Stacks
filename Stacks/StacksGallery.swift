//
//  StacksGallery.swift
//  Stacks
//
//  Created by James Gobert on 5/9/16.
//  Copyright © 2016 Mobile First Studios. All rights reserved.
//

import UIKit

class StacksGallery: UIViewController {
    
    var accessToken: String!
    let transitionManager = TransitionManager()
    
    @IBOutlet weak var stackOne: UIButton!
    @IBOutlet weak var stackOneBG: UIView!
    
    @IBOutlet weak var stackTwo: UIButton!
    @IBOutlet weak var stackTwoBG: UIView!
    
    @IBOutlet weak var stackThree: UIButton!
    @IBOutlet weak var stackThreeBG: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stackOne.layer.cornerRadius = 5
        stackOne.clipsToBounds = true
        stackOneBG.layer.cornerRadius = 5
        stackTwo.layer.cornerRadius = 5
        stackTwo.clipsToBounds = true
        stackTwoBG.layer.cornerRadius = 5
        stackThree.layer.cornerRadius = 5
        stackThree.clipsToBounds = true
        stackThreeBG.layer.cornerRadius = 5
        
        
         //Transparent Navigation Bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Left", style: .Plain, target: self, action: #selector(SSASideMenu.presentLeftMenuViewController))

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "customSegue") {
        
            // this gets a reference to the screen that we're about to transition to
            let toViewController = segue.destinationViewController as UIViewController
            
            // instead of using the default transition animation, we'll ask
            // the segue to use our custom TransitionManager object to manage the transition animation
            toViewController.transitioningDelegate = self.transitionManager
            
                        let destinationVC = (segue.destinationViewController as! MediaView)
                        destinationVC.accessToken = self.accessToken
        
        }
    }
    
    @IBAction func unwindToViewController (sender: UIStoryboardSegue){
        
    }

    @IBAction func galleryToLikes(sender: AnyObject) {
        
        performSegueWithIdentifier("customSegue", sender: self)
    }

}
