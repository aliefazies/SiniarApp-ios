//
//  SearchViewController.swift
//  SiniarApp-ios
//
//  Created by Alief Ahmad Azies on 19/09/23.
//

import UIKit
import Kingfisher

class SearchViewController: UIViewController {
    weak var tableView: UITableView!
    weak var searchController: UISearchController!
    
    var podcastList: [Podcast] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    
    func setup() {
        title = "Search"
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        let tableView = UITableView(frame: .zero, style: .grouped)
        view.addSubview(tableView)
        self.tableView = tableView
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.register(MusicViewCell.self, forCellReuseIdentifier: MusicViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.tintColor = .Siniar.neutral1
        searchController.searchBar.barStyle = .black
        navigationItem.searchController = searchController
        self.searchController = searchController
        searchController.searchBar.delegate = self
    }
    
    // MARK: - Helpers
    func search(_ q: String) {
       print("search with keyword \(q)")
        ApiProvider.shared.search(q) { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .success(let data):
                self.podcastList = data
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true)
            }
        }
    }
    
    func loadRSSFeed(_ podcast: Podcast) {
        ApiProvider.shared.loadFromFeedUrl(podcast.feedUrl) { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .success(let feed):
                print(feed!)
            case .failure(let error):
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
            }
        }
    }
    
}

//MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcastList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MusicViewCell.identifier) as? MusicViewCell else { return UITableViewCell() }
        
        let podcast = podcastList[indexPath.row]
        cell.noLabel.isHidden = true
        cell.titleLabel.text = podcast.trackName
        cell.subtitleLabel.text = podcast.artistName
        let scale = UIScreen.main.scale
        let imageUrl: String
        switch scale {
        case 1:
            imageUrl = podcast.artworkUrl30
        case 2:
            imageUrl = podcast.artworkUrl60
        default:
            imageUrl = podcast.artworkUrl100
        }
        cell.thumbImageView.kf.setImage(with: URL(string: imageUrl))
        
        return cell
    }
    
}

//MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let podcast = podcastList[indexPath.row]
        showPodcastViewController(podcast)
        //        loadRSSFeed(podcast)
    }
}

//MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let q = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines), !q.isEmpty {
            search(q)
        } else {
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let string = NSString(string: searchBar.text ?? "").replacingCharacters(in: range, with: text)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        if string.count >= 3 {
            search(string)
        }
        return true
    }
}
