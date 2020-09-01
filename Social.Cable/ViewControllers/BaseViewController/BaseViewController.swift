//
//  BaseViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 01/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import Toast_Swift
import RPFloatingPlaceholders

class BaseViewController: UIViewController {

    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var gradientLayer: CAGradientLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        for hide the navigation bar border
//        For set the navigation title font
        if self.navigationController == nil {
            
            self.tabBarController?.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.tabBarController?.navigationController?.navigationBar.shadowImage = UIImage()
            self.tabBarController?.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular)]
            self.tabBarController?.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }else {
            
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular)]
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }
        self.changeStatusBarColor()
    }
    
//    Func setup TextField Attribute
    func setupTextFieldAttribute(_ textField : RPFloatingPlaceholderTextField, _ placeholder : String) -> Void {
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.floatingLabelActiveTextColor = .blue
        textField.floatingLabelInactiveTextColor = .lightGray
        textField.textColor = .white
    }
    
//    Setup Back Bar Button
    func setupBackBarButton() -> Void {
        
        let leftBarButton = UIBarButtonItem.init(image: UIImage.init(named: "back1")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(buttonBackBarAction(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
//    Back Bar Button Action
    @objc func buttonBackBarAction(_ sender : UIButton) -> Void {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func changeStatusBarColor() -> Void {
        if #available(iOS 13.0, *) {
           let app = UIApplication.shared
           let statusBarHeight: CGFloat = app.statusBarFrame.size.height

           let statusbarView = UIView()
            statusbarView.backgroundColor = UIColor.colorWithHexString(ColorCode.navigationBar.rawValue)
           view.addSubview(statusbarView)
           statusbarView.translatesAutoresizingMaskIntoConstraints = false
           statusbarView.heightAnchor
             .constraint(equalToConstant: statusBarHeight).isActive = true
           statusbarView.widthAnchor
             .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
           statusbarView.topAnchor
             .constraint(equalTo: view.topAnchor).isActive = true
           statusbarView.centerXAnchor
             .constraint(equalTo: view.centerXAnchor).isActive = true
        } else {
              let statusBar = UIApplication.shared.value(forKeyPath:
           "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = UIColor.colorWithHexString(ColorCode.navigationBar.rawValue)
        }
    }
    
    var navigationTitleImageView = UIImageView()
    func setupNavigationImage(_ imageName : String) -> Void {
        
        self.navigationTitleImageView.image = UIImage(named: imageName)!
        self.navigationTitleImageView.contentMode = .scaleAspectFit
        self.navigationTitleImageView.translatesAutoresizingMaskIntoConstraints = false

        if let navC = self.navigationController{
            navC.navigationBar.addSubview(self.navigationTitleImageView)
            self.navigationTitleImageView.centerXAnchor.constraint(equalTo: navC.navigationBar.centerXAnchor, constant: -20.0).isActive = true
            self.navigationTitleImageView.centerYAnchor.constraint(equalTo: navC.navigationBar.centerYAnchor, constant: 0).isActive = true
            self.navigationTitleImageView.widthAnchor.constraint(equalTo: navC.navigationBar.widthAnchor, multiplier: 0.5).isActive = true
            self.navigationTitleImageView.heightAnchor.constraint(equalTo: navC.navigationBar.widthAnchor, multiplier: 0.088).isActive = true
        }
    }
    
//    Func session expire and move on login page
    func sessionExpiredMoveOnLoginPage() -> Void {
        self.setupValuesBeforeLogout()
        let loginVC = LoginViewController.init(nibName: "LoginViewController", bundle: nil)
        loginVC.tokenExpireMessage = ConstantStrings.YOUR_TOKEN_HAS_BEEN_EXPIRED
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
//    Setup Navigation Bar Image on TabBar controller
    func setupNavigationImageOnTabbar(_ imageName : String) -> Void {
        
        self.navigationTitleImageView.image = UIImage(named: imageName)!
        self.navigationTitleImageView.contentMode = .scaleAspectFit
        self.navigationTitleImageView.translatesAutoresizingMaskIntoConstraints = false

        if let navC = self.tabBarController?.navigationController {
            navC.navigationBar.addSubview(self.navigationTitleImageView)
            self.navigationTitleImageView.centerXAnchor.constraint(equalTo: navC.navigationBar.centerXAnchor, constant: -20.0).isActive = true
            self.navigationTitleImageView.centerYAnchor.constraint(equalTo: navC.navigationBar.centerYAnchor, constant: 0).isActive = true
            self.navigationTitleImageView.widthAnchor.constraint(equalTo: navC.navigationBar.widthAnchor, multiplier: 0.5).isActive = true
            self.navigationTitleImageView.heightAnchor.constraint(equalTo: navC.navigationBar.widthAnchor, multiplier: 0.088).isActive = true
        }
    }
    
    func setupRightNavBarButton() -> Void {
        let recorder = UIBarButtonItem.init(image: UIImage.init(named: "notification_icon"), style: .done, target: self, action: #selector(buttonRecorderBarAction(_:)))

        let search = UIBarButtonItem.init(image: UIImage.init(named: "search")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(buttonSearchBarAction(_:)))
        self.navigationItem.rightBarButtonItems = [search, recorder]
//        self.navigationItem.rightBarButtonItems = [search]
    }
    
//    Search Bar Button Action
    @objc func buttonSearchBarAction(_ sender : UIButton) -> Void {
        print("Button search clicked...")
    }
    
//    Recorder Bar Button Action
    @objc func buttonRecorderBarAction(_ sender : UIButton) -> Void {
        print("Button Recorder clicked...")
    }
    
    func setupRightNavBarButtonOnTabBarController() -> Void {
            let recorder = UIBarButtonItem.init(image: UIImage.init(named: "notification_icon"), style: .done, target: self, action: #selector(buttonRecorderBarOnTabBarControllerAction(_:)))

            let search = UIBarButtonItem.init(image: UIImage.init(named: "search")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(buttonSearchBarOnTabBarControllerAction(_:)))
        self.tabBarController?.navigationItem.rightBarButtonItems = [search, recorder]
//        self.tabBarController?.navigationItem.rightBarButtonItems = [search]
        }
        
    //    Search Bar Button Action
        @objc func buttonSearchBarOnTabBarControllerAction(_ sender : UIButton) -> Void {
            print("Button search clicked...")
        }
        
    //    Recorder Bar Button Action
        @objc func buttonRecorderBarOnTabBarControllerAction(_ sender : UIButton) -> Void {
            print("Button Recorder clicked...")
            let createCVC = CreateChannelViewController.init(nibName: "CreateChannelViewController", bundle: nil)
            self.tabBarController?.navigationController?.pushViewController(createCVC, animated: true)
        }
    
//    Setup some values before logout
    func setupValuesBeforeLogout() -> Void {
        UserDefaultOperations.setBoolObject(ConstantStrings.IS_USER_LOGGED_IN, false)
        UserDefaultOperations.setStringObject(ConstantStrings.USER_FULL_NAME, "")
        UserDefaultOperations.setStringObject(ConstantStrings.USER_EMAIL_ID, "")
        UserDefaultOperations.setStringObject(ConstantStrings.USER_NAME, "")
        UserDefaultOperations.setStringObject(ConstantStrings.USER_ID, "")
        UserDefaultOperations.setStringObject(ConstantStrings.USER_IMAGE_URL, "")
        UserDefaultOperations.setStringObject(ConstantStrings.USER_MOBILE_NUMBER, "")
        UserDefaultOperations.setArrayObject(ConstantStrings.CONTINUE_PLAYING_VIDEO_LIST, Array<Dictionary<String, String>>())
    }
    
    //    Convert time 24 hours to AM/PM
    func convertTimeTo24Hours(_ time : String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from: time)
        
        dateFormatter.dateFormat = "h:mm a"
        let convertedTime = dateFormatter.string(from: date!)
        
        return convertedTime
    }
    
//    Convert Date to app Date
    func convertDateToAppDate(_ time : String) -> String {
        
        var convertedTime = String()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd HH:mm:ss"
        let date = dateFormatter.date(from: time)
        
        dateFormatter.dateFormat = "dd MMM, yyyy"
        if date == nil {
            convertedTime = dateFormatter.string(from: Date())
        }else {
            convertedTime = dateFormatter.string(from: date!)
        }
        
        return convertedTime
    }
            
    //    Setup Back Bar Button
    func setupDrawerButton() -> Void {
        
        let leftBarButton = UIBarButtonItem.init(image: UIImage.init(named: "menu")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(self.buttonDrawerAction(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @objc func buttonDrawerAction(_ sender : UIButton) -> Void {
        
        self.appDelegate.drawerController.setDrawerState(.opened, animated: true)
    }
    
//    Setup Drawer on tabbar controller
    func setupDrawerButtonOnTabBar() -> Void {
            
        let leftBarButton = UIBarButtonItem.init(image: UIImage.init(named: "menu")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(self.buttonTabBarDrawerAction(_:)))
        self.tabBarController?.navigationItem.leftBarButtonItem = leftBarButton
    }
        
    @objc func buttonTabBarDrawerAction(_ sender : UIButton) -> Void {
            
        self.appDelegate.drawerController.setDrawerState(.opened, animated: true)
    }
    
    //    MARK:- Show Alert With Message
    func showAlertWithMessage(_ title : String, _ message : String) {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction.init(title: ConstantStrings.OK_STRING, style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    //    MARK:- Show Alert With Message
    func showAlertWithPopupViewController(_ title : String, _ message : String) {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction.init(title: ConstantStrings.OK_STRING, style: .default) { (action) in
            
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
//    Show View toast
    func showToastWithMessage(_ view : UIView, _ message : String) -> Void {
        
        ToastManager.shared.style.backgroundColor = .white
        ToastManager.shared.style.messageColor = .black
        let windows = UIApplication.shared.windows
        windows.last?.hideAllToasts()
        windows.last?.makeToast(message)
    }
    
    //    Generate 6 digit random number for send otp
    func generate4DigitsRandomNumber(_ digitNumber: Int) -> String {
        
        var number = ""
        for i in 0..<digitNumber {
            var randomNumber = arc4random_uniform(10)
            while randomNumber == 0 && i == 0 {
                randomNumber = arc4random_uniform(10)
            }
            number += "\(randomNumber)"
        }
        return number
    }
    
//    Func change the selected string color
    func changeSelectedStringColor(_ string : String, _ subString : String, _ color : UIColor, _ fontSize : CGFloat) -> NSMutableAttributedString {
        
        let strNumber: NSString = string as NSString
        let range = (strNumber).range(of: subString)
        let attribute = NSMutableAttributedString.init(string: strNumber as String)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: color , range: range)
        attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: fontSize, weight: .regular), range: range)
        
        return attribute
    }
    
//    Setup Drawer Controller
    func setupDrawerController() -> Void {
        
        let homeVC = HomeTabBarViewController.init(nibName: "HomeTabBarViewController", bundle: nil)
        let mainViewController = UINavigationController.init(rootViewController: homeVC)
        mainViewController.viewWillAppear(true)
        
        let drawerVC = DrawerViewController.init(nibName: "DrawerViewController", bundle: nil)
        let drawerViewController = UINavigationController.init(rootViewController: drawerVC)
        
        if self.screenWidth == 320 {
            
            self.appDelegate.drawerController.drawerWidth = 250
        }else {
            
            self.appDelegate.drawerController.drawerWidth = 300
        }
        self.appDelegate.drawerController.screenEdgePanGestureEnabled = false
        self.appDelegate.drawerController.mainViewController = mainViewController
        self.appDelegate.drawerController.drawerViewController = drawerViewController
        self.appDelegate.window?.rootViewController = self.appDelegate.drawerController
        self.appDelegate.window?.makeKeyAndVisible()
    }
    
    func setupDrawerForiOSHigherVersion() -> Void {
        
        let homeVC = HomeTabBarViewController.init(nibName: "HomeTabBarViewController", bundle: nil)
        let mainViewController = UINavigationController.init(rootViewController: homeVC)
        mainViewController.viewWillAppear(true)
        
        let drawerVC = DrawerViewController.init(nibName: "DrawerViewController", bundle: nil)
        let drawerViewController = UINavigationController.init(rootViewController: drawerVC)
        
        if self.screenWidth == 320 {
            
            self.appDelegate.drawerController.drawerWidth = 250
        }else {
            
            self.appDelegate.drawerController.drawerWidth = 300
        }
        self.appDelegate.drawerController.screenEdgePanGestureEnabled = false
        self.appDelegate.drawerController.mainViewController = mainViewController
        self.appDelegate.drawerController.drawerViewController = drawerViewController
        
        let window = self.view.window
        window?.rootViewController = self.appDelegate.drawerController
        if #available(iOS 13.0, *) {
            SceneDelegate.shared?.window = window
        } else {
            // Fallback on earlier versions
            self.setupDrawerController()
        }
        window?.makeKeyAndVisible()
    }
    
    //    Setup Login Controller
    func setupLoginController() -> Void {
        
        let loginVC = LoginViewController.init(nibName: "LoginViewController", bundle: nil)
        let mainViewController = UINavigationController.init(rootViewController: loginVC)
        
        self.appDelegate.window?.rootViewController = mainViewController
        self.appDelegate.window?.makeKeyAndVisible()
    }
}

extension String {
    
    func trim() -> String {
        
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
