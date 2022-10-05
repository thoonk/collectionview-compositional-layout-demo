//
//  PhotoAPIService.swift
//  CompositionalLayoutDemo
//
//  Created by thoonk on 2022/10/05.
//

import Alamofire

protocol PhotoAPIServiceProtocol {
    func fetchPhotos(completion: @escaping ([PhotosResponseModel]?, Error?) -> Void)
}

final class PhotoAPIService: PhotoAPIServiceProtocol {
    func fetchPhotos(completion: @escaping ([PhotosResponseModel]?, Error?) -> Void) {
        let params = PhotosRequestModel(count: 30)
        
        AF.request(
            createURL(),
            method: .get,
            parameters: params,
            headers: setupHeader()
        ).responseDecodable(of: [PhotosResponseModel].self) { response in
            
            switch response.result {
            case .success(let data):
                completion(data, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}

private extension PhotoAPIService {
    func createURL() -> String {
        let urlString = "https://api.unsplash.com/photos/random"
        return urlString
    }
    
    func setupHeader() -> HTTPHeaders {
        let key = ""
        let headers: HTTPHeaders = [
            "Authorization": "Client-ID \(key)"
        ]
        
        return headers
    }
}
