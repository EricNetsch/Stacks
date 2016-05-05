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
    
    var items: [Int] = []
    var tap = UITapGestureRecognizer()
    var gesture = UIPanGestureRecognizer()
   
    var safariVC: SFSafariViewController?
    var user: User?
    
    var accessToken: String?
    var nextURLRequest: NSURLRequest?
    let BASE: String = "https://api.instagram.com/v1/users/self/media/recent/?access_token="
//    let LIKE_PATH = "/v1/users/self/media/recent/?access_token="
    
    var photoModels: [PhotoModel] = []

    
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
        
        
//        let client_id = "24e7ef78bde7477a8ca0c42857e6466f"
        let link = NSURL(string:"\(BASE)\(accessToken!)")
        print(link)
        let request = NSURLRequest(URL: link!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                    data, options:[]) as? NSDictionary {
                    let photosArr: NSArray = (responseDictionary["data"] as? NSArray)!
                                                                                
                        for photo in photosArr {
                            self.photoModels.append(PhotoModel(json: (photo as? NSDictionary)!))
                                                                                    
//                            print("PHOTOMODELS:\(photoModels)")
                        }
                                                                                
//                         self.tableView.reloadData()
                                                                                
            }
          }
        });
        
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
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(MediaView.wasDragged(_:)))
       
        carousel.currentItemView!.addGestureRecognizer(gesture)
        carousel.currentItemView!.userInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(MediaView.wasTapped(_:)))
        carousel.currentItemView!.addGestureRecognizer(tap)
        carousel.currentItemView!.userInteractionEnabled = true
        
        gesture.requireGestureRecognizerToFail(tap)
    }
    
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        return self.photoModels.count
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
            
//            let photo = photoModels[indexPath.row]
//            let photoUrl = NSURL(string: photo.url!)
//            carousel.itemView.setImageWithURL(photoUrl!)
            
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
        
//        Alamofire.request(.GET, photoModels).response { (request, response, data, error) in
//            self.myImageView.image = UIImage(data: data, scale:1)
        
    }
  
    


}

