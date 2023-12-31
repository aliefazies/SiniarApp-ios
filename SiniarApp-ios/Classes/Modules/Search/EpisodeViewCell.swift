//
//  EpisodeViewCell.swift
//  SiniarApp-ios
//
//  Created by Alief Ahmad Azies on 02/10/23.
//

import UIKit

protocol EpisodeViewCellDelegate {
    func episodeViewCellPlayButtonTapped(_ cell: EpisodeViewCell)
}

class EpisodeViewCell: UITableViewCell {
    
    weak var episodeImageView: UIImageView!
    weak var dateLabel: UILabel!
    weak var titleLabel: UILabel!
    weak var descTextView: UITextView!
    weak var playButton: UIButton!
    weak var durationLabel: UILabel!
    
    var delegate: EpisodeViewCellDelegate?
    
    static let identifier = "EpisodeViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setup() {
        backgroundColor = .clear
        selectionStyle = .none
        
        let imageView = UIImageView(frame: .zero)
        contentView.addSubview(imageView)
        self.episodeImageView = imageView
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
        ])
        
        let bottomConstraint = imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        bottomConstraint.priority = .defaultLow
        bottomConstraint.isActive = true
        
        let dateLabel = UILabel(frame: .zero)
        contentView.addSubview(dateLabel)
        self.dateLabel = dateLabel
        dateLabel.font = .systemFont(ofSize: 12, weight: .bold)
        dateLabel.textColor = .Siniar.neutral2
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
        ])
        
        let titleLabel = UILabel(frame: .zero)
        contentView.addSubview(titleLabel)
        self.titleLabel = titleLabel
        titleLabel.font = .systemFont(ofSize: 12, weight: .bold)
        titleLabel.textColor = .Siniar.neutral2
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            titleLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10)
        ])
        
        let descTextView = UITextView(frame: .zero)
        contentView.addSubview(descTextView)
        self.descTextView = descTextView
        descTextView.isScrollEnabled = false
        descTextView.isEditable = false
        descTextView.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        descTextView.textColor = .Siniar.neutral2
        descTextView.backgroundColor = .clear
        descTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descTextView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12),
            descTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor , constant: 4)
        ])
        
        let stackView = UIStackView()
        contentView.addSubview(stackView)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: descTextView.bottomAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        
        let playButton = UIButton(type: .system)
        stackView.addArrangedSubview(playButton)
        self.playButton = playButton
        playButton.setImage(UIImage(named: "btn_play")?.withRenderingMode(.alwaysOriginal), for: .normal)
        playButton.setTitle(nil, for: .normal)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playButton.widthAnchor.constraint(equalToConstant: 18),
            playButton.heightAnchor.constraint(equalToConstant: 18),
        ])
        playButton.addTarget(self, action: #selector(playButtonTapped(_:)), for: .touchUpInside)
        
        let durationLabel = UILabel(frame: .zero)
        stackView.addArrangedSubview(durationLabel)
        self.durationLabel = durationLabel
        durationLabel.textColor = .Siniar.neutral1
        durationLabel.font = .systemFont(ofSize: 12, weight: .bold)
    }
}

// MARK: - Helpers
extension EpisodeViewCell {
    @objc func playButtonTapped(_ sender: Any) {
        delegate?.episodeViewCellPlayButtonTapped(self)
    }
}
