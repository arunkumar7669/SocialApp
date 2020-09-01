//
//  HomeTabBarViewController.swift
//  Social.Cable
//
//  Created by Arun Kumar Rathore on 03/08/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class HomeTabBarViewController: UITabBarController, UITabBarControllerDelegate {

    var middleView = UIView()
    private var middleButton = UIButton()
    
    var firstVC = HomeViewController()
    var secondVC = CategoryViewController()
    var thirdVC = LiveViewController()
    var fourthVC = ProfileViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupViewDidLoadMethod()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationImageOnTabbar("cable_logo")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationTitleImageView.removeFromSuperview()
    }
    
    func setupViewDidLoadMethod() -> Void {
        firstVC = HomeViewController.init(nibName: "HomeViewController", bundle: nil)
        secondVC = CategoryViewController.init(nibName: "CategoryViewController", bundle: nil)
        thirdVC = LiveViewController.init(nibName: "LiveViewController", bundle: nil)
        fourthVC = ProfileViewController.init(nibName: "ProfileViewController", bundle: nil)
        
        self.delegate = self
        firstVC.tabBarItem = UITabBarItem.init(title: "Home", image: UIImage.init(named: "home")!, tag: 0)
        secondVC.tabBarItem = UITabBarItem.init(title: "Category", image: UIImage.init(named: "category")!, tag: 1)
        thirdVC.tabBarItem = UITabBarItem.init(title: "Live", image: UIImage.init(named: "record")!, tag: 2)
        fourthVC.tabBarItem = UITabBarItem.init(title: "Profile", image: UIImage.init(named: "profile")!, tag: 3)
        
        self.viewControllers = [firstVC, secondVC, thirdVC, fourthVC]
        self.selectedIndex = 0
        self.tabBar.barTintColor = UIColor.colorWithHexString(ColorCode.navigationBar.rawValue)
        self.tabBar.isTranslucent = false
        
        UITabBar.appearance().unselectedItemTintColor = UIColor.lightGray
        UITabBar.appearance().tintColor = UIColor.white
        
        self.setupMiddleButton()
        
        let logo = UIImage(named: "cable_logo")
        let imageView = UIImageView(image:logo)
        self.tabBarController?.navigationItem.titleView = imageView
    }
    
    lazy var navigationTitleImageView = UIImageView()
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
    
    func setupMiddleButton() {
        
        self.middleView.frame.size = CGSize(width: 44, height: 44)
        self.middleView.backgroundColor = UIColor.colorWithHexString(ColorCode.navigationBar.rawValue)
        
        middleButton = UIButton.init(frame: CGRect.init(x: 4, y: 4, width: 36, height: 36))
        middleButton.setImage(UIImage.init(named: "video"), for: .normal)
        middleButton.backgroundColor = UIColor.colorWithHexString(ColorCode.buttonBackground.rawValue)
        middleButton.layer.cornerRadius = 18
        middleButton.layer.masksToBounds = true
//        middleButton.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: 0)
        
        self.middleView.layer.cornerRadius = 22
        self.middleView.layer.masksToBounds = true
        self.middleView.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: 0)
        self.middleView.addSubview(self.middleButton)
        
        middleButton.addTarget(self, action: #selector(videoButtonAction), for: .touchUpInside)
        self.tabBar.addSubview(self.middleView)
        
    }

    @objc func videoButtonAction() {
        
        let videoVC = VideoViewController.init(nibName: "VideoViewController", bundle: nil)
        self.navigationController?.pushViewController(videoVC, animated: true)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print(item.tag)
    }
}
