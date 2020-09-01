//
//  SignupViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 01/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD
//import RPFloatingPlaceholders

class SignupViewController: BaseViewController {

    @IBOutlet weak var imageViewUser: UIImageView!
    @IBOutlet weak var viewImageBG: UIView!
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var imageViewName: UIImageView!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var viewUserName: UIView!
    @IBOutlet weak var imageViewUserName: UIImageView!
    @IBOutlet weak var textFieldUserName: UITextField!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var imageViewEmail: UIImageView!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var imageViewPassword: UIImageView!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var viewConfirmPassword: UIView!
    @IBOutlet weak var imageViewConfirmPassword: UIImageView!
    @IBOutlet weak var textFieldConfirmPassword: UITextField!
    @IBOutlet weak var buttonPremiumAccount: UIButton!
//    @IBOutlet weak var viewMobileNo: UIView!
//    @IBOutlet weak var textFieldMobileNo: UITextField!
//    @IBOutlet weak var imageViewMobile: UIImageView!
    
    @IBOutlet weak var buttonSignUp: UIButton!
    @IBOutlet weak var viewGoogleButton: UIView!
    @IBOutlet weak var imageViewGoogle: UIImageView!
    @IBOutlet weak var labelGoogle: UILabel!
    @IBOutlet weak var buttonGoogle: UIButton!
    
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
        
        self.view.backgroundColor = UIColor.colorWithHexString(ColorCode.appBackground.rawValue)
        self.imageViewUser.layer.cornerRadius = self.imageViewUser.layer.bounds.height / 2
        self.imageViewUser.layer.masksToBounds = true
        self.viewImageBG.addDashBorder(self.viewImageBG.layer.bounds.height / 2)
        self.viewImageBG.layer.cornerRadius = self.viewImageBG.layer.bounds.height / 2
        self.viewImageBG.backgroundColor = UIColor.colorWithHexString(ColorCode.viewBackground.rawValue)
        
        self.viewName.backgroundColor = UIColor.colorWithHexString(ColorCode.viewBackground.rawValue)
        self.viewUserName.backgroundColor = UIColor.colorWithHexString(ColorCode.viewBackground.rawValue)
        self.viewEmail.backgroundColor = UIColor.colorWithHexString(ColorCode.viewBackground.rawValue)
        self.viewPassword.backgroundColor = UIColor.colorWithHexString(ColorCode.viewBackground.rawValue)
        self.viewConfirmPassword.backgroundColor = UIColor.colorWithHexString(ColorCode.viewBackground.rawValue)
//        self.viewMobileNo.backgroundColor = UIColor.colorWithHexString(ColorCode.viewBackground.rawValue)
        self.buttonSignUp.backgroundColor = UIColor.colorWithHexString(ColorCode.buttonBackground.rawValue)
        
        UtilityMethods.changeImageColor(self.imageViewName, .white)
        UtilityMethods.changeImageColor(self.imageViewUserName, .white)
        UtilityMethods.changeImageColor(self.imageViewEmail, .white)
        UtilityMethods.changeImageColor(self.imageViewPassword, .white)
        UtilityMethods.changeImageColor(self.imageViewConfirmPassword, .white)
//        UtilityMethods.changeImageColor(self.imageViewMobile, .white)
        
        self.textFieldName.textColor = .white
        self.textFieldUserName.textColor = .white
        self.textFieldEmail.textColor = .white
        self.textFieldPassword.textColor = .white
        self.textFieldConfirmPassword.textColor = .white
//        self.textFieldMobileNo.textColor = .white
        
        self.viewName.layer.cornerRadius = self.viewName.layer.bounds.height / 2
        self.viewUserName.layer.cornerRadius = self.viewUserName.layer.bounds.height / 2
        self.viewEmail.layer.cornerRadius = self.viewEmail.layer.bounds.height / 2
//        self.viewMobileNo.layer.cornerRadius = self.viewMobileNo.layer.bounds.height / 2
        self.viewPassword.layer.cornerRadius = self.viewPassword.layer.bounds.height / 2
        self.viewConfirmPassword.layer.cornerRadius = self.viewConfirmPassword.layer.bounds.height / 2
        self.viewGoogleButton.layer.cornerRadius = self.viewGoogleButton.layer.bounds.height / 2
        self.buttonSignUp.layer.cornerRadius = self.buttonSignUp.layer.bounds.height / 2
        self.buttonGoogle.layer.cornerRadius = self.buttonGoogle.layer.bounds.height / 2
        
