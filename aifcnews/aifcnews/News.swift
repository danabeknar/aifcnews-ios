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
import SWXMLHash


struct News {
    
    var title: String?
    var date: String?
    var link: String?
    
    init(_ title: String, _ date: String, _ link: String) {
        self.title = title
        self.date = date
        self.link = link
    }

    static func fetchNews(with tag: Tag, callback: @escaping ([News]?, Error?) -> Void){
        var news = [News]()
        var counter = 0
        for subtag in tag.subtags {
            let url = createURL(from: tag, and: subtag)
            Alamofire.request(url, method: .get).response(completionHandler: { (data) in
                let xml = SWXMLHash.parse(data.data!)
                for elem in xml["rss"]["channel"]["item"].all {
                    if let title = elem["title"].element?.text, let link = elem["link"].element?.text, let date = elem["pubDate"].element?.text{
                        let modifiedTitle = fetchFirstSentence(from: title)
                        news.append(News(modifiedTitle, date, link))
                    }
                    counter += 1
                    if counter == xml["rss"]["channel"]["item"].all.count{
                        callback(news, nil)
                    }
                }
                callback(nil, data.error)
            })
        }
    }
    
    static func createURL(from tag: Tag, and subtag: Subtag) -> String {
        let modifiedSubtag = addPlusses(to: subtag.subtag)
        let modifiedTag = addPlusses(to: tag.tag)
        switch tag.tag {
            case "Kazakhstan", "Kazakh Tenge", "National Companies":
                return "https://news.google.com/news?q=\(modifiedTag)&as_epq=\(modifiedSubtag)&output=rss&hl=us"
            default:
                return "https://news.google.com/news?q=\(modifiedSubtag)&output=rss&hl=us"
        }
    }
    
    static func fetchFirstSentence(from text: String) -> String {
        let textArray = text.components(separatedBy: " - ")
        return textArray[0]
    }
    
    static func addPlusses(to string: String) -> String {
        var returningString = ""
        var counter = 0
        for character in string.characters{
            if character == " "{
                returningString.append("+")
            } else {
                returningString.append(character)
            }
            counter += 1
            if counter == string.characters.count {
                return returningString
            }
        }
        return returningString
    }

}
