//
//  VideoListViewController.swift
//  Social.Cable
//
//  Created by Arun Kumar Rathore on 12/08/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class VideoListViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

//    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewPageMenu: UICollectionView!
    @IBOutlet weak var labelNoData: UILabel!
    
    var selectedPageMenu = 0
    let CELL_ID = "VideoSearchCell"
    let PAGE_MENU_CELL = "PageMenuCell"
    var arrayPageMenu = Array<Dictionary<String, Any>>()
    var arrayVideoList = Array<Dictionary<String, Any>>()
    var categoryDetails = Dictionary<String, Any>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupViewDidLoadMethod()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationImage("cable_logo")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationTitleImageView.removeFromSuperview()
    }
    
    func setupViewDidLoadMethod() -> Void {
        
        self.view.backgroundColor = UIColor.colorWithHexString(ColorCode.appBackground.rawValue)
        self.setupBackBarButton()
        self.labelNoData.isHidden = true
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
        
//        self.searchBar.searchBarBackgroundColor(color: UIColor.colorWithHexString(ColorCode.appBackground.rawValue))
//        self.searchBar.barTintColor =  UIColor.colorWithHexString(ColorCode.appBackground.rawValue)
//        self.searchBar.delegate = self
//        self.searchBar.backgroundImage = UIImage()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.collectionViewPageMenu.selectItem(at: IndexPath(row: self.selectedPageMenu, section: 0), animated: true, scrollPosition: .left)
        }
        self.categoryDetails = self.arrayPageMenu[selectedPageMenu]
        if self.categoryDetails["id"] as? Int != nil {
            let categoryID = self.categoryDetails["id"] as! Int
            self.webApiGetVideoListByCategory("\(categoryID)")
        }
    }
    
    //    UICollectionView Delegate and datasource Method
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionViewPageMenu {
            return self.arrayPageMenu.count
        }else {
            return self.arrayVideoList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionViewPageMenu {
            return self.setupPageMenuCell(collectionView, indexPath)
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.CELL_ID, for: indexPath) as! VideoSearchCollectionViewCell
            cell.contentView.backgroundColor = .clear
            let dictionaryVideo = self.arrayVideoList[indexPath.row]
            cell.viewLike.layer.cornerRadius = cell.viewLike.bounds.height / 2
            cell.viewLike.backgroundColor = UIColor.colorWithHexString(ColorCode.buttonBackground.rawValue)
            var imageUrl = String()
            if dictionaryVideo["channel_logo_image_url"] as? String == nil {
                imageUrl = ""
            }else {
                imageUrl = dictionaryVideo["channel_logo_image_url"] as! String
            }
            imageUrl = imageUrl.replacingOccurrences(of: " ", with: "%20")
            
            var imageVideoUrl = String()
            if dictionaryVideo["movie_thumbnail"] as? String == nil {
                imageVideoUrl = ""
            }else {
                imageVideoUrl = dictionaryVideo["movie_thumbnail"] as! String
            }
            imageVideoUrl = imageVideoUrl.replacingOccurrences(of: " ", with: "%20")
            if dictionaryVideo["channel_name"] as? String != nil {
                cell.labelCategory.text = (dictionaryVideo["channel_name"] as! String)
            }else {
                cell.labelCategory.text = ""
            }
            if cell.labelCategory.text!.isEmpty {
                cell.labelCategory.isHidden = true
                cell.imageViewCategory.isHidden = true
                cell.ViewCategoryBg.isHidden = true
            }else {
                cell.labelCategory.isHidden = false
                cell.imageViewCategory.isHidden = false
                cell.ViewCategoryBg.isHidden = false
            }
            if dictionaryVideo["video_title"] as? String != nil {
                cell.labelTitle.text = (dictionaryVideo["video_title"] as! String)
            }else {
                cell.labelTitle.text = ""
            }
            if dictionaryVideo["created_at"] as? String == nil {
                cell.labelDate.text = self.convertDateToAppDate("")
            }else {
                cell.labelDate.text = self.convertDateToAppDate(dictionaryVideo["created_at"] as! String)
            }
            cell.imageViewCategory.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "social_login"))
            cell.imageViewVideo.sd_setImage(with: URL(string: imageVideoUrl), placeholderImage: UIImage(named: "social_login"))
            cell.ViewCategoryBg.layer.cornerRadius = 10.0
            cell.ViewCategoryBg.layer.masksToBounds = true
            cell.ViewCategoryBg.layerGradient(startPoint: .centerRight, endPoint: .centerLeft, colorArray: [UIColor.colorWithHexString("#02bf67").cgColor, UIColor.colorWithHexString("#E5F8EF").cgColor], type: .axial)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionViewPageMenu {
        
        let label = UILabel(frame: CGRect.zero)
        let dictionarySocialCommunity = self.arrayPageMenu[indexPath.row]
        label.text = dictionarySocialCommunity["categoryName"] as? String
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
            self.labelNoData.isHidden = true
            self.selectedPageMenu = indexPath.row
            self.categoryDetails = self.arrayPageMenu[selectedPageMenu]
            if self.categoryDetails["id"] as? Int != nil {
                let categoryID = self.categoryDetails["id"] as! Int
                self.webApiGetVideoListByCategory("\(categoryID)")
            }
            self.collectionViewPageMenu.reloadData()
        }else {
            let dictionaryVideo = self.arrayVideoList[indexPath.row]
            let videoDVC = VideoDetailsViewController.init(nibName: "VideoDetailsViewController", bundle: nil)
            videoDVC.videoDetails = dictionaryVideo
            self.navigationController?.pushViewController(videoDVC, animated: true)
        }
    }
    
    //    MARK:- Setup Collection View Cell
    func setupPageMenuCell(_ collectionView : UICollectionView, _ indexPath : IndexPath) -> PageMenuCollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.PAGE_MENU_CELL, for: indexPath) as! PageMenuCollectionViewCell
        let dictionarySocialCommunity = self.arrayPageMenu[indexPath.row]
        cell.labelMenuItem.text = dictionarySocialCommunity["categoryName"] as? String
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
//    func searchBarSearchButtonClicked(_ seachBar: UISearchBar) {
//        self.searchBar.resignFirstResponder()
//    }
    
