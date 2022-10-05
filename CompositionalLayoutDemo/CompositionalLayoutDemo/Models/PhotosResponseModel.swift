//
//  PhotosResponseModel.swift
//  CompositionalLayoutDemo
//
//  Created by thoonk on 2022/10/05.
//

import Foundation

struct PhotosResponseModel: Decodable {
    let urls: URLS
}

struct URLS: Decodable {
    let thumb: String
    
    var url: URL? {
        return URL(string: thumb)
    }
}
