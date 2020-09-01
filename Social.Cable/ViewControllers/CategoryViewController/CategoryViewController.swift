//
//  CategoryViewController.swift
//  Social.Cable
//
//  Created by Arun Kumar Rathore on 03/08/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class CategoryViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var labelNoData: UILabel!
    
    let CELL_ID = "CategoryCell"
    var cellImageMargin : CGFloat = 15.0
    var arrayCategoryList = Array<Dictionary<String, Any>>()
    var datasource = Array<Dictionary<String, Any>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupViewDidLoadMethod()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
            if self.arrayCategoryList.count > 0 {
                self.collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
            }
        }
    }
    
    func setupViewDidLoadMethod() -> Void {
        
        self.view.backgroundColor = UIColor.colorWithHexString(ColorCode.appBackground.rawValue)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib.init(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: self.CELL_ID)
        self.collectionView.backgroundColor = .clear
        self.collectionView.frame = CGRect.init(x: self.collectionView.frame.origin.x, y: self.collectionView.frame.origin.y, width: self.screenWidth - self.cellImageMargin, height: self.collectionView.frame.height)
        self.collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 7.5, right: 0)
        self.labelNoData.isHidden = true
        let textFieldInsideSearchBar = self.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
        self.searchBar.searchBarBackgroundColor(color: UIColor.colorWithHexString(ColorCode.appBackground.rawValue))
        self.searchBar.barTintColor =  UIColor.colorWithHexString(ColorCode.appBackground.rawValue)
        self.searchBar.delegate = self
        self.searchBar.backgroundImage = UIImage()
        self.webApiHomePageData()
    }
    
//    UICollectionView Delegate and datasource Method
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.CELL_ID, for: indexPath) as! CategoryCollectionViewCell
        cell.contentView.backgroundColor = .clear
        
        let dictionarySocialCommunity = self.datasource[indexPath.row]
        cell.categoryName.text = dictionarySocialCommunity["categoryName"] as? String
        var imageUrl = String()
        if dictionarySocialCommunity["categoryPhoto"] as? String == nil {
            imageUrl = ""
        }else {
            imageUrl = dictionarySocialCommunity["categoryPhoto"] as! String
        }
        imageUrl = imageUrl.replacingOccurrences(of: " ", with: "%20")
        cell.categoryImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "social_login"))
        cell.categoryImage.backgroundColor = .black
        cell.categoryImage.layer.cornerRadius = 10.0
        cell.categoryImage.layer.masksToBounds = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: (self.screenWidth - self.cellImageMargin) / 2, height: (self.screenWidth - self.cellImageMargin) / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var indexNumber = Int()
        let selectedCategory = self.datasource[indexPath.row]
        for i in 0..<self.arrayCategoryList.count {
            let category = self.arrayCategoryList[i]
            if (category["id"] as! Int) == (selectedCategory["id"] as! Int) {
                indexNumber = i
                break
            }
        }
        self.view.endEditing(true)
        let videoListVC = VideoListViewController.init(nibName: "VideoListViewController", bundle: nil)
        videoListVC.selectedPageMenu = indexNumber
        videoListVC.arrayPageMenu = self.arrayCategoryList
        self.navigationController?.pushViewController(videoListVC, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
        print(searchBar.text!)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        self.datasource = self.arrayCategoryList.filter {
            return (($0["categoryName"] as! String).lowercased().contains(searchText.lowercased()))
        }
        if searchText.isEmpty {
            self.datasource = self.arrayCategoryList
        }
        if datasource.count == 0 {
            self.labelNoData.isHidden = false
        }else {
            self.labelNoData.isHidden = true
        }
        self.collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ seachBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
//    MARK:- Web Code Start
//    Web Api for get Category List
    func webApiHomePageData() -> Void {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = WebApi.BASE_URL + "api/category/list"
        print(url)
        let updatedUrl = url.replacingOccurrences(of: " ", with: "%20")
        
        WebApi.webApiForGetRequestWithToken(updatedUrl) { (json : JSON) in
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
        if jsonDictionary["Status"] as? String != nil {
            if jsonDictionary["Status"] as! String == ConstantStrings.SUCCESS_STATUS {
                if jsonDictionary["CategoyList"] as? Array<Dictionary<String, Any>> != nil {
                    self.arrayCategoryList = jsonDictionary["CategoyList"] as! Array<Dictionary<String, Any>>
                    self.datasource = self.arrayCategoryList
                    
                }
            }
        }
        if datasource.count == 0 {
            self.labelNoData.isHidden = false
        }else {
            self.labelNoData.isHidden = true
        }
        self.collectionView.reloadData()
    }
}

extension UISearchBar {

func searchBarBackgroundColor(color: UIColor){
    for view in self.subviews {
        for subview in view.subviews {
            if subview is UITextField {
                let textField: UITextField = subview as! UITextField
                textField.backgroundColor = color
            }
        }
    }
}
}
