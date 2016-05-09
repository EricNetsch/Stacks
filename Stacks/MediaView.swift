//
//  MediaView.swift
//  Stacks
//
//  Created by James Gobert on 4/29/16.
//  Copyright © 2016 Mobile First Studios. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SafariServices


class MediaView: UIViewController, iCarouselDataSource, iCarouselDelegate, UIGestureRecognizerDelegate {
    

    var tap = UITapGestureRecognizer()
    var gesture = UIPanGestureRecognizer()
    var safariVC: SFSafariViewController?
    var user: User?
    var accessToken: String!
    var nextURLRequest: NSURLRequest?
    let BASE: String = "https://api.instagram.com/v1/users/self/media/liked?access_token="

    var imageData = NSData()
    var photos : NSMutableArray = NSMutableArray()
    
    var isViewLevel: Int = 2
    
    @IBOutlet var carousel : iCarousel!
    @IBOutlet weak var currentIndex: UILabel!
    @IBOutlet weak var totalIndex: UILabel!
    @IBOutlet weak var buttonOne: UIButton!
    @IBOutlet weak var buttonTwo: UIButton!
    @IBOutlet weak var buttonThree: UIButton!
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
    @IBOutlet weak var labelThree: UILabel!
    @IBOutlet weak var trashIcon: UIButton!
    