        self.textFieldName.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        self.textFieldUserName.attributedPlaceholder = NSAttributedString(string: "user Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        self.textFieldEmail.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        self.textFieldPassword.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        self.textFieldConfirmPassword.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
//        self.textFieldMobileNo.attributedPlaceholder = NSAttributedString(string: "Mobile No.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    
//    MARK:- Button Action
    @IBAction func buttonBackAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonPremiumAction(_ sender: UIButton) {
        
        
    }
    
    @IBAction func buttonSignUpAction(_ sender: UIButton) {
        
        self.webApiSignUpNewUser()
    }
    
    @IBAction func buttonGoogleLoginAction(_ sender: UIButton) {
        
        
    }
    
//    Check validation
    func checkValidation() -> Bool {
        
        self.view.endEditing(true)
        if self.textFieldUserName.text!.isEmpty {
            
            self.textFieldUserName.becomeFirstResponder()
            self.showToastWithMessage(self.view, ConstantStrings.USERNAME_FIELD_IS_REQUIRED)
            return false
        }
        
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
        
//        if self.textFieldMobileNo.text!.isEmpty {
//
//            self.textFieldMobileNo.becomeFirstResponder()
//            self.showToastWithMessage(self.view, ConstantStrings.MOBILE_NO_FIELD_IS_REQUIRED)
//            return false
//        }
//
//        if self.textFieldMobileNo.text!.count > 14 {
//
//            self.textFieldMobileNo.becomeFirstResponder()
//            self.showToastWithMessage(self.view, ConstantStrings.PLEASE_ENTER_VALID_MOBILE)
//            return false
//        }
//
        if self.textFieldPassword.text!.isEmpty {
            
            self.textFieldPassword.becomeFirstResponder()
            self.showToastWithMessage(self.view, ConstantStrings.PASSWORD_FIELD_IS_REQUIRED)
            return false
        }
        
        if self.textFieldConfirmPassword.text!.isEmpty {
                    
            self.textFieldConfirmPassword.becomeFirstResponder()
            self.showToastWithMessage(self.view, ConstantStrings.CONFIRM_PASSWORD_IS_REQUIRED)
            return false
        }
                
        if self.textFieldPassword.text! != self.textFieldConfirmPassword.text! {
            
            self.showToastWithMessage(self.view, ConstantStrings.BOTH_PASSWORD_SHOULD_BE_SAME)
            return false
        }
        
        return true
    }
    
//    MARK:- Web Api Code start
    func webApiSignUpNewUser() -> Void {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = WebApi.BASE_URL + "api/app-registration"
        print(url)
        let updatedUrl = url.replacingOccurrences(of: " ", with: "%20")
        let parameter = ["email": self.textFieldEmail.text!, "password" : self.textFieldPassword.text!, "customer_name" : self.textFieldName.text!, "customer_last_name" : self.textFieldName.text!, "customer_username" : self.textFieldUserName.text!]
        
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
                    if jsonDictionary["userInfo"] as? Dictionary<String, Any> != nil {
                        let userInfo = jsonDictionary["userInfo"] as! Dictionary<String, Any>
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
                if jsonDictionary["message"] as? Array<String> != nil {
                    let arrayMessage = jsonDictionary["message"] as! Array<String>
                    if arrayMessage.count > 0 {
                        self.showToastWithMessage(self.view, arrayMessage[0])
                    }
                }
            }
        }else {
            
            self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
        }
    }
}

extension UIView {
    func addDashBorder(_ radius : CGFloat) {
        let color = UIColor.white.cgColor

        let shapeLayer:CAShapeLayer = CAShapeLayer()

        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)

        shapeLayer.bounds = shapeRect
        shapeLayer.name = "DashBorder"
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = .round
        shapeLayer.lineDashPattern = [5,10]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: radius).cgPath

        self.layer.masksToBounds = false
        self.layer.addSublayer(shapeLayer)
    }
}
