//
//  RealmNews.swift
//  aifcnews
//
//  Created by Beknar Danabek on 8/3/17.
//  Copyright © 2017 nFactorial Incubator. All rights reserved.
//

import Foundation
import RealmSwift


class RealmNewsList: Object {
    
    dynamic var name = ""
    let news = List<RealmNews>()
    
}

class RealmNews: Object {
    
    dynamic var title: String = ""
    dynamic var source: String = ""
    dynamic var date: String = ""
    dynamic var image: NSData = NSData()
    dynamic var body: String = ""
    dynamic var isFavourite: Bool = true
    
}
