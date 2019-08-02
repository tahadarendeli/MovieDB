//
//  MovieViewController.swift
//  TMDB
//
//  Created by Taha Darendeli on 31.07.2019.
//  Copyright © 2019 Taha Darendeli. All rights reserved.
//

import UIKit
import Kingfisher

class MovieViewController: UIViewController {

    @IBOutlet weak var topRatedCollView: UICollectionView!
    @IBOutlet weak var nowPlayingCollView: UICollectionView!
    @IBOutlet weak var popularCollView: UICollectionView!
    
    var topRatedMovies : [MovieEntity] = []
    var nowPlayingMovies : [MovieEntity] = []
    var popularMovies : [MovieEntity] = []
    
    let topRatedReuseIdentifier = "topRatedCell"
    let nowPlayingReuseIdentifier = "nowPlayingCell"
    let popularReuseIdentifier = "popularCell"
    
    var topRatedPageCounter = 1
    var nowPlayingPageCounter = 1
    var popularPageCounter = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setRetrieveMovies()
        setNavigationBar()
        adjustCollectionViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    func setRetrieveMovies() {
        MovieEntity.getList(endPoint: "top_rated", result: { result in
            if let result = result {
                self.topRatedMovies += result
            }
            self.topRatedCollView.reloadData()
        })
        
        MovieEntity.getList(endPoint: "now_playing", result: { result in
            if let result = result {
                self.nowPlayingMovies += result
            }
            self.nowPlayingCollView.reloadData()
        })
        
        MovieEntity.getList(endPoint: "popular", result: { result in
            if let result = result {
                self.popularMovies += result
            }
            self.popularCollView.reloadData()
        })
    }
    
    func setNavigationBar() {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.tintColor = .clear
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.clear]
    }
    
    func adjustCollectionViews() {
        adjustTopRatedCollectionView()
        adjustNowPlayingCollectionView()
        adjustPopularCollectionView()
    }
    
    func adjustTopRatedCollectionView() {
        topRatedCollView.delegate = self
        topRatedCollView.dataSource = self
        
        let cellWidthScaling : CGFloat = 0.8
        let cellHeightScaling : CGFloat = 0.95
        
        let viewSize = topRatedCollView.bounds.size
        let cellWidth = floor(viewSize.width * cellWidthScaling)
        let cellHeight = floor(viewSize.height * cellHeightScaling)
        
        let insetX = (view.bounds.width - cellWidth) / 2.0
        
        let layout = topRatedCollView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        topRatedCollView.contentInset = UIEdgeInsets(top: 0, left: insetX, bottom: 0, right: insetX)
        layout.minimumLineSpacing = 12
    }
    
    func adjustNowPlayingCollectionView() {
        nowPlayingCollView.delegate = self
        nowPlayingCollView.dataSource = self
        
        let cellWidthScaling : CGFloat = 0.35
        let cellHeightScaling : CGFloat = 0.90
        
        let viewSize = nowPlayingCollView.bounds.size
        let cellWidth = floor(viewSize.width * cellWidthScaling)
        let cellHeight = floor(viewSize.height * cellHeightScaling)
        
        let inset = 20
        
        let layout = nowPlayingCollView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        nowPlayingCollView.contentInset = UIEdgeInsets(top: 0, left: CGFloat(inset), bottom: 0, right: CGFloat(inset))
        layout.minimumLineSpacing = 12
    }
    
    func adjustPopularCollectionView() {
        popularCollView.delegate = self
        popularCollView.dataSource = self
        
        let cellWidthScaling : CGFloat = 0.35
        let cellHeightScaling : CGFloat = 0.90
        
        let viewSize = popularCollView.bounds.size
        let cellWidth = floor(viewSize.width * cellWidthScaling)
        let cellHeight = floor(viewSize.height * cellHeightScaling)
        
        let inset = 20
        
        let layout = popularCollView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        popularCollView.contentInset = UIEdgeInsets(top: 0, left: CGFloat(inset), bottom: 0, right: CGFloat(inset))
        layout.minimumLineSpacing = 12
    }
}

