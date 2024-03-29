//
//  ViewController.swift
//  Networking aka Combine
//
//  Created by Hamza Azhar on 2024-03-28.
//

import UIKit
import Combine

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel: MovieListViewModel = MovieListViewModel(httpClient: HTTPClient())
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    fileprivate func initialSetup() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.searchBar.delegate = self
        self.viewModel.$loadingCompleted
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completed in
                if completed {
                    self?.tableView.reloadData()
                }
            }.store(in: &cancellables)
    }
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("the count is \(self.viewModel.movies.count)")
        return self.viewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = self.viewModel.movies[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = movie.title
        return cell
    }
    
    
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel.setSearchText(searchText)
    }
}

