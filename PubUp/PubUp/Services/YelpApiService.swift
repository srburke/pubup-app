//
//  YelpApiService.swift
//  PubUp
//
//  Created by Shannon Burke on 5/8/23.
//  Sources: Gary Tokman Yelp API Tutorial & Yelp API Documentation
//

import Foundation
import CoreLocation
import Combine
import FirebaseFirestoreSwift
import FirebaseFirestore

// MARK: My personal API key for security reasons this is not recommended, but for the project this will do
// MARK: If you'd like to use your own, place it here
let apiKey = "zNwWhyeCyp6V2LeUrfDszGKoaIT3iGl4HsO-zd7ikYHI2q6VXjuyXkIiVJTFIEYOMpcGAAh-qgAIDO5lwzJEknY1bzWoUlEVXG8egGS9rTqg-HLyNqsOerWNxFdZZHYx"

struct YelpApiService {
    // search term, user location, category       // output to update list
    var request: (Endpoint) -> AnyPublisher<[Business], Never>
    var details: (Endpoint) -> AnyPublisher<Business?, Never>
    var completion: (Endpoint) -> AnyPublisher<[Term], Never>
}

extension YelpApiService {
    static let live = YelpApiService (
        request: { endpoint in
            // url component for yelp endpoint
            return URLSession.shared.dataTaskPublisher(for: endpoint.request)
                .map(\.data)
                .decode(type: SearchResult.self, decoder: JSONDecoder())
                .map(\.businesses)
                .replaceError(with: [])
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        },
        details: { endpoint in
            // URL request and return Business?
            return URLSession.shared.dataTaskPublisher(for: endpoint.request)
                .map(\.data)
                .decode(type: Business?.self, decoder: JSONDecoder())
                .replaceError(with: nil)
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
    ) { endpoint in
        // URL request and return [Businesses]
        return URLSession.shared.dataTaskPublisher(for: endpoint.request)
            .map(\.data)
            .decode(type: Completions.self, decoder: JSONDecoder())
            .map(\.terms)
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

enum Endpoint {
    case search(term: String?, location: CLLocation, cat: String?)
    case detail(id: String)
    case completion(text: String, location: CLLocation)
    
    var path: String {
        switch self {
        case .search:
            return "/v3/businesses/search"
        case .detail(let id):
            return "/v3/businesses/\(id)"
        case .completion:
            return "/v3/autocomplete"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .search(let term, let location, let cat):
            return [
                .init(name: "term", value: term),
                .init(name: "longitude", value: String(location.coordinate.longitude)),
                .init(name: "latitude", value: String(location.coordinate.latitude)),
                .init(name: "categories", value: cat),
            ]
        case .completion(let text, let location):
            return [
                .init(name: "text", value: text),
                .init(name: "longitude", value: String(location.coordinate.longitude)),
                .init(name: "latitude", value: String(location.coordinate.latitude)),
            ]
        case .detail:
            return []
        }
    }
    
    var request: URLRequest {
        var urlComponents = URLComponents(string: "https://api.yelp.com")!
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        return request
    }
}

// MARK: - Completions
struct Completions: Codable {
    let terms: [Term]
    let businesses: [Business]
    let cats: [Category]
}

// MARK: - Term
struct Term: Codable {
    let text: String
}

// MARK: - SearchResult

struct SearchResult: Codable {
    let businesses: [Business]
}

// MARK: - Business
struct Business: Codable {
    
    let id, price, alias: String?
    let phone: String?
    let isClosed: Bool?
    let categories: [Category]?
    let name: String?
    let url: String?
    let coordinates: Coordinates?
    let imageURL: String?
    let location: Location?
   

    enum CodingKeys: String, CodingKey {
        case id, price, alias
        case phone = "display_phone"
        case isClosed = "is_closed"
        case categories
        case name, url, coordinates
        case imageURL = "image_url"
        case location
      
    }

}

// MARK: - Category
struct Category: Codable {
    let alias, title: String?
}

// MARK: - Coordinates
struct Coordinates: Codable {
    let latitude, longitude: Double?
}

// MARK: - Location
struct Location: Codable {
    let city, country, address2, address3: String?
    let state, address1, zipCode: String?
    let displayAddress: [String]?
    
    enum CodingKeys: String, CodingKey {
        case city, country, address2, address3, state, address1
        case zipCode = "zip_code"
        case displayAddress = "display_address"
    }
}

// MARK: -Region
struct Region: Codable {
    let center: Coordinates?
}

extension Business {
    
    var formatCat: String {
        categories?.first?.title ?? "none"
    }
    
    var catDesc: String {
          categories?
              .lazy
              .compactMap(\.title)
              .reduce("", { $0 + "\($1) • " })
              .dropLast()
              .dropLast()
              .reduce("", { $0 + String($1) })
              ?? "None"
      }
    
    var formatName: String {
        name ?? "none"
    }
    
    var formatPhone: String {
        phone ?? "none"
    }
    
    var formatPrice: String {
        price ?? "none"
    }
    
    var formatAddress: String {
        location?.displayAddress?.first ?? "none"
    }
    
    var formatImageURL: URL? {
        if let imageUrl = imageURL {
            return URL(string: imageUrl)
        }
        return nil
    }
}

//extension Open {
//
//    // Converts military time to hour:min format
//    var getTime: String {
//        guard let start = start, let end = end else {return ""}
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "HHmm"
//        let startTime = dateFormatter.date(from: start)!
//        let endTime = dateFormatter.date(from: end)!
//        dateFormatter.dateFormat = "h:mm a"
//        return "\(dateFormatter.string(from: startTime)) - \(dateFormatter.string(from: endTime))"
//    }
//
//}

extension Business {
    init(
        model: BusinessModel
   
    ){
        
        self.init(id: model.id, price: model.price, alias: nil, phone: model.phone, isClosed: nil, categories: [.init(alias: nil, title: model.cat)], name: model.name, url: nil, coordinates: nil, imageURL: model.imageUrl, location: .init(city: nil, country: nil, address2: nil, address3: nil, state: nil, address1: model.location, zipCode: nil, displayAddress: model.location.map{[$0]}))
        
       
    }
}

