//
//  StacksGallery.swift
//  Stacks
//
//  Created by James Gobert on 5/9/16.
//  Copyright © 2016 Mobile First Studios. All rights reserved.
//

import UIKit

class StacksGallery: UIViewController {
    
    var image = UIImage(named: "settings.png")
    var accessToken: String!
    let transitionManager = TransitionManager()

    @IBOutlet weak var settingsBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         //Transparent Navigation Bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .Plain, target: self, action:"presentLeftMenuViewController")

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
