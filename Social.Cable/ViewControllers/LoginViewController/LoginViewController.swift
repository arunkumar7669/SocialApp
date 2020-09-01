//
//  LoginViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 01/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD
//import RPFloatingPlaceholders

var firstTimeMessage = String()

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var imageViewSocial: UIImageView!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var imageViewEmail: UIImageView!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var imageViewPassword: UIImageView!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var buttonCreateAccount: UIButton!
    @IBOutlet weak var viewEmailHeight: NSLayoutConstraint!
    var tokenExpireMessage = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupViewDidLoadMethod()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func setupViewDidLoadMethod() -> Void {
        
        self.navigationItem.title = "Login"
        self.setupBackBarButton()
        self.view.backgroundColor = UIColor.colorWithHexString(ColorCode.appBackground.rawValue)
        UtilityMethods.changeImageColor(self.imageViewEmail, .white)
        UtilityMethods.changeImageColor(self.imageViewPassword, .white)
        self.viewEmailHeight.constant = ConstantStrings.COMMON_VIEW_HEIGHT
        self.buttonLogin.setTitleColor(.white, for: .normal)
        self.buttonLogin.setTitleColor(.white, for: .normal)
        self.buttonCreateAccount.setTitleColor(UIColor.white, for: .normal)
        self.buttonLogin.layer.cornerRadius = self.buttonLogin.layer.bounds.height / 2
        self.buttonCreateAccount.layer.cornerRadius = self.buttonLogin.layer.bounds.height / 2
        self.viewEmail.layer.cornerRadius = self.viewEmail.layer.bounds.height / 2
        self.viewPassword.layer.cornerRadius = self.viewPassword.layer.bounds.height / 2
        self.viewEmail.backgroundColor = UIColor.colorWithHexString(ColorCode.viewBackground.rawValue)
        self.viewPassword.backgroundColor = UIColor.colorWithHexString(ColorCode.viewBackground.rawValue)
        self.textFieldEmail.attributedPlaceholder = NSAttributedString(string: "USERNAME OR EMAIL", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        self.textFieldPassword.attributedPlaceholder = NSAttributedString(string: "PASSWORD", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        self.buttonLogin.backgroundColor = UIColor.colorWithHexString(ColorCode.buttonBackground.rawValue)
        self.textFieldEmail.textColor = .white
        self.textFieldPassword.textColor = .white
        if !tokenExpireMessage.isEmpty {
            self.showToastWithMessage(self.view, self.tokenExpireMessage)
            self.tokenExpireMessage = ""
        }
    }
    
//    MARK:- Button Action
//    Button Action For create Acount
    @IBAction func buttonCreateNewAccountAction(_ sender: UIButton) {
        
        let signUpVC = SignupViewController.init(nibName: "SignupViewController", bundle: nil)
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
//    Button Action For Login Existing User
    @IBAction func buttonLoginExistingUserAction(_ sender: UIButton) {
        
//        let landingPageVC = LandingPageViewController.init(nibName: "LandingPageViewController", bundle: nil)
//        self.navigationController?.pushViewController(landingPageVC, animated: true)
        if checkValidation() {
            self.webApiLoginExistingUser()
        }
    }
    
    //    Check validation
    func checkValidation() -> Bool {
        
        self.view.endEditing(true)
        if self.textFieldEmail.text!.isEmpty {
            
            self.textFieldEmail.becomeFirstResponder()
            self.showToastWithMessage(self.view, ConstantStrings.EMAIL_FIELD_IS_REQUIRED)
            return false
        }
        
        if !RegularExpression.validateEmail(self.textFieldEmail.text!) {
            
            self.textFieldEmail.becomeFirstResponder()
            self.showToastWithMessage(self.view, ConstantStrings.PLEASE_ENTER_VALID_EMAIL)
            return false
        }
        
        if self.textFieldPassword.text!.isEmpty {
            
            self.textFieldPassword.becomeFirstResponder()
            self.showToastWithMessage(self.view, ConstantStrings.PASSWORD_FIELD_IS_REQUIRED)
            return false
        }
        
        return true
    }
    
//    MARK:- Web Api Code start
//    Web Api for login existing user
    func webApiLoginExistingUser() -> Void {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = WebApi.BASE_URL + "api/app-login"
        print(url)
        let updatedUrl = url.replacingOccurrences(of: " ", with: "%20")
        let parameter = ["email": self.textFieldEmail.text!, "password" : self.textFieldPassword.text!, "customer_username" : self.textFieldEmail.text!, "device_type" : "iOS", "fcm_token" : "f_wx3pTrjpQ:APA91bHKAXJTJu9Z0ERqDF8roQ01Tcf9kjFGD8y8HhxaWh5QpOaqK_2okQQNp3N5Ee8o72lEx_f78TyRm58IXFQVF8YyxC4_JEPDum-"]
        
        WebApi.webApiForPostRequestWithoutToken(updatedUrl, parameter) { (json : JSON) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if json.isEmpty {
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                if json["error"] == true {
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    self.setupLoggedInUser(json.dictionaryObject!)
                }
            }
        }
    }
    
    func setupLoggedInUser(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        
        if jsonDictionary["status"] as? String != nil {
            if jsonDictionary["status"] as! String == ConstantStrings.SUCCESS_STATUS {
                if (jsonDictionary["message"] as? String != nil) && (jsonDictionary["token"] as? String != nil) {
                    firstTimeMessage = jsonDictionary["message"] as! String
                    UserDefaultOperations.setStringObject(ConstantStrings.AUTH_TOKEN, jsonDictionary["token"] as! String)
                    if jsonDictionary["data"] as? Dictionary<String, Any> != nil {
                        let userInfo = jsonDictionary["data"] as! Dictionary<String, Any>
                        let userID = (userInfo["id"] as? Int != nil) ? String(userInfo["id"] as! Int) : ""
                        let userName = (userInfo["customer_username"] as? String != nil) ? (userInfo["customer_username"] as! String) : ""
                        let fullName = (userInfo["customer_name"] as? String != nil) ? (userInfo["customer_name"] as! String) : ""
                        let userMobileNumber = (userInfo["customer_mobile_number"] as? String != nil) ? (userInfo["customer_mobile_number"] as! String) : ""
                        let userEmailID = (userInfo["customer_email"] as? String != nil) ? (userInfo["customer_email"] as! String) : ""
                        let userImageURL = (userInfo["customer_profile_pic"] as? String != nil) ? (userInfo["customer_profile_pic"] as! String) : ""
                        if !userID.isEmpty {
                            UserDefaultOperations.setStringObject(ConstantStrings.USER_ID, userID)
                            UserDefaultOperations.setStringObject(ConstantStrings.USER_NAME, userName)
                            UserDefaultOperations.setStringObject(ConstantStrings.USER_FULL_NAME, fullName)
                            UserDefaultOperations.setStringObject(ConstantStrings.USER_MOBILE_NUMBER, userMobileNumber)
                            UserDefaultOperations.setStringObject(ConstantStrings.USER_EMAIL_ID, userEmailID)
                            UserDefaultOperations.setStringObject(ConstantStrings.USER_IMAGE_URL, userImageURL)
                            UserDefaultOperations.setBoolObject(ConstantStrings.IS_USER_LOGGED_IN, true)
                            
                            let landingPageVC = LandingPageViewController.init(nibName: "LandingPageViewController", bundle: nil)
                            self.navigationController?.pushViewController(landingPageVC, animated: true)
                        }
                    }
                }
            }else {
                if jsonDictionary["message"] as? String != nil {
                    self.showToastWithMessage(self.view, jsonDictionary["message"] as! String)
                }
            }
        }else {
            
            self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
        }
    }
}
