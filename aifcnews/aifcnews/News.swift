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
import SwiftDate

struct News {
    
    var title: String?
    var date: Date?
    var link: String?
    var imageLink: String?
    var image: UIImage?
    
    init(_ title: String, _ date: Date, _ link: String, _ imageLink: String? = nil, _ image: UIImage? = nil) {
        self.title = title
        self.date = date
        self.link = link
        self.imageLink = imageLink
        self.image = image
    }

    static func fetchNews(with tag: Tag, callback: @escaping ([News]?, Error?) -> Void){
        var news = [News]()
        var counter = 0
        for subtag in tag.subtags {
            let url = createURL(from: tag, and: subtag)
            Alamofire.request(url, method: .get).response(completionHandler: { (data) in
                let xml = SWXMLHash.parse(data.data!)
                for elem in xml["rss"]["channel"]["item"].all {
                    if let title = elem["title"].element?.text, let link = elem["link"].element?.text, let dateString = elem["pubDate"].element?.text, let imageLink = elem["description"].element?.text{
                        news.append(News(fetchFirstSentence(from: title), createDate(dateString), link, fetchLink(from: imageLink), nil))
                    }
                    counter += 1
                    if counter == xml["rss"]["channel"]["item"].all.count{
                        callback(sortNews(with: news), nil)
                    }
                }
                callback(nil, data.error)
            })
        }
    }
    
    static func fetchLink(from string: String) -> String? {
        let textArray = string.components(separatedBy: "<img src=\"//")
        if textArray.count > 1{
            return(textArray[1].components(separatedBy: "\"")[0])
        }
        return nil
    }
    
    static func createDate(_ string: String) -> Date {
        let kz = Region(tz: TimeZoneName.asiaBishkek, cal: CalendarName.gregorian, loc: LocaleName.english)
        let date = string.date(format: .rss(alt: false), fromRegion: kz)
        if let absoluteData = date?.absoluteDate{
            return absoluteData
        }
        return Date()
    }
    
    static func sortNews(with array: [News]) -> [News]{
        let news = array.sorted(by: { $0.date! > $1.date! })
        return news
    }
    
    
    static func createURL(from tag: Tag, and subtag: Subtag) -> String {
        let modifiedSubtag = addPlusses(to: subtag.subtag)
        let modifiedTag = addPlusses(to: tag.tag)
        switch tag.tag {
            case "Kazakhstan", "Kazakh Tenge", "National Companies", "Global Partners":
                return "https://news.google.com/news?q=\(modifiedTag)+\(modifiedSubtag)&output=rss&hl=en&sort=date"
            default:
                return "https://news.google.com/news?q=\(modifiedSubtag)&output=rss&hl=en&sort=date"
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
