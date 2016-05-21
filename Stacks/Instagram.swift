//
//  Instagram.swift
//  Stacks
//
//  Created by James Gobert on 4/29/16.
//  Copyright © 2016 Mobile First Studios. All rights reserved.
//


import UIKit
import Alamofire
import SwiftyJSON

//let INSTAGRAM_CLIENT_ID = "24e7ef78bde7477a8ca0c42857e6466f"
let INSTAGRAM_CLIENT_ID = "8ec1327a13214b6d944deba720ca1f13"
let INSTAGRAM_CLIENT_SECRET = "8835d20dd3eb4a76817827d915969a29"
//let INSTAGRAM_CLIENT_SECRET = "fa694f01f9334fc288565a2d0501d535"
let INSTAGRAM_REDIRECT_URL = "Stacks://authorize"
var URL = ""
let BASE = "https://api.instagram.com"
let pathString = "/v1/users/self/media/liked?access_token="
let TOKEN = ""


// Inspired by: https://github.com/MoZhouqi/PhotoBrowser

struct AuthInstagram {
    
    enum Router: URLRequestConvertible {
        static let baseURLString = "https://api.instagram.com"
        static let clientID = INSTAGRAM_CLIENT_ID
        static let redirectURI = INSTAGRAM_REDIRECT_URL
        static let clientSecret = INSTAGRAM_CLIENT_SECRET
        static let code = ""
        static let authorizationURL = NSURL(string: Router.baseURLString + "/oauth/authorize/?client_id=" + Router.clientID + "&redirect_uri=" + Router.redirectURI + "&response_type=code")!
        
        case LikedPhotos(String)
        case requestOauthCode
        
        static func requestAccessTokenURLStringAndParms(code: String) -> (URLString: String, Params: [String: AnyObject]) {
            let params = ["client_id": Router.clientID, "client_secret": Router.clientSecret, "grant_type": "authorization_code", "redirect_uri": Router.redirectURI, "code": code]
            let pathString = "/oauth/access_token"
            let urlString = AuthInstagram.Router.baseURLString + pathString
            return (urlString, params)
        }
        
        var URLRequest: NSMutableURLRequest { //NSURLRequest {
            let (path, parameters): (String, [String: AnyObject]) = {
                switch self {
                case .LikedPhotos (let accessToken):
                    let params = ["access_token": accessToken]
                    let TOKEN = accessToken
                    let pathString = "/v1/users/self/media/liked?access_token="
                    print(TOKEN)
                    let fullPath = "\(BASE)\(pathString)\(TOKEN)"
                    print(fullPath)
                    
                    
                    
                    return (pathString, params)
                    
                    
                case .requestOauthCode:
                    _ = "/oauth/authorize/?client_id=" + Router.clientID + "&redirect_uri=" + Router.redirectURI + "&response_type=code"
                    return ("/photos", [:])
                }
            }()
            
            let BaeseURL = NSURL(string: Router.baseURLString)
            let URLRequest = NSURLRequest(URL: BaeseURL!.URLByAppendingPathComponent(path))
            let encoding = Alamofire.ParameterEncoding.URL
            return encoding.encode(URLRequest, parameters: parameters).0
        }
    }
    
    
//    func getLikes() {
//        
//    let url = "\(BASE)\(pathString)\(TOKEN)"
//    
//    Alamofire.request(.GET, url).validate().responseJSON { response in
//    switch response.result {
//    case .Success:
//    if let value = response.result.value {
//    let json = JSON(value)
//    print("JSON: \(json)")
//    }
//    case .Failure(let error):
//    print(error)
//            }
//        }
//    }
    
    
    
}