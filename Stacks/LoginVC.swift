//
//  LoginVC.swift
//  Stacks
//
//  Created by James Gobert on 5/1/16.
//  Copyright © 2016 Mobile First Studios. All rights reserved.
//

import UIKit
import Alamofire
import SafariServices
import SwiftyJSON


let kSafariViewControllerCloseNotification = "kSafariViewControllerCloseNotification"

class LoginVC: UIViewController, SFSafariViewControllerDelegate {
    
    @IBOutlet weak var loginInstagramButton: UIButton!
   
    
    var safariVC: SFSafariViewController?
    var user: User?
    var accessToken: String!
    let tokenSave = NSUserDefaults.standardUserDefaults()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginInstagramButton.layer.cornerRadius = 10
       
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginVC.safariLogin(_:)), name: kSafariViewControllerCloseNotification, object: nil)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginInstagramButtonTapped(sender: UIButton) {
        print(AuthInstagram.Router.authorizationURL)
        safariVC = SFSafariViewController(URL: AuthInstagram.Router.authorizationURL)
        safariVC!.delegate = self
        self.presentViewController(safariVC!, animated: true, completion: nil)
        
    }
    
    func safariLogin(notification: NSNotification) {
        let notifUrl = notification.object as! NSURL
        print("\nnotifUrl: \(notifUrl)")
        let urlString = String(notifUrl)
        let code = extractCode(urlString)
        print("code: \(code)")
        self.loginWithInstagram(code!)
    }
    
    
    func loginWithInstagram(code: String) {
        let request = AuthInstagram.Router.requestAccessTokenURLStringAndParms(code)
        
        Alamofire.request(.POST, request.URLString, parameters: request.Params).responseJSON { response in
            if response.result.isSuccess {
                
                let data = response.result.value
                let error = response.result.error
                
                print("\nrequest: \(response.request)")
                
                if let unwrappedError = error {
                    
                    print("error: \(unwrappedError.localizedDescription)")
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.safariVC!.dismissViewControllerAnimated(true, completion: nil)
                    })
                    
                } else {
             
                    
                    let json = JSON(data!)
                    print("json: \(json)")
                    self.user = User(json: json)
                    
                    self.safariVC?.dismissViewControllerAnimated(true, completion: { () -> Void in
                        
                        if let user = self.user {
//                            self.label.text = String.localizedStringWithFormat(NSLocalizedString("Welcome %@, you are logged in with the Instagram user: %@", comment: ""), user.firstName, user.userName)
//                            self.logText.text = String(json)
//                            
//                            self.label.hidden = false
//                            self.logText.hidden = false
                        
                            self.accessToken = user.instagramAccessToken
                            
                            
                             self.performSegueWithIdentifier("SegueToPhotos", sender: self)
                        }
                        
//                        } else {
//                            self.label.text = NSLocalizedString("Sorry you are not logged in, try again.", comment: "")
//                            self.label.hidden = false
//                        }
                        self.view.invalidateIntrinsicContentSize()
                       
                        
                    })
                }
            }
        }

    }
    
    
    // MARK: - SFSafariViewControllerDelegate
    
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        controller.dismissViewControllerAnimated(true) { () -> Void in
//            self.label.text = NSLocalizedString("You just dismissed the login view.", comment: "")
        }
    }
    
    func safariViewController(controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        print("didLoadSuccessfully: \(didLoadSuccessfully)")
    }
    
    
    // MARK: - Utils
    
    func extractCode(urlString: String) -> String? {
        var code: String? = nil
        let url = NSURL(string: urlString)
        let urlQuery = (url?.query != nil) ? url?.query : urlString
        let components = urlQuery?.componentsSeparatedByString("&")
        for comp in components! {
            if (comp.rangeOfString("code=") != nil) {
                code = comp.componentsSeparatedByString("=").last
            }
        }
        return code
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "SegueToPhotos") {
        
//            let destinationVC = (segue.destinationViewController as! StacksGallery)
//            destinationVC.accessToken = self.accessToken
            
            let navVC = (segue.destinationViewController as! UINavigationController)
            let collectionVC = navVC.viewControllers.first as! MediaView
            collectionVC.accessToken = self.accessToken
        }
    }
    

}