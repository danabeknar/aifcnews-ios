//
//  Database.swift
//  aifcnews
//
//  Created by Beknar Danabek on 8/3/17.
//  Copyright © 2017 nFactorial Incubator. All rights reserved.
//

import Foundation
import RealmSwift

class Database {
    
    static let shared = Database()
    
    func fetchRealmNews(callback: @escaping ([News]?) -> Void) {
        let news = realm.objects(RealmNews.self)
        var returningNews = [News]()
        var counter = 0
        if news.count > 0 {
            print(news.count)
            for newsObject in news{
                if let image = UIImage(data: (newsObject.image) as Data) {
                    returningNews.append(News(newsObject.title, newsObject.date, newsObject.source, image, newsObject.body))
                }
                counter += 1
                if counter == news.count{
                    callback(returningNews)
                }
            }
        } else {
            callback(nil)
        }
    }
}
