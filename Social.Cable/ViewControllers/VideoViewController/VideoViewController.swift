//
//  VideoViewController.swift
//  Social.Cable
//
//  Created by Arun Kumar Rathore on 03/08/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class VideoViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var heightCollectionView: NSLayoutConstraint!
    
    let CELL_ID = "VideoTypeCell"
//    var arrayVideoType = ["video_type1", "video_type2", "video_type3"]
//    var arrayVideoTypeName = ["Upload Episode", "Short Movies", "TV Series"]
    var arrayVideoType = ["video_type1", "video_type2"]
    var arrayVideoTypeName = ["Upload Episode", "Short Movies"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupViewDidLoadMethod()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationImage("nav_logo")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationTitleImageView.removeFromSuperview()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = self.collectionView.collectionViewLayout.collectionViewContentSize.height
        self.heightCollectionView.constant = height
        self.view.layoutIfNeeded()
    }
    
    func setupViewDidLoadMethod() -> Void {
        self.view.backgroundColor = UIColor.colorWithHexString(ColorCode.appBackground.rawValue)
        self.setupBackBarButton()
        self.setupRightNavBarButton()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 15)
        self.collectionView.register(UINib.init(nibName: "VideoTypeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: self.CELL_ID)
        self.collectionView.backgroundColor = .clear
        self.buttonNext.backgroundColor = UIColor.colorWithHexString(ColorCode.buttonBackground.rawValue)
        self.buttonNext.layer.cornerRadius = self.buttonNext.bounds.height / 2
    }
    
//    UICollectionView Delegate and datasource Method
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayVideoType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.CELL_ID, for: indexPath) as! VideoTypeCollectionViewCell
        cell.contentView.backgroundColor = .clear
        
        cell.labelVideoType.text = self.arrayVideoTypeName[indexPath.row]
        cell.imageViewVideoType.image = UIImage.init(named: self.arrayVideoType[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: (self.screenWidth - 45) / 2, height: (self.screenWidth - 45) / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let uploadEpisodeVC = UploadEpisodeViewController.init(nibName: "UploadEpisodeViewController", bundle: nil)
            self.navigationController?.pushViewController(uploadEpisodeVC, animated: true)
        }else if indexPath.row == 1 {
            
        }else {
            
        }
    }
    
    @IBAction func buttonNextAction(_ sender: UIButton) {
        
    }
}
