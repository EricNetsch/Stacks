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
    var nextURLRequest: String!
    let BASE: String = "https://api.instagram.com/v1/users/self/media/liked?access_token="
    let HASHTAG: String = "https://api.instagram.com/v1/tags/cats/media/recent?access_token="
    var photoId = [String]()
    
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
    @IBOutlet weak var refreshButton: UIButton!
    
    @IBOutlet weak var btnStackView: UIStackView!
    @IBOutlet weak var counterStackView: UIStackView!
    
    @IBOutlet weak var newStackBtn: UIButton!
   
   

    override func viewDidLoad() {
        super.viewDidLoad()
        animateFolderBtnsDwn()
        carousel.type = .Linear
        self.carousel.clipsToBounds = true
    
        
        //Transparent Navigation Bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        
        let url = NSURL(string:"\(BASE)\(self.accessToken)")
        print(url)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        let task = session.dataTaskWithRequest(NSURLRequest(URL: url!)) { (data, response, error) -> Void in
            
            if (error == nil){
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                    data!, options:[]) as? NSDictionary {
                    let photosArr: NSArray = (responseDictionary["data"] as? NSArray)!
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    
                    for photo in photosArr {
                        
                        let dataArry = photo as? NSDictionary
                        let getIds = dataArry!["id"] as! String
//                        self.photoId.append(getIds)
                        self.photoId.append(String(getIds))
                        print("PHOTOID: \(getIds)")

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
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func didFailToFetchMediaItems(error: NSError) {
        
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
            itemView = UIImageView(frame:CGRect(x:0, y:0, width:290, height:290))
            itemView.contentMode = .ScaleAspectFill
            itemView.clipsToBounds = true
            itemView.layer.cornerRadius = 5
        }
        else
        {
            itemView = view as! UIImageView
        }

        itemView.image = UIImage(data: photos.objectAtIndex(index) as! NSData)
        itemView.contentMode = UIViewContentMode.ScaleAspectFill
        
        
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
    
    func carouselCurrentItemIndexDidChange(carousel: iCarousel) {
        currentIndex.text = "\(carousel.currentItemIndex + 1)/"
    }
    
    
    func handleUpSwipe(sender: UISwipeGestureRecognizer) {
        if (sender.direction == .Up) {
            
            if self.isViewLevel == 2 {
            self.isViewLevel += 1
                print("UP:\(isViewLevel)")
            animateViewUp()
            animateFolderBtnsUp()
            counterStackView.hidden = true
                
            } else if self.isViewLevel == 1 {
               animateViewToOrigin()
                animateTrashUp()
                self.isViewLevel += 1
                 print("UP:\(isViewLevel)")
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
                 print("DOWN:\(isViewLevel)")
            animateViewToOrigin()
            animateFolderBtnsDwn()
            counterStackView.hidden = false
            } else if self.isViewLevel == 2 {
                self.isViewLevel -= 1
                print("DOWN:\(isViewLevel)")
                animateViewDelete()
                animateTrashDown()
            } else {
                print("Do Nothing")
                print(isViewLevel)
            }
        }
    }
    
    func animateViewUp() {
        
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.TransitionNone, animations: {
            
            // setup 2D transitions for animations
            let animateUp = CGAffineTransformMakeTranslation(0, -310)
            
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
        
         UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.TransitionNone, animations: {
        
        let offstageDown = CGAffineTransformMakeTranslation(0, 500)
            
            self.buttonOne.transform = offstageDown
            self.buttonTwo.transform = offstageDown
            self.buttonThree.transform = offstageDown
            self.labelOne.transform = offstageDown
            self.labelTwo.transform = offstageDown
            self.labelThree.transform = offstageDown
            
            self.newStackBtn.transform = offstageDown
            
            }, completion: { finished in
                
         })
    }
    
    
    
    
    
    func animateFolderBtnsUp() {
        
        buttonOne.alpha = 1
        buttonTwo.alpha = 1
        buttonThree.alpha = 1
        
        newStackBtn.alpha = 1
        
        self.labelOne.alpha = 1
        self.labelTwo.alpha = 1
        self.labelThree.alpha = 1
        
        UIView.animateWithDuration(0.5, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.TransitionNone, animations: {
            
            self.buttonOne.transform = CGAffineTransformIdentity
            self.buttonTwo.transform = CGAffineTransformIdentity
            self.buttonThree.transform = CGAffineTransformIdentity
            
            self.labelOne.transform = CGAffineTransformIdentity
            self.labelTwo.transform = CGAffineTransformIdentity
            self.labelThree.transform = CGAffineTransformIdentity
            
            self.newStackBtn.transform = CGAffineTransformIdentity
            
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
    
    func animateMoveToStack() {
        
        UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.TransitionNone, animations: {
            
            // setup 2D transitions for animations
            let animateUp = CGAffineTransformMakeTranslation(0, -500)
            
            self.carousel.currentItemView!.transform = animateUp
            
            }, completion: { finished in
                
                let nextIndex = self.carousel.currentItemIndex
                
                self.carousel.removeItemAtIndex(self.carousel.currentItemIndex, animated: false)
                self.photos.removeObjectAtIndex(self.carousel.currentItemIndex)
                self.carousel.reloadData()
                self.carousel.scrollToItemAtIndex(nextIndex, duration: 0.8)
                
        })
    }
    
    func animateDeleteImage() {
        
        UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.TransitionNone, animations: {
            
            // setup 2D transitions for animations
            let animateDown = CGAffineTransformMakeTranslation(0, 500)
            
            self.carousel.currentItemView!.transform = animateDown
            
            }, completion: { finished in
                
                let nextIndex = self.carousel.currentItemIndex
                
                self.carousel.removeItemAtIndex(self.carousel.currentItemIndex, animated: false)
                self.photos.removeObjectAtIndex(self.carousel.currentItemIndex)
                self.carousel.reloadData()
                self.carousel.scrollToItemAtIndex(nextIndex, duration: 0.8)
                
        })
    }
    
    func getNextPhotoURL() {
        
        let url = NSURL(string:"\(BASE)\(self.accessToken)")
        print(link)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        let task = session.dataTaskWithRequest(NSURLRequest(URL: url!)) { (data, response, error) -> Void in
            
            if (error == nil){
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                    data!, options:[]) as? NSDictionary {
                    self.nextURLRequest = (responseDictionary["pagination"]!["next_url"] as? String)!
                    print("NextURL:\(self.nextURLRequest)")
                    
                    let url = NSURL(string:"\(self.nextURLRequest)")
                    let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
                    
                    let task = session.dataTaskWithRequest(NSURLRequest(URL: url!)) { (data, response, error) -> Void in
                        
                        if (error == nil){
                            if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                                data!, options:[]) as? NSDictionary {
                                let photosArr: NSArray = (responseDictionary["data"] as? NSArray)!
                                
                                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                                    
                                    for photo in photosArr {
                                        
                                        let dataArry = photo as? NSDictionary
                                        let getIds = dataArry!["id"] as! String
                                        //                        self.photoId.append(getIds)
                                        self.photoId.append(String(getIds))
                                        print("PHOTOID: \(getIds)")
                                        
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
                    
                }
            }
        }
        task.resume()
    }

    
    
    @IBAction func stackOnePressed(sender: UIButton) {
        
        animateMoveToStack()
        animateFolderBtnsDwn()
        self.carousel.scrollEnabled = true
        counterStackView.hidden = false
        self.isViewLevel = 2
        
    }
    
    @IBAction func deletePressed(sender: UIButton) {
        animateDeleteImage()
        animateTrashUp()
        self.carousel.scrollEnabled = true
        self.carousel.alpha = 1.0
        self.isViewLevel = 2
    }
    
    @IBAction func refreshBtn(sender: UIButton) {
        getNextPhotoURL()
        
        UIView.animateWithDuration(0.5) { () -> Void in
            
            self.refreshButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        }
        
        UIView.animateWithDuration(0.5, delay: 0.25, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            
            self.refreshButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI * 2))
            }, completion: nil)
        }
}