//    MARK:- Web Code Start
//    Web Api for get Video list by category ID
    func webApiGetVideoListByCategory(_ categoryID : String) -> Void {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = WebApi.BASE_URL + "api/videolistbyCatId"
        print(url)
        let updatedUrl = url.replacingOccurrences(of: " ", with: "%20")
        let parameter = ["category_id" : categoryID]
        
        WebApi.webApiForPostRequestWithToken(updatedUrl, parameter) { (json : JSON) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if json.isEmpty {
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                if json["error"] == true {
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    self.setupCategoryList(json.dictionaryObject!)
                }
            }
        }
    }
    
    func setupCategoryList(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        if jsonDictionary["status_code"] as? Int != nil {
            if jsonDictionary["status_code"] as! Int == 401 {
                self.sessionExpiredMoveOnLoginPage()
                return
            }
        }
        self.arrayVideoList.removeAll()
        if jsonDictionary["status"] as? String != nil {
            if jsonDictionary["status"] as! String == ConstantStrings.SUCCESS_STATUS {
                if jsonDictionary["data"] as? Array<Dictionary<String, Any>> != nil {
                    self.arrayVideoList = jsonDictionary["data"] as! Array<Dictionary<String, Any>>
                    
                }
            }else {
                self.showToastWithMessage(self.view, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }
        }
        if self.arrayVideoList.count == 0 {
            self.labelNoData.isHidden = false
        }else {
            self.labelNoData.isHidden = true
        }
        self.collectionView.reloadData()
    }
}
