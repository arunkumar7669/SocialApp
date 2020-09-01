//
//  DrawerViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 03/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class DrawerViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var imageViewUser: UIImageView!
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelPhone: UILabel!
    
    var arrayMenuName = ["Home", "SubscriptionS", "My Profile", "My Channel", "Notification", "Logout"]
    var arrayMenuImage = ["home1", "my_subscription", "my_profile", "my_channel", "my_notification", "logout"]
    
//    For Guest user
    let HOME_PAGE = 0
    let MY_SUBSCRIPTION_PAGE = 1
    let MY_PROFILE_PAGE = 2
    let MY_CHANNEL_PAGE = 3
    let MY_NOTIFICATION_PAGE = 4
    let LOGOUT = 5
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupViewDidLoadMethod()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.labelPhone.text = UserDefaultOperations.getStringObject(ConstantStrings.USER_EMAIL_ID)
        self.labelUserName.text = UserDefaultOperations.getStringObject(ConstantStrings.USER_FULL_NAME)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func setupViewDidLoadMethod() -> Void {
        
        self.setupTableViewDelegateAndDatasource()
        self.view.backgroundColor = UIColor.colorWithHexString(ColorCode.appBackground.rawValue)
        UtilityMethods.changeImageColor(self.imageViewUser, .white)
        self.labelUserName.textColor = .white
        self.labelPhone.textColor = .white
    }
    
    //    Setup tableView Delegate And datasource
    func setupTableViewDelegateAndDatasource() -> Void {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 40
    }
    
    //    MARK:- UITableView Delegate And Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrayMenuName.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("DrawerTableViewCell", owner: self, options: nil)?.first as! DrawerTableViewCell
        cell.selectionStyle = .none
        cell.labelMenu.text = self.arrayMenuName[indexPath.row]
        if indexPath.row > (self.arrayMenuImage.count - 1) {
            cell.imageViewMenu.image = UIImage.init(named: "home")
        }else {
            cell.imageViewMenu.image = UIImage.init(named: self.arrayMenuImage[indexPath.row])
        }
//        UtilityMethods.changeImageColor(cell.imageViewMenu, .darkGray)
        cell.labelMenu.textColor = .white
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if UserDefaultOperations.getBoolObject(ConstantStrings.IS_USER_LOGGED_IN) {

            switch indexPath.row {

            case self.HOME_PAGE:
                self.moveOnHomePage()
                break

            case self.MY_SUBSCRIPTION_PAGE:
                self.appDelegate.drawerController.setDrawerState(.closed, animated: true)
                self.moveOnMySubscriptionPage()
                break

            case self.MY_PROFILE_PAGE:
                self.moveOnMyProfilePage()
                break

            case self.MY_CHANNEL_PAGE:
                self.moveOnMyChannelPage()
                break

//            case self.MY_INTRO_PAGE:
//                self.moveOnMyIntro()
//                break

            case self.MY_NOTIFICATION_PAGE:
                self.moveOnMyNotificationPage()
                break
                
            case self.LOGOUT:
                self.appDelegate.drawerController.setDrawerState(.closed, animated: true)
                self.setupLogoutPage()
                break

            default:
                self.appDelegate.drawerController.setDrawerState(.closed, animated: true)
            }
        }
    }
    
    //    MARK:- Setup Drawer Section
//    Move on Home Page
    func moveOnHomePage() -> Void {
        if #available(iOS 13.0, *) {
            self.setupDrawerForiOSHigherVersion()
        }else {
            self.setupDrawerController()
        }
    }
    
//    Move on My Subscription
    func moveOnMySubscriptionPage() -> Void {

        let mainVC = MySubscriptionViewController.init(nibName: "MySubscriptionViewController", bundle: nil)
        self.setupMainViewController(mainVC)
    }

//    Move on My Profile Page
    func moveOnMyProfilePage() -> Void {

        let mainVC = ProfileViewController.init(nibName: "ProfileViewController", bundle: nil)
        self.setupMainViewController(mainVC)
    }

//    Move on My Channel
    func moveOnMyChannelPage() -> Void {

        let mainVC = MyChannelViewController.init(nibName: "MyChannelViewController", bundle: nil)
        self.setupMainViewController(mainVC)
    }

//    Move on My Intro
    func moveOnMyIntro() -> Void {

        let mainVC = MyIntroViewController.init(nibName: "MyIntroViewController", bundle: nil)
        self.setupMainViewController(mainVC)
    }

//    Move on My Notification
    func moveOnMyNotificationPage() -> Void {

        let offerVC = MyNotificationViewController.init(nibName: "MyNotificationViewController", bundle: nil)
        self.setupMainViewController(offerVC)
    }
    
//    Setup MainViewController
    func setupMainViewController(_ viewController : UIViewController) -> Void {
        
        let navigationController = self.appDelegate.drawerController.mainViewController as! UINavigationController
        let dashboardVC = navigationController.viewControllers.first as! HomeTabBarViewController
        dashboardVC.navigationController?.setNavigationBarHidden(false, animated: false)
        dashboardVC.navigationController?.pushViewController(viewController, animated: false)
        self.appDelegate.drawerController.setDrawerState(.closed, animated: true)
    }
    
    //    MARK:- Button Action
    @IBAction func buttonGotoProfilePageAction(_ sender: UIButton) {
        
        if UserDefaultOperations.getBoolObject(ConstantStrings.IS_USER_LOGGED_IN) {
            
//            let profileVC = MyProfileViewController.init(nibName: "MyProfileViewController", bundle: nil)
//            self.setupMainViewController(profileVC)
        }
    }
    
//    Setup logout page
    func setupLogoutPage() -> Void {
        let alrtctrl = UIAlertController.init(title: ConstantStrings.ALERT, message: ConstantStrings.ARE_YOU_SURE_YOU_WANT_TO_LOGOUT, preferredStyle: .alert)
        let actionOK = UIAlertAction.init(title: ConstantStrings.OK_STRING, style: .default) { (alert) in
            self.setupValuesBeforeLogout()
            self.setupLoginController()
        }
        
        let actionCancel = UIAlertAction.init(title: ConstantStrings.CANCEL_STRING, style: .default, handler: nil)
        alrtctrl.addAction(actionOK)
        alrtctrl.addAction(actionCancel)
        self.present(alrtctrl, animated: true, completion: nil)
    }
}


extension UITableView {
    
    func scrollToBottom(){
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                section: self.numberOfSections - 1)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }
    
    func scrollToTop() {
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        }
    }
    
    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
}
