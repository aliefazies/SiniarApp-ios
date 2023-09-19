//
//  SmallPrimaryButton.swift
//  SiniarApp-ios
//
//  Created by Alief Ahmad Azies on 19/09/23.
//

import UIKit

class SmallPrimaryButton: PrimaryButton {
    override func setup() {
        super.setup()
        
        titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
    }
}