    @IBOutlet weak var btnStackView: UIStackView!
    @IBOutlet weak var counterStackView: UIStackView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        animateFolderBtnsDwn()
        carousel.type = .Linear
        
        
        let url = NSURL(string:"\(BASE)\(self.accessToken)")
        print(link)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        let task = session.dataTaskWithRequest(NSURLRequest(URL: url!)) { (data, response, error) -> Void in
            
            if (error == nil){
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                    data!, options:[]) as? NSDictionary {
                    let photosArr: NSArray = (responseDictionary["data"] as? NSArray)!
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    
                    for photo in photosArr {
                        
                        let dataArry = photo as? NSDictionary
                        let images = dataArry!["images"]!["standard_resolution"]
                        let imageArry = images!!["url"] as! String
                        print("LINK:\(imageArry)")
                        let theImageURL = NSURL(string: imageArry)
                        self.photos.addObject(NSData(contentsOfURL: theImageURL!)!)
                        print("COUNT:\(self.photos.count)")
                        
                    dispatch_async(dispatch_get_main_queue()) {
                        self.carousel.reloadData()
                    }
                }
            }
                    
            } else{
                
                print("Error downloading data \(error)")
            }
        }
    }
        task.resume()
        
         print("LEVEL COUNT IS:\(isViewLevel)")
    }
    
   
    override func viewDidAppear(animated: Bool) {
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func didFailToFetchMediaItems(error: NSError) {
        
    }

    func gestureRecognizer(_: UIGestureRecognizer,shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
        return true
    }
    
    func carouselDidEndScrollingAnimation(carousel: iCarousel) {
        
        let upSelector: Selector = #selector(handleUpSwipe(_:))
        let upSwipe = UISwipeGestureRecognizer(target: self, action: upSelector)
        
        upSwipe.direction = .Up
        
        view.addGestureRecognizer(upSwipe)
        
        let downSelector: Selector = #selector(handleDownSwipe(_:))
        let downSwipe = UISwipeGestureRecognizer(target: self, action: downSelector)
        
        downSwipe.direction = .Down
        
        view.addGestureRecognizer(downSwipe)
    }
    
    
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        return self.photos.count
    }
    
    
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
        
        var itemView: UIImageView
        if (view == nil)
        {
            itemView = UIImageView(frame:CGRect(x:0, y:0, width:300, height:300))
            itemView.contentMode = .ScaleAspectFill
            itemView.clipsToBounds = true
            
        }
        else
        {
            itemView = view as! UIImageView
        }

        itemView.image = UIImage(data: photos.objectAtIndex(index) as! NSData)
        itemView.contentMode = UIViewContentMode.ScaleAspectFill
        
        
        currentIndex.text = "\(carousel.currentItemIndex) of"
        totalIndex.text = "\(photos.count)"
        
        return itemView
     
    }
    
    func carousel(carousel: iCarousel, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat
    {
        if (option == .Spacing)
        {
            return value * 1.1
        }
        return value
    }

    
    func handleUpSwipe(sender: UISwipeGestureRecognizer) {
        if (sender.direction == .Up) {
            
            if self.isViewLevel == 2 {
            self.isViewLevel += 1
                print(isViewLevel)
            animateViewUp()
            animateFolderBtnsUp()
                
            } else if self.isViewLevel == 1 {
               animateViewToOrigin()
                animateTrashUp()
                self.isViewLevel += 1
                counterStackView.hidden = false
                print(isViewLevel)
            } else {
                print("Do Nothing")
                print(isViewLevel)
            }
        }
    }
    
    
    func handleDownSwipe(sender: UISwipeGestureRecognizer) {
        if (sender.direction == .Down) {
        
            if self.isViewLevel == 3 {
            self.isViewLevel -= 1
                print(isViewLevel)
            animateViewToOrigin()
            animateFolderBtnsDwn()
            } else if self.isViewLevel == 2 {
                self.isViewLevel -= 1
                print(isViewLevel)
                animateViewDelete()
                animateTrashDown()
                counterStackView.hidden = true
            } else {
                print("Do Nothing")
                print(isViewLevel)
            }
        }
    }
    
    func animateViewUp() {
        
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.TransitionNone, animations: {
            
            // setup 2D transitions for animations
            let animateUp = CGAffineTransformMakeTranslation(0, -300)
            
            self.carousel.currentItemView!.transform = animateUp
//            self.carousel.alpha = 0.5
            self.carousel.scrollEnabled = false
            
            }, completion: { finished in
                
                // tell our object that we've finished animating
                
        })
    }
    
    
    func animateViewToOrigin() {
        
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.TransitionNone, animations: {
            
            // setup 2D transitions for animations
            let returnToOrigin = CGAffineTransformMakeTranslation(0, 0)
            
            self.carousel.currentItemView!.transform = returnToOrigin
            self.carousel.alpha = 1.0
            self.carousel.scrollEnabled = true
            
            }, completion: { finished in
                
                
        })
        
    }
    
    func animateViewDelete() {
        
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.TransitionNone, animations: {
            
            // setup 2D transitions for animations
            let animateDelete = CGAffineTransformMakeTranslation(0, 300)
            
            self.carousel.currentItemView!.transform = animateDelete
            self.carousel.alpha = 0.5
            self.carousel.scrollEnabled = false
            
            }, completion: { finished in
                
                
        })
        
    }

    
    func animateFolderBtnsDwn() {
        
        buttonOne.alpha = 0
        buttonTwo.alpha = 0
        buttonThree.alpha = 0
        
        self.labelOne.alpha = 0
        self.labelTwo.alpha = 0
        self.labelThree.alpha = 0
        
         UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.TransitionNone, animations: {
        
        let offstageDown = CGAffineTransformMakeTranslation(0, 400)
            
            self.buttonOne.transform = offstageDown
            self.buttonTwo.transform = offstageDown
            self.buttonThree.transform = offstageDown
            self.labelOne.transform = offstageDown
            self.labelTwo.transform = offstageDown
            self.labelThree.transform = offstageDown
            
            }, completion: { finished in
                
                
         })
    }
    
    func animateFolderBtnsUp() {
        
        buttonOne.alpha = 1
        buttonTwo.alpha = 1
        buttonThree.alpha = 1
        
        self.labelOne.alpha = 1
        self.labelTwo.alpha = 1
        self.labelThree.alpha = 1
        
        UIView.animateWithDuration(0.6, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.TransitionNone, animations: {
            
            self.buttonOne.transform = CGAffineTransformIdentity
            self.buttonTwo.transform = CGAffineTransformIdentity
            self.buttonThree.transform = CGAffineTransformIdentity
            
            self.labelOne.transform = CGAffineTransformIdentity
            self.labelTwo.transform = CGAffineTransformIdentity
            self.labelThree.transform = CGAffineTransformIdentity
            
            }, completion: { finished in
                
                
        })
    }
    
    func animateTrashUp() {
        
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.TransitionNone, animations: {
            
            self.trashIcon.transform = CGAffineTransformIdentity

            }, completion: { finished in
                
                
        })
    }
    
    func animateTrashDown() {
        
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.TransitionNone, animations: {
            
            let onstageDown = CGAffineTransformMakeTranslation(0, 450)
            
            self.trashIcon.transform = onstageDown
            
            }, completion: { finished in
                
                
        })
    }
    
    
}