extension MovieViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == topRatedCollView {
            return self.topRatedMovies.count
        } else if collectionView == nowPlayingCollView {
            return self.nowPlayingMovies.count
        } else if collectionView == popularCollView {
            return self.popularMovies.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == topRatedCollView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: topRatedReuseIdentifier,
                                                          for: indexPath) as! TopRatedCell
            
            let posterURL = URL(string: topRatedMovies[indexPath.row].backdrop_path)
            cell.imgPoster.kf.setImage(with: posterURL, placeholder: #imageLiteral(resourceName: "placeholder"),
                                    options: [
                                        .scaleFactor(UIScreen.main.scale),
                                        .transition(.fade(1)),
                                        .cacheOriginalImage
                ])
            cell.imgPoster.layer.cornerRadius = 19.0
            
            return cell
        } else if collectionView == nowPlayingCollView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: nowPlayingReuseIdentifier,
                                                          for: indexPath) as! NowPlayingCell
            cell.lblTitle.text = nowPlayingMovies[indexPath.row].title
            let posterURL = URL(string: nowPlayingMovies[indexPath.row].poster_path)
            cell.imgPoster.kf.setImage(with: posterURL, placeholder: #imageLiteral(resourceName: "placeholder"),
                                    options: [
                                        .scaleFactor(UIScreen.main.scale),
                                        .transition(.fade(1)),
                                        .cacheOriginalImage
                ])
            cell.imgPoster.layer.cornerRadius = 19.0
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: popularReuseIdentifier,
                                                          for: indexPath) as! PopularCell
            cell.lblTitle.text = popularMovies[indexPath.row].title
            cell.lblRate.text = popularMovies[indexPath.row].vote_average.description
            let posterURL = URL(string: popularMovies[indexPath.row].poster_path)
            cell.imgPoster.kf.setImage(with: posterURL, placeholder: #imageLiteral(resourceName: "placeholder"),
                                    options: [
                                        .scaleFactor(UIScreen.main.scale),
                                        .transition(.fade(1)),
                                        .cacheOriginalImage
                ])
            cell.imgPoster.layer.cornerRadius = 19.0
            cell.rateView.layer.cornerRadius = cell.rateView.bounds.height / 2
            
            return cell
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let form = Utility.instantiate(name: ViewControllers.MOVIEDETAIL.rawValue, withStoryboard: StoryBoards.MAIN) as! DetailViewController
        
        if collectionView == topRatedCollView {
            form.selectedItem = self.topRatedMovies[indexPath.row]
        } else if collectionView == nowPlayingCollView {
            form.selectedItem = self.nowPlayingMovies[indexPath.row]
        } else if collectionView == popularCollView {
            form.selectedItem = self.popularMovies[indexPath.row]
        }
        
        if form.selectedItem != nil {
            self.navigationController?.pushViewController(form, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if collectionView == topRatedCollView {
            
            if indexPath.row == topRatedMovies.count - 1 {
                
                self.topRatedPageCounter += 1
                MovieEntity.getList(endPoint: "top_rated", extensionParameters: "page=\(topRatedPageCounter)", result: { result in
                    if let result = result {
                        self.topRatedMovies += result
                    }
                    self.topRatedCollView.reloadData()
                })
            }
        } else if collectionView == nowPlayingCollView {
            
            if indexPath.row == nowPlayingMovies.count - 1 {
                
                self.nowPlayingPageCounter += 1
                MovieEntity.getList(endPoint: "now_playing", extensionParameters: "page=\(nowPlayingPageCounter)", result: { result in
                    if let result = result {
                        self.nowPlayingMovies += result
                    }
                    self.nowPlayingCollView.reloadData()
                })
            }
        } else if collectionView == popularCollView {
            
            if indexPath.row == popularMovies.count - 1 {
                
                self.popularPageCounter += 1
                MovieEntity.getList(endPoint: "popular", extensionParameters: "page=\(popularPageCounter)", result: { result in
                    if let result = result {
                        self.popularMovies += result
                    }
                    self.popularCollView.reloadData()
                })
            }
        }
    }
}
