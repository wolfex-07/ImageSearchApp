//
//  PhotosViewModel.swift
//  ImageSearchApp
//
//  Created by Karan Jaiswal on 24/02/24.
//

import Foundation

protocol SearchViewModelProtocol {
    var imageUrl: [String] {get}
    var delegate: SearchViewModelDelegate? {get set}
    func resetImageData()
    func fetchImages(searchText: String)
}

protocol SearchViewModelDelegate: AnyObject {
    func didUpdateImageUrl()
}

class SearchViewModel: SearchViewModelProtocol {
    private let dataRepository: DataRepositoryProtocol
    private var pageCount: Int = 1
    private var searchQuery: String = ""
    internal var imageUrl: [String] = []
    weak var delegate: SearchViewModelDelegate?
    
    init(dataRepository: DataRepositoryProtocol = DataRepository()) {
        self.dataRepository = dataRepository
    }
    
    func appendImageUrls(_ urls: [String]) {
        delegate?.didUpdateImageUrl()
    }
    
    
    func resetImageData() {
        self.imageUrl.removeAll()
        delegate?.didUpdateImageUrl()
    }
    
    func fetchImages(searchText: String) {
        
        dataRepository.fetchImages(searchText: searchText, page: pageCount) { [weak self] result in
            switch result {
            case .success(let fetchedPhotos):
                self?.pageCount += 1
                print(fetchedPhotos)
                fetchedPhotos.forEach { item in
                    guard let farm = item.farm, let server = item.server, let id = item.id, let secret = item.secret else { return }
                    let image = "http://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret).jpg"
                    self?.imageUrl.append(image)
                }
                DispatchQueue.main.async {
                    self?.appendImageUrls(self?.imageUrl ?? [])
                }
            case .failure(let error):
                print("Error fetching images: \(error)")
            }
        }
    }
}
