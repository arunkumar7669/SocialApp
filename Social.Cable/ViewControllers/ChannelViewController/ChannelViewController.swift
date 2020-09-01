//
//  ChannelViewController.swift
//  Social.Cable
//
//  Created by Arun Kumar Rathore on 15/08/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class ChannelViewController: BaseViewController {

    @IBOutlet weak var segmentChannel: UISegmentedControl!
    @IBOutlet weak var labelNoDataFound: UILabel!
    
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
        self.setupRightNavBarButton()
        self.view.backgroundColor = UIColor.colorWithHexString(ColorCode.appBackground.rawValue)
        if #available(iOS 13.0, *) {
            self.segmentChannel.selectedSegmentTintColor = UIColor.colorWithHexString(ColorCode.buttonBackground.rawValue)
        } else {
            self.segmentChannel.tintColor = UIColor.colorWithHexString(ColorCode.buttonBackground.rawValue)
        }
        let segAttributes: NSDictionary = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.segmentChannel.setTitleTextAttributes(segAttributes as [NSObject : AnyObject] as? [NSAttributedString.Key : Any], for: UIControl.State.selected)
    }
}
