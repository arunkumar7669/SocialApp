//
//  ProfileViewController.swift
//  Social.Cable
//
//  Created by Arun Kumar Rathore on 03/08/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {

    @IBOutlet weak var imageViewProfileBg: UIImageView!
    @IBOutlet weak var imageViewUSer: UIImageView!
    
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
        self.imageViewProfileBg.layer.cornerRadius = 5.0
        self.imageViewProfileBg.layer.masksToBounds = true
        UtilityMethods.changeImageColor(self.imageViewUSer, .lightGray)
    }
}
