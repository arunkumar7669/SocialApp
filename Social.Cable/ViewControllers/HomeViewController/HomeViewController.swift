//
//  HomeViewController.swift
//  Social.Cable
//
//  Created by Arun Kumar Rathore on 29/07/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD
import SDWebImage

class HomeViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var heightCollectionView: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    @IBOutlet weak var viewContinueWatch: UIView!
    @IBOutlet weak var heightContinueWatch: NSLayoutConstraint!
    @IBOutlet weak var labelContinueWatch: UILabel!
    
    let VIDEO_LIST_CELL = "VideoListCell"
    let CELL_ID = "ContinueWatchCell"
    let SOCIAL_CELL_ID = "CommunityCell"
    var arrayHomeData = Array<Array<Dictionary<String, Any>>>()
    var arrayDataType = Array<Int>()
    var arrayContinuePlaying = Array<Dictionary<String, Any>>()
    
    let FREE_VIDEOS_LIST = 1
    let PREMIUM_VIDEOS_LIST = 2
    let SOCIAL_COMMUNITY_LIST = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupViewDidLoadMethod()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.arrayContinuePlaying = UserDefaultOperations.getArrayObject(ConstantStrings.CONTINUE_PLAYING_VIDEO_LIST) as! Array<Dictionary<String, Any>>
        if self.arrayContinuePlaying.count > 0 {
            self.labelContinueWatch.isHidden = false
            self.heightContinueWatch.constant = 131
            self.viewContinueWatch.isHidden = false
            self.collectionView.isHidden = false
            self.collectionView.reloadData()
        }else {
            self.labelContinueWatch.isHidden = true
            self.heightContinueWatch.constant = 0.5
            self.viewContinueWatch.isHidden = true
            self.collectionView.isHidden = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        let height = self.tableView.contentSize.height
        self.heightTableView.constant = height
        self.view.layoutIfNeeded()
    }
    
    func setupViewDidLoadMethod() -> Void {
        self.setupDrawerButtonOnTabBar()
        self.setupRightNavBarButtonOnTabBarController()
        self.view.backgroundColor = UIColor.colorWithHexString(ColorCode.appBackground.rawValue)
        self.collectionView.backgroundColor = .clear
        self.collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 15)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib.init(nibName: "ContinueWatchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: self.CELL_ID)
        self.setupTableViewDelegateAndDatasource()
        
        let image = UIImage(named: "cable_logo")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        self.tabBarController?.navigationItem.titleView = imageView
        self.webApiHomePageData()
    }
    
//    Setup TableView delegate and data source
    func setupTableViewDelegateAndDatasource() -> Void {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 40.0
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .clear
    }
        
//    UICollectionView Delegate and datasource Method
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return self.arrayContinuePlaying.count
        }else {
            return self.arrayHomeData[collectionView.tag].count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.CELL_ID, for: indexPath) as! ContinueWatchCollectionViewCell
//            cell.imageViewContinueWatch.image = UIImage.init(named: self.arrayContinueWatch[indexPath.row])
            let dictionarySocialCommunity = self.arrayContinuePlaying[indexPath.row]
            var imageUrl = String()
            if dictionarySocialCommunity["movie_thumbnail"] as? String == nil {
                imageUrl = ""
            }else {
                imageUrl = dictionarySocialCommunity["movie_thumbnail"] as! String
            }
            imageUrl = imageUrl.replacingOccurrences(of: " ", with: "%20")
            cell.imageViewContinueWatch.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "social_login"))
            return cell
        }else {
            if (collectionView.tag + 1) == self.SOCIAL_COMMUNITY_LIST {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.SOCIAL_CELL_ID, for: indexPath) as! SocialCommunityCollectionViewCell
                cell.contentView.backgroundColor = .clear
                let arraySocialCommunity = self.arrayHomeData[collectionView.tag]
                let dictionarySocialCommunity = arraySocialCommunity[indexPath.row]
                var imageUrl = String()
                if dictionarySocialCommunity["channel_logo_image_url"] as? String == nil {
                    imageUrl = ""
                }else {
                    imageUrl = dictionarySocialCommunity["channel_logo_image_url"] as! String
                }
                imageUrl = imageUrl.replacingOccurrences(of: " ", with: "%20")
                cell.imageViewCommunity.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "social_login"))
                cell.labelCommunityName.text = dictionarySocialCommunity["channel_name"] as? String
                cell.viewBg.layer.cornerRadius = 10.0
                cell.viewBg.layer.masksToBounds = true
                cell.viewBg.layerGradient(startPoint: .centerRight, endPoint: .centerLeft, colorArray: [UIColor.colorWithHexString("#02bf67").cgColor, UIColor.colorWithHexString("#E5F8EF").cgColor], type: .axial)
                return cell
            }else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.VIDEO_LIST_CELL, for: indexPath) as! VideoListCollectionViewCell
                let arraySocialCommunity = self.arrayHomeData[collectionView.tag]
                let dictionarySocialCommunity = arraySocialCommunity[indexPath.row]
                var imageUrl = String()
                if dictionarySocialCommunity["movie_poster"] as? String == nil {
                    imageUrl = ""
                }else {
                    imageUrl = dictionarySocialCommunity["movie_poster"] as! String
                }
                imageUrl = imageUrl.replacingOccurrences(of: " ", with: "%20")
                cell.imageViewVideo.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "social_login"))
                cell.contentView.backgroundColor = .clear
                cell.imageViewVideo.layer.cornerRadius = 10.0
                cell.imageViewVideo.layer.masksToBounds = true
                cell.labelStar.text = dictionarySocialCommunity["total_views"] as? String
                if cell.labelStar.text!.isEmpty {
                    cell.labelStar.isHidden = true
                    cell.imageViewStar.isHidden = true
                }else {
                    cell.labelStar.isHidden = false
                    cell.imageViewStar.isHidden = false
                }
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.collectionView {
            return CGSize.init(width: (self.screenWidth - 60) / 3, height: 60.0)
        }else {
            if (collectionView.tag + 1) == self.SOCIAL_COMMUNITY_LIST {
                return CGSize.init(width: 100.0, height: 100.0)
            }else {
                return CGSize.init(width: 100.0, height: 140.0)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            let videoDVC = VideoDetailsViewController.init(nibName: "VideoDetailsViewController", bundle: nil)
            videoDVC.videoDetails = self.arrayContinuePlaying[indexPath.row]
            self.navigationController?.pushViewController(videoDVC, animated: true)
        }else {
            if (collectionView.tag + 1) == self.SOCIAL_COMMUNITY_LIST {
                let channelVC = ChannelViewController.init(nibName: "ChannelViewController", bundle: nil)
                self.navigationController?.pushViewController(channelVC, animated: true)
            }else {
                let arraySocialCommunity = self.arrayHomeData[collectionView.tag]
                let videoDVC = VideoDetailsViewController.init(nibName: "VideoDetailsViewController", bundle: nil)
                videoDVC.videoDetails = arraySocialCommunity[indexPath.row]
                self.navigationController?.pushViewController(videoDVC, animated: true)
            }
        }
    }
    
