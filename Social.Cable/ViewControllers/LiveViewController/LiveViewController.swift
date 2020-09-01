//
//  LiveViewController.swift
//  Social.Cable
//
//  Created by Arun Kumar Rathore on 15/08/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class LiveViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupViewDidLoadMethod()
    }
    
    func setupViewDidLoadMethod() -> Void {
        
        self.view.backgroundColor = UIColor.colorWithHexString(ColorCode.appBackground.rawValue)
    }
}
