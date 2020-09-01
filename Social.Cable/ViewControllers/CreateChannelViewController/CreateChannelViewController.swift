//
//  CreateChannelViewController.swift
//  Social.Cable
//
//  Created by Arun Kumar Rathore on 29/07/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD
import RPFloatingPlaceholders

class CreateChannelViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

//    @IBOutlet weak var textFieldUserName: RPFloatingPlaceholderTextField!
    @IBOutlet weak var textFieldChannelName: RPFloatingPlaceholderTextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var heightCollectionView: NSLayoutConstraint!
    @IBOutlet weak var buttonSaveAndUpdate: UIButton!
    @IBOutlet weak var imageViewChannel: UIImageView!
    
    let CELL_ID = "ChannelCell"
    var selectedChannelID = -1
    var selectedIndex = Int()
    var channelDetails = Dictionary<String, Any>()
    var arrayChannelTypeList = Array<Dictionary<String, Any>>()
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
//        self.setupDrawerButton()
        self.setupBackBarButton()
        self.view.backgroundColor = UIColor.colorWithHexString(ColorCode.appBackground.rawValue)
//        self.setupTextFieldAttribute(self.textFieldUserName, "User Name")
        self.setupTextFieldAttribute(self.textFieldChannelName, "Channel Name")
        self.setupRightNavBarButton()
        self.collectionView.frame = CGRect.init(x: self.collectionView.frame.origin.x, y: self.collectionView.frame.origin.y, width: self.screenWidth - 30, height: self.collectionView.frame.height)
        self.buttonSaveAndUpdate.backgroundColor = UIColor.colorWithHexString(ColorCode.buttonBackground.rawValue)
        self.buttonSaveAndUpdate.layer.cornerRadius = self.buttonSaveAndUpdate.bounds.height / 2
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib.init(nibName: "ChannelCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: self.CELL_ID)
        if !firstTimeMessage.isEmpty {
            self.showToastWithMessage(self.view, firstTimeMessage)
            firstTimeMessage = ""
        }
//        if !UserDefaultOperations.getStringObject(ConstantStrings.USER_NAME).isEmpty {
//            self.textFieldUserName.text = UserDefaultOperations.getStringObject(ConstantStrings.USER_NAME)
//            self.textFieldUserName.isUserInteractionEnabled = false
//        }
        self.webApiCheckChannelAlreadyCreated()
        self.webApiGetChannelTypeList()
    }
    
//    UICollectionView Delegate and datasource Method
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayChannelTypeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.CELL_ID, for: indexPath) as! ChannelCollectionViewCell
        
        let dictionaryChannelType = self.arrayChannelTypeList[indexPath.row]
        var imageUrl = String()
        if dictionaryChannelType["channel_logo_image"] as? String == nil {
            imageUrl = ""
        }else {
            imageUrl = dictionaryChannelType["channel_logo_image"] as! String
        }
        imageUrl = imageUrl.replacingOccurrences(of: " ", with: "%20")
        cell.imageViewChannel.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "social_login"))
        var channelID = Int()
        if (dictionaryChannelType["id"] as? Int != nil) {
            channelID = dictionaryChannelType["id"] as! Int
        }
        if channelID == self.selectedChannelID {
            cell.viewBg.layer.cornerRadius = 5.0
            cell.viewBg.layer.borderWidth = 2.0
            cell.viewBg.layer.borderColor = UIColor.white.cgColor
            self.selectedIndex = indexPath.row
        }else {
            cell.viewBg.layer.cornerRadius = 5.0
            cell.viewBg.layer.borderWidth = 0.0
            cell.viewBg.layer.borderColor = UIColor.clear.cgColor
        }
        cell.viewBg.layer.cornerRadius = 5.0
        cell.viewBg.layer.masksToBounds = true
//        cell.viewBg.layerGradient(startPoint: .centerRight, endPoint: .centerLeft, colorArray: [UIColor.colorWithHexString("#02bf67").cgColor, UIColor.colorWithHexString("#E5F8EF").cgColor], type: .axial)
        cell.viewBg.backgroundColor = UIColor.colorWithHexString(ColorCode.navigationBar.rawValue)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (self.screenWidth - 90) / 2, height: 80.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dictionaryChannelType = self.arrayChannelTypeList[indexPath.row]
        if (dictionaryChannelType["id"] as? Int != nil) {
            self.selectedChannelID = dictionaryChannelType["id"] as! Int
            var imageUrl = String()
            if dictionaryChannelType["channel_logo_image"] as? String == nil {
                imageUrl = ""
            }else {
                imageUrl = dictionaryChannelType["channel_logo_image"] as! String
            }
            imageUrl = imageUrl.replacingOccurrences(of: " ", with: "%20")
            self.imageViewChannel.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "social_login"))
        }
        self.collectionView.reloadData()
    }
    
