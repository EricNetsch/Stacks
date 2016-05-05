//
//  PhotoModel.swift
//  Stacks
//
//  Created by James Gobert on 5/4/16.
//  Copyright © 2016 Mobile First Studios. All rights reserved.
//

import UIKit

class PhotoModel: NSObject {
    var url: String?
    var username: String?
    var profilePicture: String?
    
    init(json: NSDictionary){
        if let url = json["images"]!["standard_resolution"]!!["url"]{
            self.url = url as? String
            print("\(url!)")
        }
        if let username = json["user"]!["username"]{
            self.username = username as? String
        }
        if let profilePicture = json["user"]!["profile_picture"]{
            self.profilePicture = profilePicture as? String
        }
    }
}