//
//  TVViewController.swift
//  TMDB
//
//  Created by Taha Darendeli on 1.08.2019.
//  Copyright © 2019 Taha Darendeli. All rights reserved.
//

import UIKit

class TVViewController: UIViewController {

    @IBOutlet weak var topRatedCollView: UICollectionView!
    @IBOutlet weak var popularCollView: UICollectionView!
    
    var topRatedShows : [TVEntity] = []
    var popularShows : [TVEntity] = []
    
    let topRatedReuseIdentifier = "topRatedCell"
    let popularReuseIdentifier = "popularCell"
    
    var topRatedPageCounter = 1
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
        TVEntity.getList(endPoint: "top_rated", result: { result in
            if let result = result {
                self.topRatedShows += result
            }
            self.topRatedCollView.reloadData()
        })
        
        TVEntity.getList(endPoint: "popular", result: { result in
            if let result = result {
                self.popularShows += result
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
        adjustPopularCollectionView()
    }
    
    func adjustTopRatedCollectionView() {
        topRatedCollView.delegate = self
        topRatedCollView.dataSource = self
        
        let cellWidthScaling : CGFloat = 0.35
        let cellHeightScaling : CGFloat = 0.90
        
        let viewSize = topRatedCollView.bounds.size
        let cellWidth = floor(viewSize.width * cellWidthScaling)
        let cellHeight = floor(viewSize.height * cellHeightScaling)
        
        let inset = 20
        
        let layout = topRatedCollView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        topRatedCollView.contentInset = UIEdgeInsets(top: 0, left: CGFloat(inset), bottom: 0, right: CGFloat(inset))
        layout.minimumLineSpacing = 12
    }
    
    func adjustPopularCollectionView() {
        popularCollView.delegate = self
        popularCollView.dataSource = self
        
        let cellWidthScaling : CGFloat = 0.80
        let cellHeightScaling : CGFloat = 0.65
        
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

extension TVViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == topRatedCollView {
            return self.topRatedShows.count
        } else if collectionView == popularCollView {
            return self.popularShows.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == topRatedCollView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: topRatedReuseIdentifier,
                                                          for: indexPath) as! NowPlayingCell
            
            cell.lblTitle.text = topRatedShows[indexPath.row].name
            let posterURL = URL(string: topRatedShows[indexPath.row].poster_path)
            cell.imgPoster.kf.setImage(with: posterURL, placeholder: #imageLiteral(resourceName: "placeholder"),
                                       options: [
                                        .scaleFactor(UIScreen.main.scale),
                                        .transition(.fade(1)),
                                        .cacheOriginalImage
                ])
            cell.imgPoster.layer.cornerRadius = 10.0
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: popularReuseIdentifier,
                                                          for: indexPath) as! PopularCell
            cell.lblTitle.text = popularShows[indexPath.row].name
            cell.lblRate.text = popularShows[indexPath.row].vote_average.description
            let posterURL = URL(string: popularShows[indexPath.row].backdrop_path)
            cell.imgPoster.kf.setImage(with: posterURL, placeholder: #imageLiteral(resourceName: "placeholder"),
                                       options: [
                                        .scaleFactor(UIScreen.main.scale),
                                        .transition(.fade(1)),
                                        .cacheOriginalImage
                ])
            cell.imgPoster.layer.cornerRadius = 10.0
            cell.rateView.layer.cornerRadius = cell.rateView.bounds.height / 2
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let form = Utility.instantiate(name: ViewControllers.MOVIEDETAIL.rawValue, withStoryboard: StoryBoards.MAIN) as! DetailViewController
        
        if collectionView == topRatedCollView {
            form.selectedItem = self.topRatedShows[indexPath.row]
        } else if collectionView == popularCollView {
            form.selectedItem = self.popularShows[indexPath.row]
        }
        
        if form.selectedItem != nil {
            self.navigationController?.pushViewController(form, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if collectionView == topRatedCollView {
            
            if indexPath.row == topRatedShows.count - 1 {
                
                self.topRatedPageCounter += 1
                TVEntity.getList(endPoint: "top_rated", extensionParameters: "page=\(topRatedPageCounter)", result: { result in
                    if let result = result {
                        self.topRatedShows += result
                    }
                    self.topRatedCollView.reloadData()
                })
            }
        } else if collectionView == popularCollView {
            
            if indexPath.row == popularShows.count - 1 {
                
                self.popularPageCounter += 1
                TVEntity.getList(endPoint: "popular", extensionParameters: "page=\(popularPageCounter)", result: { result in
                    if let result = result {
                        self.popularShows += result
                    }
                    self.popularCollView.reloadData()
                })
            }
        }
    }
}
