//
//  Carousel.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/8/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import SwiftyJSON
import Foundation

struct CarouselItemJSONKeys {
    static let type = "type"
    static let imageURL = "image_url"
}

enum CarouselItemType: String {
    case image = "image"
    case progressReport = "progress_report"
    case paymentRecord = "payment_record"
    
    case undefined
}

struct CarouselItem {
    
    var type: CarouselItemType
    var imageString: String?
    
    /// Image path
    var imageURL: URL? {
        return URL(string: imageString ?? "")
    }
    
    // MARK: - Initialization
    init(source: JSON) {
        
        self.type = CarouselItemType(rawValue: source[CarouselItemJSONKeys.type].string ?? "") ?? .undefined
        self.imageString = source[CarouselItemJSONKeys.imageURL].string
    }
}
