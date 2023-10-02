//
//  StringExtension.swift
//  SiniarApp-ios
//
//  Created by Alief Ahmad Azies on 02/10/23.
//

import Foundation
import UIKit

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil)
        }
        catch {
            return nil
        }
    }
    
    func convertHtmlToAttributedStringWithCSS(font: UIFont?, cssColor: String, lineHeight: Int, cssTextAlign: String) -> NSAttributedString? {
        guard let font = font else {
            return htmlToAttributedString
        }
        
        let modifiedString = "<style>body{font-family: '-apple-system'; font-size:\(font.pointSize)px; color: \(cssColor); line-height: \(lineHeight)px; text-align: \(cssTextAlign); }</style>\(self)";
        guard let data = modifiedString.data(using: .utf8) else {
            return nil
        }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        }
        catch {
            print(error)
            return nil
        }
    }
    
}
