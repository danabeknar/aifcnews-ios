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
    var image: UIImage?
    var link: String?
    
    init?(map: Map) {
        
    }
    
    init(_ title: String, _ date: String, _ source: String, _ image: UIImage, _ body: String) {
        self.title = title
        self.date = date
        self.source = source
        self.image = image
        self.body = body
    }
    
    static func fetchNews(with subtags: [Subtag], callback: @escaping ([News]?, Error?) -> Void) {
        var allNews = [News]()
        allNews.removeAll()
        let headers = ["X-AYLIEN-NewsAPI-Application-ID": "37d14b97", "X-AYLIEN-NewsAPI-Application-Key": "bec89198da15903343bd84878d67f9f5"]
        var counter = 0
        for subtag in subtags {
            let parameters = ["title": "\(subtag.subtag)", "language": "en"]
            Alamofire.request("https://api.newsapi.aylien.com/api/v1/stories?", method: HTTPMethod.get, parameters: parameters,headers: headers).responseJSON { (response) in
                guard let json = response.result.value as? [String:Any] else {
                    callback(nil, response.result.error)
                    return
                }
                   guard let stories = json["stories"] as? [Any]
                    else {
                        callback(nil, response.result.error)
                        return
                }
                
                print(stories.last)
                
                let optionalNews = Mapper<News>().mapArray(JSONObject: stories)
                
                
                if let news = optionalNews {
                    allNews += news
                }
                counter += 1
                if counter == subtags.count {
                    callback(allNews, nil)
                }
            }
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
        link <- map["links.permalink"]
    }
}
