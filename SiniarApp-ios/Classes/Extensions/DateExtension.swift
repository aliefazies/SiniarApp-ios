//
//  DateExtension.swift
//  SiniarApp-ios
//
//  Created by Alief Ahmad Azies on 02/10/23.
//

import Foundation

extension Date {
    func string(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: self)
    }
}