//    MARK:- UITableView Delegate And Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.arrayHomeData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section + 1) == self.SOCIAL_COMMUNITY_LIST {
            return 110.0
        }else {
            return 160.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("SocialTableViewCell", owner: self, options: nil)?.first as! SocialTableViewCell
        cell.selectionStyle = .none
        cell.collectionViewSocial.tag = indexPath.section
        cell.collectionViewSocial.backgroundColor = .clear
        cell.collectionViewSocial.delegate = self
        cell.collectionViewSocial.dataSource = self
        cell.collectionViewSocial.register(UINib.init(nibName: "VideoListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: self.VIDEO_LIST_CELL)
        cell.collectionViewSocial.register(UINib.init(nibName: "SocialCommunityCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: self.SOCIAL_CELL_ID)
        if (indexPath.section%2 != 0) {
            cell.collectionViewSocial.contentInset = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 15)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! SocialTableViewCell
        cell.collectionViewSocial.reloadData()
        cell.collectionViewSocial.contentOffset = .zero
    }
    
//    MARK:- Web Api Code start
//    Web Api for get home page data
    func webApiHomePageData() -> Void {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = WebApi.BASE_URL + "api/home/page"
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
                    self.setupHomePageDataList(json.dictionaryObject!)
                }
            }
        }
    }
    
    func setupHomePageDataList(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        if jsonDictionary["status_code"] as? Int != nil {
            if jsonDictionary["status_code"] as! Int == 401 {
                self.sessionExpiredMoveOnLoginPage()
                return
            }
        }
        if jsonDictionary["status_code"] as? Int != nil {
            if jsonDictionary["status_code"] as! Int == 401 {
                self.sessionExpiredMoveOnLoginPage()
                return
            }
        }
        if jsonDictionary["Status"] as? String != nil {
            if jsonDictionary["Status"] as! String == ConstantStrings.SUCCESS_STATUS {
                self.arrayHomeData.removeAll()
                if jsonDictionary["PremiumVideoList"] as? Array<Dictionary<String, Any>> != nil {
                    let arrayFreeVideoList = jsonDictionary["PremiumVideoList"] as! Array<Dictionary<String, Any>>
                    self.arrayHomeData.append(arrayFreeVideoList)
                    self.arrayDataType.append(self.PREMIUM_VIDEOS_LIST)
                }
                if jsonDictionary["FreeVideoList"] as? Array<Dictionary<String, Any>> != nil {
                    let arrayFreeVideoList = jsonDictionary["FreeVideoList"] as! Array<Dictionary<String, Any>>
                    self.arrayHomeData.append(arrayFreeVideoList)
                    self.arrayDataType.append(self.FREE_VIDEOS_LIST)
                }
                if jsonDictionary["SocialCommunityUsers"] as? Array<Dictionary<String, Any>> != nil {
                    let arrayFreeVideoList = jsonDictionary["SocialCommunityUsers"] as! Array<Dictionary<String, Any>>
                    self.arrayHomeData.append(arrayFreeVideoList)
                    self.arrayDataType.append(self.SOCIAL_COMMUNITY_LIST)
                }
            }
        }
        self.tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.view.setNeedsLayout()
        }
    }
}
