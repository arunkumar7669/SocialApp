//
//  DownloadViewController.swift
//  Social.Cable
//
//  Created by Arun Kumar Rathore on 03/08/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class DownloadViewController: BaseViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewPageMenu: UICollectionView!
    
    var selectedPageMenu = 0
    let CELL_ID = "VideoSearchCell"
    let PAGE_MENU_CELL = "PageMenuCell"
    var arrayPageMenu = ["Comedy", "Action", "Drama", "Thriller", "Horror"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupViewDidLoadMethod()
    }
    
    func setupViewDidLoadMethod() -> Void {
        
        self.view.backgroundColor = UIColor.colorWithHexString(ColorCode.appBackground.rawValue)
        
        self.collectionViewPageMenu.delegate = self
        self.collectionViewPageMenu.dataSource = self
        self.collectionViewPageMenu.register(UINib.init(nibName: "PageMenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: self.PAGE_MENU_CELL)
        UtilityMethods.addBorder(self.collectionViewPageMenu, UIColor.colorWithHexString(ColorCode.buttonBackground.rawValue), self.collectionViewPageMenu.bounds.height / 2)
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib.init(nibName: "VideoSearchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: self.CELL_ID)
        self.collectionView.backgroundColor = .clear
        self.collectionViewPageMenu.backgroundColor = .clear
        self.collectionView.frame = CGRect.init(x: self.collectionView.frame.origin.x, y: self.collectionView.frame.origin.y, width: self.screenWidth, height: self.collectionView.frame.height)
        self.collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 5, bottom: 10, right: 5)
        
        self.searchBar.searchBarBackgroundColor(color: UIColor.colorWithHexString(ColorCode.appBackground.rawValue))
        self.searchBar.barTintColor =  UIColor.colorWithHexString(ColorCode.appBackground.rawValue)
        self.searchBar.delegate = self
        self.searchBar.backgroundImage = UIImage()
    }
    
    //    UICollectionView Delegate and datasource Method
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionViewPageMenu {
            return self.arrayPageMenu.count
        }else {
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionViewPageMenu {
            return self.setupPageMenuCell(collectionView, indexPath)
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.CELL_ID, for: indexPath) as! VideoSearchCollectionViewCell
            cell.contentView.backgroundColor = .clear
            
            cell.viewLike.layer.cornerRadius = cell.viewLike.bounds.height / 2
            cell.viewLike.backgroundColor = UIColor.colorWithHexString(ColorCode.buttonBackground.rawValue)
                    
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionViewPageMenu {
        
        let label = UILabel(frame: CGRect.zero)
        label.text = self.arrayPageMenu[indexPath.row]
        label.sizeToFit()
        return CGSize.init(width: label.frame.width + 30, height: 40)
        }else {
            return CGSize.init(width: (self.screenWidth - 15) / 2, height: ((self.screenWidth - 15) / 2) + 70)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.collectionViewPageMenu {
            return 0
        }else {
            return 5.0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.collectionViewPageMenu {
            return 0
        }else {
            return 5.0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionViewPageMenu {
            self.selectedPageMenu = indexPath.row
            self.collectionViewPageMenu.reloadData()
        }
    }
    
    //    MARK:- Setup Collection View Cell
    func setupPageMenuCell(_ collectionView : UICollectionView, _ indexPath : IndexPath) -> PageMenuCollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.PAGE_MENU_CELL, for: indexPath) as! PageMenuCollectionViewCell
        cell.labelMenuItem.text = self.arrayPageMenu[indexPath.row]
        
        if indexPath.row == self.selectedPageMenu {
            
            UtilityMethods.addBorder(cell.viewBg, UIColor.colorWithHexString(ColorCode.buttonBackground.rawValue), self.collectionViewPageMenu.bounds.height / 2)
            cell.viewBg.backgroundColor = UIColor.colorWithHexString(ColorCode.buttonBackground.rawValue)
            cell.labelMenuItem.textColor = .white
        }else{
            
            cell.viewBg.backgroundColor = .clear
            cell.labelMenuItem.textColor = .white
            UtilityMethods.addBorder(cell.viewBg, .clear, 15.0)
        }
        
        return cell
    }
    
//    Button Search Action
    func searchBarSearchButtonClicked(_ seachBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
}
