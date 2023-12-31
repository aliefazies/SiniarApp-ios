//
//  FtuxViewController.swift
//  SiniarApp-ios
//
//  Created by Alief Ahmad Azies on 19/09/23.
//

import UIKit

class FtuxViewController: UIViewController {
    weak var collectionView: UICollectionView!
    weak var pageControl: UIPageControl!
    weak var startButton: PrimaryButton!
    
    let data: [Ftux] = [
        Ftux(image: "img_ftux1", title: "WELCOME TO SINIAR APP", subtitle: "Make your design workflow easier and save your time"),
        Ftux(image: "img_ftux2", title: "WELCOME TO SINIAR APP", subtitle: "Make your design workflow easier and save your time"),
        Ftux(image: "img_ftux3", title: "WELCOME TO SINIAR APP", subtitle: "Make your design workflow easier and save your time"),
        Ftux(image: "img_ftux4", title: "WELCOME TO SINIAR APP", subtitle: "Make your design workflow easier and save your time"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setup() {
        view.backgroundColor = .Siniar.brand2
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(collectionView)
        self.collectionView = collectionView
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        collectionView.backgroundColor = .Siniar.brand2
        collectionView.isPagingEnabled = true
        collectionView.register(FtuxViewCell.self, forCellWithReuseIdentifier: FtuxViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let startButton = PrimaryButton()
        view.addSubview(startButton)
        self.startButton = startButton
        startButton.setTitle("Get Started", for: .normal)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            startButton.heightAnchor.constraint(equalToConstant: 46),
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        ])
        startButton.addTarget(self, action: #selector(startButtonTapped(_:)), for: .touchUpInside)
        
        let pageControl = UIPageControl()
        view.addSubview(pageControl)
        self.pageControl = pageControl
        pageControl.currentPageIndicatorTintColor = .Siniar.brand1
        pageControl.pageIndicatorTintColor = .Siniar.neutral2
        pageControl.isUserInteractionEnabled = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.leadingAnchor.constraint(equalTo: startButton.leadingAnchor),
            pageControl.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -100)
        ])
        if #available(iOS 14.0, *) {
            pageControl.backgroundStyle = .minimal
            pageControl.allowsContinuousInteraction = false
        }
        pageControl.numberOfPages = 4
        
    }
    
    @objc func startButtonTapped(_ sender: Any) {
       showMainViewController()
    }

}

extension FtuxViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FtuxViewCell.identifier, for: indexPath) as? FtuxViewCell else { return UICollectionViewCell() }
        let ftux  = data[indexPath.item]
        cell.imageView.image = UIImage(named: ftux.image)
        cell.titleLabel.text = ftux.title
        cell.subtitleLabel.text = ftux.subtitle
        
        return cell
    }
}

extension FtuxViewController: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(collectionView.contentOffset.x / collectionView.frame.width)
        pageControl.currentPage = page
    }
}

extension FtuxViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
