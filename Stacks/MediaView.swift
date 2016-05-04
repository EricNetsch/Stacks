//
//  MediaView.swift
//  Stacks
//
//  Created by James Gobert on 4/29/16.
//  Copyright © 2016 Mobile First Studios. All rights reserved.
//

import UIKit
import QuartzCore
import Alamofire
import SwiftyJSON
import SafariServices


class MediaView: UIViewController, iCarouselDataSource, iCarouselDelegate, UIGestureRecognizerDelegate {
    
    var items: [Int] = []
    var tap = UITapGestureRecognizer()
    var gesture = UIPanGestureRecognizer()
   
    var safariVC: SFSafariViewController?
    var user: User?
    
//    var photos: [UIImage!] = []
    var photos = [PhotoInfo]()
    var indexPaths = String()
    var accessToken: String?
    var nextURLRequest: NSURLRequest?
    let BASE = "https://api.instagram.com"
    let LIKE_PATH = "/v1/users/self/media/recent/?access_token="

    
    @IBOutlet var carousel : iCarousel!
    @IBOutlet weak var currentIndex: UILabel!
    @IBOutlet weak var totalIndex: UILabel!
    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var loginInstagramButton: UIBarButtonItem!
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var logText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        for i in 0...99 {
            
        items.append(i)
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        carousel.type = .Linear
        
        tap.delegate = self
        gesture.delegate = self
        
        getPhotos()
        
//        print("PHOTOS = \(photos)")
//        print("IndexPaths = \(indexPaths)")
        
    }
    
    override func viewDidAppear(animated: Bool) {
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    

    func gestureRecognizer(_: UIGestureRecognizer,shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
        return true
    }
    
    func carouselDidEndScrollingAnimation(carousel: iCarousel) {
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(MediaView.wasDragged(_:)))
       
        carousel.currentItemView!.addGestureRecognizer(gesture)
        carousel.currentItemView!.userInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(MediaView.wasTapped(_:)))
        carousel.currentItemView!.addGestureRecognizer(tap)
        carousel.currentItemView!.userInteractionEnabled = true
        
        gesture.requireGestureRecognizerToFail(tap)
    }
    
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        return items.count
    }
    
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView
    {
        var label: UILabel
        var itemView: UIImageView
        
        //create new view if no view is available for recycling
        if (view == nil)
        {
            //don't do anything specific to the index within
            //this `if (view == nil) {...}` statement because the view will be
            //recycled and used with other index values later
            itemView = UIImageView(frame:CGRect(x:0, y:0, width:200, height:200))
            itemView.image = UIImage(named: "page.png")
            itemView.contentMode = .Center
            
            label = UILabel(frame:itemView.bounds)
            label.backgroundColor = UIColor.clearColor()
            label.textAlignment = .Center
            label.font = label.font.fontWithSize(50)
            label.tag = 1
            itemView.addSubview(label)
        }
        else
        {
            //get a reference to the label in the recycled view
            itemView = view as! UIImageView;
            label = itemView.viewWithTag(1) as! UILabel!
            
        }
        
        //set item label
        //remember to always set any properties of your carousel item
        //views outside of the `if (view == nil) {...}` check otherwise
        //you'll get weird issues with carousel item content appearing
        //in the wrong place in the carousel
        
        
//        label.text = "\(items[index])"
//        currentIndex.text = "\(items[index]-1)"
//        totalIndex.text = "/\(items.count)"
//        backgroundImg.image = itemView.image
        
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
    
    func getPhotos()  {
//        let accessToken = String (user!.instagramAccessToken)
        let urlGram = "\(BASE)\(LIKE_PATH)\(self.accessToken!)"
        print(urlGram)
        
        Alamofire.request(.GET, urlGram).responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    if (json["meta"]["code"].intValue  == 200) {
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                            if let urlString = json["pagination"]["next_url"].URL {
                                self.nextURLRequest = NSURLRequest(URL: urlString)
                            } else {
                                self.nextURLRequest = nil
                            }
                            let photoInfos = json["data"].arrayValue
                                
                                .filter {
                                    $0["type"].stringValue == "image"
                                }.map({
                                    PhotoInfo(sourceImageURL: $0["images"]["standard_resolution"]["url"].URL!)
                                    
                                })
                    
                            
                            let lastItem = self.photos.count
                            
                             self.photos.appendContentsOf(photoInfos)
                            
                            let indexPaths = (lastItem..<self.photos.count).map { NSIndexPath(forItem: $0, inSection: 0) }
                            //                            print(self.photos)
                            dispatch_async(dispatch_get_main_queue()) {
                                
                                                    print("PATHS: \(indexPaths.row)")
//                                let eachPhoto:PhotoInfo = indexPaths
                  
                            }
                        }
                    } else {
                        print(ErrorType)
                    }
                }
            case .Failure:
                break;
            }
        }
    }

    
}

