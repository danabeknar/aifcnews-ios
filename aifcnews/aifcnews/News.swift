//
//  Models.swift
//  aifcnews
//
//  Created by Beknar Danabek on 7/17/17.
//  Copyright © 2017 nFactorial Incubator. All rights reserved.
//

import Foundation
import UIKit

struct News {
    
    let title: String
    let time: String
    let source: String
    let image: UIImage
    let text: String
    
    
//    static func fetch() -> [News] {
// 
//    }
    
}



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
