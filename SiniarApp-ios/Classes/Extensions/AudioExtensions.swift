//
//  AudioExtensions.swift
//  SiniarApp-ios
//
//  Created by Alief Ahmad Azies on 06/10/23.
//

import Foundation
import FeedKit

typealias Audio = RSSFeedItem
extension RSSFeedItem {
    var url: String? {
        return self.enclosure?.attributes?.url
    }
    
    var pictureUrl: String? {
        return self.iTunes?.iTunesImage?.attributes?.href
    }
}
