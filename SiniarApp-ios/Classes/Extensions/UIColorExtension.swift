//
//  UIColorExtension.swift
//  SiniarApp-ios
//
//  Created by Alief Ahmad Azies on 19/09/23.
//

import Foundation
import UIKit

extension UIColor {
    
    enum Siniar {
        
        static var brand1: UIColor = UIColor(rgb: 0xCBFB5E)
        
        static var brand2: UIColor = UIColor(rgb: 0x0E0B1F)
        
        static var neutral1: UIColor = UIColor(rgb: 0xEEEEEE)
        
        static var neutral2: UIColor = UIColor(rgb: 0x71737B)
        
        static var neutral3: UIColor = UIColor(rgb: 0x20242F)
        
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid red component")
        assert(blue >= 0 && blue <= 255, "Invalid red component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
