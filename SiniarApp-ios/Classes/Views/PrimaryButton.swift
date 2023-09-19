//
//  PrimaryButton.swift
//  SiniarApp-ios
//
//  Created by Alief Ahmad Azies on 19/09/23.
//

import UIKit

class PrimaryButton: UIButton {
    convenience init() {
        self.init(type: .system)
        setup()
    }
    
    func setup() {
        tintColor = UIColor.Siniar.neutral3
        backgroundColor = UIColor.Siniar.brand1
        titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        layer.cornerRadius = 4
        layer.masksToBounds = true
    }
}