//    MARK:- Button Action
    @IBAction func buttonEditAction(_ sender: UIButton) {
        self.textFieldChannelName.becomeFirstResponder()
    }
    
    @IBAction func buttonSaveAndUpdateAction(_ sender: UIButton) {
        if checkValidation() {
            self.webApiCreateNewChannel()
        }
    }
    
    func checkValidation() -> Bool {
        self.view.endEditing(true)
//        if self.textFieldUserName.text!.isEmpty {
//            self.textFieldUserName.becomeFirstResponder()
//            self.showToastWithMessage(self.view, ConstantStrings.USERNAME_FIELD_IS_REQUIRED)
//            return false
//        }
        if self.textFieldChannelName.text!.isEmpty {
            self.textFieldChannelName.becomeFirstResponder()
            self.showToastWithMessage(self.view, ConstantStrings.CHANNEL_NAME_FIELD_IS_REQUIRED)
            return false
        }
        if self.selectedChannelID < 0 {
            self.showToastWithMessage(self.view, ConstantStrings.PLEASE_SELECT_CHANNEL_TYPE)
            return false
        }
        return true
    }
    
//    MARK:- Web Code Start
//    Web Api for Get channel Type list
    func webApiGetChannelTypeList() -> Void {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = WebApi.BASE_URL + "api/channeLogolList"
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
        if jsonDictionary["status"] as? String != nil {
            if jsonDictionary["status"] as! String == ConstantStrings.SUCCESS_STATUS {
                if jsonDictionary["data"] as? Array<Dictionary<String, Any>> != nil {
                    self.arrayChannelTypeList = jsonDictionary["data"] as! Array<Dictionary<String, Any>>
                }
            }
        }
        self.collectionView.reloadData()
    }
    
    //    Web Api for login existing user
    func webApiCheckChannelAlreadyCreated() -> Void {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = WebApi.BASE_URL + "api/channelList"
        print(url)
        let updatedUrl = url.replacingOccurrences(of: " ", with: "%20")
        let parameter = ["customer_id" : UserDefaultOperations.getStringObject(ConstantStrings.USER_ID)]
        
        WebApi.webApiForPostRequestWithToken(updatedUrl, parameter) { (json : JSON) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if json.isEmpty {
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                if json["error"] == true {
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    self.setupChannelDetails(json.dictionaryObject!)
                }
            }
        }
    }
    
    func setupChannelDetails(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        if jsonDictionary["status_code"] as? Int != nil {
            if jsonDictionary["status_code"] as! Int == 401 {
                self.sessionExpiredMoveOnLoginPage()
                return
            }
        }
        if jsonDictionary["status"] as? String != nil {
            if jsonDictionary["status"] as! String == ConstantStrings.SUCCESS_STATUS {
                if jsonDictionary["data"] as? Dictionary<String, Any> != nil {
                    self.channelDetails = jsonDictionary["data"] as! Dictionary<String, Any>
                    self.textFieldChannelName.text = (self.channelDetails["channel_name"] as? String != nil) ? (self.channelDetails["channel_name"] as! String) : ""
                    self.selectedChannelID = (self.channelDetails["channel_logo_id"] as? Int != nil) ? (self.channelDetails["channel_logo_id"] as! Int) : -1
                    var imageUrl = String()
                    if self.channelDetails["channel_logo_image_url"] as? String == nil {
                        imageUrl = ""
                    }else {
                        imageUrl = self.channelDetails["channel_logo_image_url"] as! String
                    }
                    imageUrl = imageUrl.replacingOccurrences(of: " ", with: "%20")
                    self.imageViewChannel.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "social_login"))
                }else {
                    self.imageViewChannel.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "social_login"))
                }
            }
        }
        self.collectionView.reloadData()
    }
    
//    Web Api Create New Channel Or update the channel
    func webApiCreateNewChannel() -> Void {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = WebApi.BASE_URL + "api/addChannel"
        print(url)
        let username = UserDefaultOperations.getStringObject(ConstantStrings.USER_NAME)
        let updatedUrl = url.replacingOccurrences(of: " ", with: "%20")
        let parameter = ["customer_id" : UserDefaultOperations.getStringObject(ConstantStrings.USER_ID), "channel_name" : self.textFieldChannelName.text!, "channel_category" : String(self.selectedChannelID), "channel_description" : "new channel", "customer_username" : username, "channel_logo_id": String(self.selectedChannelID)]
        
        WebApi.webApiForPostRequestWithToken(updatedUrl, parameter) { (json : JSON) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if json.isEmpty {
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                if json["error"] == true {
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    self.setupAddChannelDetails(json.dictionaryObject!)
                }
            }
        }
    }
    
    func setupAddChannelDetails(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        if jsonDictionary["status_code"] as? Int != nil {
            if jsonDictionary["status_code"] as! Int == 401 {
                self.sessionExpiredMoveOnLoginPage()
                return
            }
        }
        if jsonDictionary["status"] as? String != nil {
            if jsonDictionary["status"] as! String == ConstantStrings.SUCCESS_STATUS {
                if jsonDictionary["Message"] as? String != nil {
                    self.showToastWithMessage(self.view, jsonDictionary["Message"] as! String)
                }
            }else {
                if jsonDictionary["message"] as? Array<String> != nil {
                    let arrayMessage = jsonDictionary["message"] as! Array<String>
                    if arrayMessage.count > 0 {
                        self.showToastWithMessage(self.view, arrayMessage[0])
                    }
                }
            }
        }
    }
}
