//
//  Movie.swift
//  Networking aka Combine
//
//  Created by Hamza Azhar on 2024-03-28.
//

import Foundation

struct MovieResponse: Decodable {
    let movieList: [Movie]
    
    private enum CodingKeys: String, CodingKey {
        case movieList = "Search"
    }
}

struct Movie: Decodable {
    let title: String
    let year: String
    
    private enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
    }
}
