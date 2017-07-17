//
//  Helper.swift
//  aifcnews
//
//  Created by Beknar Danabek on 7/14/17.
//  Copyright © 2017 nFactorial Incubator. All rights reserved.
//

import Foundation
import UIKit

class Helper {

    static let shared = Helper()
    
    enum Root {
        case height
        case width
    }

    func constrain(with root: Root, num: Int) -> CGFloat {
        switch root {
        case .height:
            return (UIScreen.main.bounds.height * (CGFloat(num)/667))
        case .width:
            return (UIScreen.main.bounds.width * (CGFloat(num)/375))
        }
    }
}
