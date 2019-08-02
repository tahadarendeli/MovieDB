//
//  DetailViewController.swift
//  TMDB
//
//  Created by Taha Darendeli on 31.07.2019.
//  Copyright © 2019 Taha Darendeli. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var posterContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblGenre: UILabel!
    @IBOutlet weak var lblPlot: UILabel!
    @IBOutlet weak var starStackView: UIStackView!
    @IBOutlet weak var lblVote: UILabel!
    
    var leftBarButtonItem : UIBarButtonItem!
    var rightBarButtonItem : UIBarButtonItem!
    var selectedItem : ShowEntity!
    var credits : [CreditsEntity] = []
    let detailReuseIdentifier = "detailCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setView()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.clear]
        
        leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "left-arrow"), style: .plain, target: self, action: #selector(popViewController))
        rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icShare"), style: .plain, target: self, action: #selector(shareTapped))
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.setLeftBarButton(leftBarButtonItem, animated: false)
        self.navigationItem.setRightBarButton(rightBarButtonItem, animated: false)
    }
    
    func setView() {
        
        imgBackground.kf.setImage(with: URL(string: selectedItem.backdrop_path))
        imgPoster.kf.setImage(with: URL(string: selectedItem.poster_path), placeholder: #imageLiteral(resourceName: "placeholder"),
                              options: [
                                .scaleFactor(UIScreen.main.scale),
                                .transition(.fade(1)),
                                .cacheOriginalImage
            ])
        imgPoster.applyShadowWithCorner(containerView: posterContainerView, cornerRadious: 10.0)
        if selectedItem.isKind(of: MovieEntity.self) {
            lblTitle.text = (selectedItem as! MovieEntity).title
        } else if selectedItem.isKind(of: TVEntity.self) {
            lblTitle.text = (selectedItem as! TVEntity).name
        }
        lblPlot.text = selectedItem.overview
        
        adjustCollectionView()
    }
    
    func loadData() {
        if selectedItem.isKind(of: MovieEntity.self) {
            MovieDetailEntity.getItem(endPoint: selectedItem.id.description, result: { result in
                if let result = result {
                    self.setGenreLabel(genres: result.genres)
                    self.setStars(vote: result.vote_average)
                }
            })
            
            CreditsEntity.getList(type: "movie", id: selectedItem.id.description, result: { result in
                if let result = result {
                    self.credits = result.credits
                    self.collectionView.reloadData()
                }
            })
        } else if selectedItem.isKind(of: TVEntity.self) {
            TVDetailEntity.getItem(endPoint: selectedItem.id.description, result: { result in
                if let result = result {
                    self.setGenreLabel(genres: result.genres)
                    self.setStars(vote: result.vote_average)
                }
            })
            
            CreditsEntity.getList(type: "tv", id: selectedItem.id.description, result: { result in
                if let result = result {
                    self.credits = result.credits
                    self.collectionView.reloadData()
                }
            })
        }
    }
    
    func setGenreLabel(genres: [String]) {
        var genreLabel = ""
        for genre in genres {
            if genre != genres.last {
                genreLabel += genre + ", "
            } else {
                genreLabel += genre
            }
        }
        self.lblGenre.text = genreLabel
    }
    
    func setStars(vote: Double) {
        self.lblVote.text = vote.description
        var stars = floor(vote / 2)
        
        for imageView in (starStackView.subviews  as! [UIImageView]) {
            if stars > 0 {
                imageView.image = #imageLiteral(resourceName: "icStarSelected")
                stars -= 1
            } else {
                imageView.image = #imageLiteral(resourceName: "icStar")
            }
        }
    }
    
    func adjustCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let cellWidthScaling : CGFloat = 0.20
        let cellHeightScaling : CGFloat = 0.95
        
        let viewSize = collectionView.bounds.size
        let cellWidth = floor(viewSize.width * cellWidthScaling)
        let cellHeight = floor(viewSize.height * cellHeightScaling)
        
        let inset = 20
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: CGFloat(inset), bottom: 0, right: CGFloat(inset))
        layout.minimumLineSpacing = 12
    }
    
    @objc func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func shareTapped() {
        let text = selectedItem.overview
        
        let textToShare = [text]
        
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        activityViewController.excludedActivityTypes = [.airDrop, .message, .postToFacebook, .postToTwitter]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return credits.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: detailReuseIdentifier,
                                                      for: indexPath) as! DetailCell
        cell.lblTitle.text = credits[indexPath.row].name
        cell.lblJob.text = credits[indexPath.row].job
        let posterURL = URL(string: credits[indexPath.row].profile_path)
        cell.imgPhoto.kf.setImage(with: posterURL, placeholder: #imageLiteral(resourceName: "placeholder"),
                                   options: [
                                    .scaleFactor(UIScreen.main.scale),
                                    .transition(.fade(1)),
                                    .cacheOriginalImage
            ])
        cell.imgPhoto.layer.cornerRadius = 10.0
        
        return cell
    }
}
