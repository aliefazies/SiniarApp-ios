//
//  PodcastViewController.swift
//  SiniarApp-ios
//
//  Created by Alief Ahmad Azies on 02/10/23.
//

import UIKit
import Kingfisher
import FeedKit

class PodcastViewController: UIViewController {
    
    weak var tableView: UITableView!
    
    var podcast: Podcast!
    var rssFeed: Playlist?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setup()
        loadData()
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerProviderStateDidChange(_:)), name: .PlayerProviderStateDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .PlayerProviderStateDidChange, object: nil)
    }
    
    func setup() {
        view.backgroundColor = .Siniar.brand2
        
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
        tableView.register(PodcastDetailViewCell.self, forCellReuseIdentifier: PodcastDetailViewCell.identifier)
        tableView.register(EpisodeViewCell.self, forCellReuseIdentifier: EpisodeViewCell.identifier)
        tableView.dataSource = self
        
        let backButton = UIButton(type: .system)
        view.addSubview(backButton)
        backButton.setImage(UIImage(named: "btn_back")?.withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.setTitle(nil, for: .normal)
        backButton.layer.cornerRadius = 12
        backButton.layer.masksToBounds = true
        backButton.backgroundColor = .Siniar.brand2.withAlphaComponent(0.6)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
        ])
        backButton.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
        
    }
    
}

// MARK: - Helpers
extension PodcastViewController {
    @objc func backButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @objc func playerProviderStateDidChange(_ sender: Any) {
        if PlayerProvider.shared.playlist == rssFeed {
            tableView.reloadData()
        }
    }
    
    func loadData() {
        ApiProvider.shared.loadFromFeedUrl(podcast.feedUrl) { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .success(let feed):
                self.rssFeed = feed
                self.tableView.reloadData()
            case .failure(let error):
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
            }
        }
    }
    
    func play(_ index: Int) {
        let playerProdiver = PlayerProvider.shared
        if let playlist = rssFeed {
            if playerProdiver.playlist == playlist, playerProdiver.currentIndex == index {
                playerProdiver.podcastPlay()
            } else {
                playerProdiver.launchPodcastPlaylist(playlist: playlist, index: index)
            }
        }
    }
}

// MARK: - Navigation
extension UIViewController {
    func showPodcastViewController(_ podcast: Podcast) {
        let viewController = PodcastViewController()
        viewController.podcast = podcast
        present(viewController, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension PodcastViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return rssFeed?.items?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PodcastDetailViewCell.identifier, for: indexPath) as? PodcastDetailViewCell else { return UITableViewCell() }
            cell.artworkImageView.kf.setImage(with: URL(string: podcast.artworkUrl600))
            cell.titleLabel.text = podcast.collectionName
            cell.subtitleLabel.text = podcast.artistName
            cell.descTextView.attributedText = rssFeed?.description?
                .convertHtmlToAttributedStringWithCSS(
                    font: UIFont.systemFont(ofSize: 14, weight: .regular),
                    cssColor: "#EEEEEE",
                    lineHeight: 18,
                    cssTextAlign: "left"
                )
            cell.genreLabel.text = podcast.genres.joined(separator: ", ")
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeViewCell.identifier, for: indexPath) as? EpisodeViewCell else { return UITableViewCell() }
            let episode = rssFeed?.items?[indexPath.row]
            let urlString = episode?.iTunes?.iTunesImage?.attributes?.href ?? ""
            cell.episodeImageView.kf.setImage(with: URL(string: urlString))
            cell.dateLabel.text = episode?.pubDate?.string(format: "d MMM yyyy")
            cell.titleLabel.text = episode?.title ?? ""
            cell.descTextView.attributedText = episode?.description?.convertHtmlToAttributedStringWithCSS(font: .systemFont(ofSize: 12, weight: .regular), cssColor: "#EEEEEE", lineHeight: 16, cssTextAlign: "left")
            cell.durationLabel.text = episode?.iTunes?.iTunesDuration?.durationString
            cell.delegate = self
            
            let playerProvider = PlayerProvider.shared
            if playerProvider.playlist == rssFeed, playerProvider.currentIndex == indexPath.row, playerProvider.isPodcastPlaying() {
                cell.playButton.setImage(UIImage(named: "btn_pause_small")?.withRenderingMode(.alwaysOriginal), for: .normal)
            } else {
                cell.playButton.setImage(UIImage(named: "btn_play_small")?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
            
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension PodcastViewController: EpisodeViewCellDelegate {
    func episodeViewCellPlayButtonTapped(_ cell: EpisodeViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            play(indexPath.row)
        }
    }
}
