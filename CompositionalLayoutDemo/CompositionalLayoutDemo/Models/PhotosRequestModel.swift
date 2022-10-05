//
//  PhotosRequestModel.swift
//  CompositionalLayoutDemo
//
//  Created by thoonk on 2022/10/05.
//

import Foundation

struct PhotosRequestModel: Encodable {
    var count: Int? = nil
    
    init(count: Int? = nil) {
        self.count = count
    }
}
