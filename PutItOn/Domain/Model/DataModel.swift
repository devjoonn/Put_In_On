//
//  Data.swift
//  PutItOn
//
//  Created by 박현준 on 2023/04/24.
//

import UIKit

struct DataModel {
    var dataId: String
    var imageUrl: String
    var timeString: String
    
    init(dataId: String, imageUrl: String, timeString: String) {
        self.dataId = dataId
        self.imageUrl = imageUrl
        self.timeString = timeString
    }
}
