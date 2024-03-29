//
//  HTTPClient.swift
//  Networking aka Combine
//
//  Created by Hamza Azhar on 2024-03-28.
//

import Foundation
import Combine

/*
 
 This code defines a HTTPClient class responsible for making HTTP requests to fetch movies from an API. Here's a breakdown of its key components:

 Enum NetworkError: This enum defines a set of network-related errors. In this case, it includes only one case badNetworkRequest.

 Class HTTPClient: This class represents an HTTP client responsible for fetching movies from the OMDB API. It has a method fetchMovies(search:) that takes a search query string and returns a publisher that emits an array of Movie objects or an error.

 Method fetchMovies(search:): This method constructs a URL using the provided search query string and the API key. It then makes an HTTP request using URLSession.shared.dataTaskPublisher(for:), which returns a publisher that emits a tuple containing the data and the URL response. The data is decoded into a MovieResponse object using a JSON decoder.

 Mapping and Error Handling: After decoding the data, the method maps it to extract the array of Movie objects. It also sets the execution queue to the main thread using receive(on:) to ensure UI updates happen on the main thread. In case of errors during the process, it catches them and returns an empty array of Movie objects using catch.

 Publishers and eraseToAnyPublisher(): The method returns a publisher that emits an array of Movie objects or an error. To make the return type more flexible, it uses eraseToAnyPublisher() to erase the specific types of publishers.

 Overall, this HTTPClient class encapsulates the logic for making HTTP requests to fetch movies and handles errors that may occur during the process.
 */

enum NetworkError: Error {
    case badNetworkRequest
}

class HTTPClient {
    
    let apiKey = "daae4e24"
    
    func fetchMovies(search: String) -> AnyPublisher<[Movie], Error> {
        guard let encodedSearch = search.urlEncoded, let url = URL(string: "https://www.omdbapi.com/?s=\(encodedSearch)&page=2&apiKey=\(apiKey)") else {
            return Fail(error: NetworkError.badNetworkRequest).eraseToAnyPublisher()
        }
        print(url)
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MovieResponse.self, decoder: JSONDecoder())
            .map(\.movieList)
            .receive(on: DispatchQueue.main)
            .catch { error -> AnyPublisher<[Movie], Error> in
                return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
