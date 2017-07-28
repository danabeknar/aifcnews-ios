//
//  Models.swift
//  aifcnews
//
//  Created by Beknar Danabek on 7/17/17.
//  Copyright © 2017 nFactorial Incubator. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import ObjectMapper

struct News {
    
    var title: String?
    var date: String?
    var source: String?
    var imageURL: String?
    var body: String?
    
    init?(map: Map) {
        
    }
    
    
    static func fetchNews(callback: @escaping ([News]?, Error?) -> Void) {
        let headers = ["X-AYLIEN-NewsAPI-Application-ID": "a0207811", "X-AYLIEN-NewsAPI-Application-Key": "d9d55eb1c3bc25fa06fc0b63918d9dde"]
        let parameters = ["title": "Kazakhstan", "language": "en"]
        Alamofire.request("https://api.newsapi.aylien.com/api/v1/stories?", method: HTTPMethod.get, parameters: parameters,headers: headers).responseJSON { (response) in
            guard let json = response.result.value as? [String:Any],
                let stories = json["stories"] as? [Any]
            else {
                callback(nil, response.result.error)
                return
            }
            let news = Mapper<News>().mapArray(JSONObject: stories)
            callback(news, nil)
        }
    }

}

extension News: Mappable {
        mutating func mapping(map: Map) {
            title <- map["title"]
            date <- map["published_at"]
            imageURL <- map["media.0.url"]
            body <- map["body"]
            source <- map["source.title"]
        }
    }
    
    
    
//    static func fetchNews(callback: @escaping ([String:Any]?, Error?) -> Void) {
//        let headers = ["X-AYLIEN-NewsAPI-Application-ID": "a0207811", "X-AYLIEN-NewsAPI-Application-Key": "d9d55eb1c3bc25fa06fc0b63918d9dde"]
//        let parameters = ["title": "Kazakhstan", "language": "en"]
//        Alamofire.request("https://api.newsapi.aylien.com/api/v1/stories?", method: HTTPMethod.get, parameters: parameters,headers: headers).responseJSON { (response) in
//            
//            guard let json = response.result.value as? [String:Any]
//                else {
//                    callback(nil, response.result.error)
//                    return
//            }
//            
//            callback(json, nil)
//        }
//    }



//static func fetchFeed(category: Category, callback: @escaping ([Feed]?, Error?) -> Void ){
//
//    Alamofire.request(category.rawValue).responseJSON { response in
//
//        guard let json = response.result.value as? [String: Any],
//            let feed = json["feed"] as? [String: Any],
//            let entries = feed["entry"] else {
//                callback(nil, response.result.error)
//                return
//        }
//
//        let feeds = Mapper<Feed>().mapArray(JSONObject: entries)
//
//        callback(feeds, nil)
//    }
//    
//}
//}
