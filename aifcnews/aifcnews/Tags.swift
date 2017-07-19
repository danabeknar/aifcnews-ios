//
//  Tags.swift
//  aifcnews
//
//  Created by Beknar Danabek on 7/19/17.
//  Copyright © 2017 nFactorial Incubator. All rights reserved.
//

import UIKit

class Tag {

    let tag: String
    let color: UIColor
    let subtags: [Subtag]
    var collapsed: Bool
    
    init(_ tag: String, _ color: UIColor, _ subtags: [Subtag], _ collapsed: Bool = false) {
        self.tag = tag
        self.color = color
        self.subtags = subtags
        self.collapsed = collapsed
    }
    
    static func fetchTags() -> [Tag] {
        return ([Tag("AIFC", "007AFF".hexColor, [Subtag("Astana International Financial Centre"), Subtag("AIFC Authorities"),
                                                  Subtag("Astana International Exchange"), Subtag("Astana Financial Supervisory Authorities"),Subtag("AIFC Court"), Subtag("AIFC Law"), Subtag("AIFC English Law")]),
                 
                 Tag("Kazakhstan", "5856D6".hexColor, [Subtag("Financial technologies"), Subtag("Islamic finance"), Subtag("Green finance"), Subtag("Green economy"), Subtag("Investment"), Subtag("Professional development"),Subtag("Wealth management"),Subtag("Initial Public Offering"),Subtag("Economic growth"),Subtag("Foreign investment"), Subtag("Investment bank"), Subtag("Human capital"),Subtag("National Fund"), Subtag("Pension Fund"), Subtag("Bonds"), Subtag("Sovereign bonds"), Subtag("Sovereign rating"), Subtag("Credit rating"), Subtag("Spread"), Subtag("Yield"), Subtag("Valuation"), Subtag("Budget deficit or surplus"), Subtag("Investor"), Subtag("Investment climate"), Subtag("International projects"),Subtag("Import"), Subtag("Export")], true),
                 
                 Tag("Kazakh Tenge", "4CD964".hexColor, [Subtag("Oil price"), Subtag("Russian rubble"), Subtag("Shale gas"), Subtag("US Dollar"), Subtag("Euro"), Subtag("Chinese Yen"),Subtag("Bit coin"),Subtag("Ethereum"),Subtag("Crypto currency"),Subtag("Federal reserve rate"), Subtag("National Bank")], true),
                 
                 Tag("National Companies", "FF9500".hexColor, [Subtag("Privatization"), Subtag("Kazatomprom"), Subtag("Kazmunaigas"), Subtag("Kazpost"), Subtag("Kazakhtelecom"), Subtag("Air Astana"),Subtag("Kazakhmys"),Subtag("ERG"),Subtag("Baiterek"),Subtag("Tauken Samruk"), Subtag("People IPO")], true),
                 
                 Tag("AIFC Bureau for CPD", "FF3B30".hexColor, [Subtag("CFA"), Subtag("ACCA"), Subtag("CIMA"), Subtag("Blended learning"), Subtag("CISI"), Subtag("FRM"),Subtag("GARP"),Subtag("CIPD"),Subtag("HRCI"),Subtag("Professional Certifications"), Subtag("Financial literacy"), Subtag("Investment Literacy"), Subtag("Soft skills"), Subtag("Hard skills"), Subtag("Continuing education"), Subtag("FAA"), Subtag("BIBF"),Subtag("Islamic Finance"),Subtag("Fintech education"),Subtag("IT education"),Subtag("Outsourcing"), Subtag("Shared servicing"), Subtag("Outstaffing"), Subtag("Personnel leasing"), Subtag("Agile"), Subtag("Human resources")], true),
                 
                 
                 Tag("People", "FFCC00".hexColor, [Subtag("Kairat Kelimbetov"), Subtag("Nurlan Kussainov"), Subtag("Sayasat Nurbek"), Subtag("Marat Aitenov"), Subtag("Kairat Aitekenov"), Subtag("Baur Bektemirov"),Subtag("Yernur Rysmagambetov")], true),
                 
                 Tag("Global Partners", "NASDAQ".hexColor, [Subtag("Shanghai Stock Exchange"), Subtag("Coursera"), Subtag("Blackrock"), Subtag("Blackstone"), Subtag("Wealthfront"), Subtag("Robin hood"),Subtag("Bitfury"), Subtag("Givtech"), Subtag("Moin")], true)
            ])
    }
}

class Subtag {
    var subtag = String()
    
    init(_ subtag: String){
        self.subtag = subtag
    }
}
