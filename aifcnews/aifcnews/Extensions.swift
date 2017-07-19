//
//  Extensions.swift
//  aifcnews
//
//  Created by Beknar Danabek on 7/14/17.
//  Copyright © 2017 nFactorial Incubator. All rights reserved.
//

import Foundation
import UIKit


extension String {
    var hexColor: UIColor {
        let hex = trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return .clear
        }
        return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension UIColor {
    static let mainBlue = "2E4057".hexColor
    static let backgroundGrey = "EEF0F3".hexColor
    static let textGrey = "D3D3D3".hexColor
    static let textAqua = "64CCD8".hexColor
    static let textBlack = "4A4A4A".hexColor
    static let barGrey = "FAFAFA".hexColor
    static let lineGrey = "C8C7CC".hexColor
    static let textCellBlack = "343434".hexColor
}


extension UIView {
    func setBlackGradientView () {
        let colorTop = UIColor.clear.cgColor
        let colorBottom = UIColor.black.cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.bounds
        self.layer.addSublayer(gradientLayer)
    }
}
