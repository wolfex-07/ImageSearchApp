//
//  NetworkingService.swift
//  
//
//  Created by Karan Jaiswal on 24/02/24.
//

import Foundation

protocol ImageServiceProtocol {
    func fetchImageData(searchText: String, perPage: Int, page: Int, completion: @escaping (Result<[Photo], Error>) -> Void)
}


class ImageService: ImageServiceProtocol {
    static let shared = ImageService()
    
    private let baseURL = "https://api.flickr.com/services/rest/"
    private let apiKey = "3c78177ed30cae94576c35797b9e2adc"
    
    func fetchImageData(searchText: String, perPage: Int, page: Int, completion: @escaping (Result<[Photo], Error>) -> Void) {
       
        let queryItems = [
            URLQueryItem(name: "method", value: "flickr.photos.search"),
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "text", value: searchText),
            URLQueryItem(name: "per_page", value: "\(perPage)"),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1")
        ]
        
        var components = URLComponents(string: baseURL)
        components?.queryItems = queryItems
        
        guard let url = components?.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.invalidData))
                return
            }
            
            do {
                // Parse the JSON response accordingly
                let decodedData = try JSONDecoder().decode(Welcome.self, from: data)
                if let photos = decodedData.photos {
                    if let photoArray = photos.photo {
                        completion(.success(photoArray))
                    } else {
                        completion(.failure(NetworkError.invalidData))
                    }
                } else {
                    completion(.failure(NetworkError.invalidData))
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}

struct Welcome: Codable {
    let photos: Photos?
    let stat: String?
}

// MARK: - Photos
struct Photos: Codable {
    let page, pages, perpage, total: Int?
    let photo: [Photo]?
}

// MARK: - Photo
struct Photo: Codable {
    let id, owner, secret, server: String?
    let farm: Int?
    let title: String?
    let ispublic, isfriend, isfamily: Int?
}
