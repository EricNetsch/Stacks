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
import Haneke



class MediaView: UIViewController, iCarouselDataSource, iCarouselDelegate, UIGestureRecognizerDelegate {
    

    var tap = UITapGestureRecognizer()
    var gesture = UIPanGestureRecognizer()
    var safariVC: SFSafariViewController?
    var user: User?
    var accessToken: String!
    var nextURLRequest: NSURLRequest?
    let BASE: String = "https://api.instagram.com/v1/users/self/media/recent/?access_token="

    var imageData = NSData()
    var photos : NSMutableArray = NSMutableArray()
    
    @IBOutlet var carousel : iCarousel!
    @IBOutlet weak var currentIndex: UILabel!
    @IBOutlet weak var totalIndex: UILabel!
    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var loginInstagramButton: UIBarButtonItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        carousel.type = .Linear
        
        tap.delegate = self
        gesture.delegate = self
        
        
        let url = NSURL(string:"\(BASE)\(self.accessToken)")
        print(link)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithRequest(NSURLRequest(URL: url!)) { (data, response, error) -> Void in
            
            if (error == nil){
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                    data!, options:[]) as? NSDictionary {
                    let photosArr: NSArray = (responseDictionary["data"] as? NSArray)!
                    
                    for photo in photosArr {
                        
                        let dataArry = photo as? NSDictionary
                        let images = dataArry!["images"]!["standard_resolution"]
                        let imageArry = images!!["url"] as! String
                        print("LINK:\(imageArry)")
                        let theImageURL = NSURL(string: imageArry)
                        self.photos.addObject(NSData(contentsOfURL: theImageURL!)!)
                        print("COUNT:\(self.photos.count)")
                         self.carousel.reloadData()
                    }
                }
            } else{
                
                print("Error downloading data \(error)")
            }
        }
        
        task.resume()
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
        
//        gesture = UIPanGestureRecognizer(target: self, action: #selector(MediaView.wasDragged(_:)))
//       
//        carousel.currentItemView!.addGestureRecognizer(gesture)
//        carousel.currentItemView!.userInteractionEnabled = true
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(MediaView.wasTapped(_:)))
//        carousel.currentItemView!.addGestureRecognizer(tap)
//        carousel.currentItemView!.userInteractionEnabled = true
//        
//        gesture.requireGestureRecognizerToFail(tap)
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
            
        }
        else
        {
            itemView = view as! UIImageView
        }

        itemView.image = UIImage(data: photos.objectAtIndex(index) as! NSData)
        
        currentIndex.text = "\(carousel.currentItemIndex) of"
        totalIndex.text = "\(photos.count)"
        
        return itemView
     
    }
    
    func carousel(carousel: iCarousel, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat
    {
        if (option == .Spacing)
        {
            return value * 1.2
        }
        return value
    }

    func wasDragged(gestureRecognizer: UIPanGestureRecognizer) {
        
        
        let translation = gestureRecognizer.translationInView(self.view?.superview)
        carousel.currentItemView!.frame.origin.y = translation.y
        
        print(translation.y)
        
        if gestureRecognizer.state == UIGestureRecognizerState.Ended && translation.y <= -50.0 {
            print("Ended")
            carousel.currentItemView!.frame.origin = CGPointMake(0, -200.0)
            
            
        }else if gestureRecognizer.state == UIGestureRecognizerState.Ended && translation.y >= 175.0 {
            carousel.currentItemView!.frame.origin = CGPointMake(0, 400)
            
            
        } else if gestureRecognizer.state == UIGestureRecognizerState.Ended {
            carousel.currentItemView!.frame.origin = CGPointMake(0, 0)
            
        }
        
    }
    
     func wasTapped(gestureRecognizer: UITapGestureRecognizer) {
            
        carousel.currentItemView!.frame.origin = CGPointMake(0, 0)
        print("Tapped")
    }
    
    
   }

