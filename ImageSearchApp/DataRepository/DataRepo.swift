//
//  DataRepo.swift
//  ImageSearchApp
//
//  Created by Karan Jaiswal on 24/02/24.
//

import Foundation

protocol DataRepositoryProtocol {
    func fetchImages(searchText: String, page: Int, completion: @escaping (Result<[Photo], Error>) -> Void)
}

class DataRepository: DataRepositoryProtocol {
    let imageService: ImageServiceProtocol
    
    init(imageService: ImageServiceProtocol = ImageService() as ImageServiceProtocol) {
        self.imageService = imageService
    }
    
    func fetchImages(searchText: String, page: Int, completion: @escaping (Result<[Photo], Error>) -> Void) {
        imageService.fetchImageData(searchText: searchText, perPage: 10, page: page, completion: completion)
    }
}
