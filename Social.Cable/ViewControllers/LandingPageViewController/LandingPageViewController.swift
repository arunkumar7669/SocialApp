//
//  LandingPageViewController.swift
//  Social.Cable
//
//  Created by Arun Kumar Rathore on 29/07/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class LandingPageViewController: BaseViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var buttonCreateYourChannel: UIButton!
    @IBOutlet weak var buttonWatchIt: UIButton!
    
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
        self.contentView.backgroundColor = UIColor.colorWithHexString(ColorCode.appBackground.rawValue)
        self.buttonCreateYourChannel.backgroundColor = UIColor.colorWithHexString(ColorCode.buttonBackground.rawValue)
        self.buttonWatchIt.backgroundColor = UIColor.colorWithHexString(ColorCode.darkRed.rawValue)
        self.buttonWatchIt.layer.cornerRadius = self.buttonWatchIt.layer.bounds.height / 2
        self.buttonCreateYourChannel.layer.cornerRadius = self.buttonCreateYourChannel.layer.bounds.height / 2
    }
    
//    MARK:- Button Action
    @IBAction func buttonCreateChannelAction(_ sender: UIButton) {
        
        let createCVC = CreateChannelViewController.init(nibName: "CreateChannelViewController", bundle: nil)
        self.navigationController?.pushViewController(createCVC, animated: true)
    }
    
    @IBAction func buttonWatchItAction(_ sender: UIButton) {
        
        if #available(iOS 13.0, *) {
            self.setupDrawerForiOSHigherVersion()
        }else {
            self.setupDrawerController()
        }
    }
    
}
