//
//  MovieListViewModel.swift
//  Networking aka Combine
//
//  Created by Hamza Azhar on 2024-03-28.
//

import Foundation
import Combine

/*
 This code defines a MovieListViewModel class responsible for managing the list of movies displayed in the UI. Here's a breakdown of its key components:

 Published Properties:

 movies: An array of Movie objects that is marked with @Published, indicating that changes to this property should be published to subscribers.
 loadingCompleted: A boolean flag indicating whether loading of movies has completed, also marked with @Published.
 Dependencies:

 httpClient: An instance of HTTPClient responsible for fetching movies from the network.
 cancellables: A set of cancellable objects used to manage subscriptions to publishers.
 Search Subject:

 searchSubject: A CurrentValueSubject used to track the search text entered by the user. It publishes the current search text whenever it changes.
 Initialization:

 The init method initializes the MovieListViewModel with an instance of HTTPClient. It also calls setupSearchPublisher() to configure the search publisher.
 Setup Search Publisher:

 The setupSearchPublisher() method sets up a publisher for the searchSubject. It debounces the search text updates to avoid excessive network requests and then calls loadMovies(search:) to fetch movies based on the latest search text.
 Load Movies:

 The loadMovies(search:) method fetches movies from the network using the httpClient. It updates the loadingCompleted flag based on the completion of the network request and updates the movies array with the fetched movies.
 Set Search Text:

 The setSearchText(_:) method allows external components to update the search text. It sends the new search text to the searchSubject.
 */

class MovieListViewModel {
    @Published private(set) var movies: [Movie] = []
    private let httpClient: HTTPClient
    private var cancellables: Set<AnyCancellable> = []
    @Published var loadingCompleted: Bool = false
    private var searchSubject = CurrentValueSubject<String, Never>("")
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
        self.setupSearchPublisher()
    }
    
    fileprivate func setupSearchPublisher() {
        self.searchSubject
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
            self?.loadMovies(search: searchText)
        }.store(in: &cancellables)
    }
    
    func setSearchText(_ searchText: String) {
        self.searchSubject.send(searchText)
    }
    
    func loadMovies(search: String) {
        self.httpClient.fetchMovies(search: search)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.loadingCompleted = true
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] response in
                self?.movies = response
            }.store(in: &cancellables)

    }
}
