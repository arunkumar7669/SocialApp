//
//  MySubscriptionViewController.swift
//  Social.Cable
//
//  Created by Arun Kumar Rathore on 11/08/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class MySubscriptionViewController: BaseViewController {

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
        
        self.setupBackBarButton()
        self.view.backgroundColor = UIColor.colorWithHexString(ColorCode.appBackground.rawValue)
    }
}
