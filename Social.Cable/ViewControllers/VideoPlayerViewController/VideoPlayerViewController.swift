//
//  VideoPlayerViewController.swift
//  Social.Cable
//
//  Created by Arun Kumar Rathore on 06/08/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import AVKit

class VideoPlayerViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupViewDidLoadMethod()
    }
    
    func setupViewDidLoadMethod() -> Void {
        
        self.setupBackBarButton()
    }
    
    @IBAction func playVideo(_ sender: UIButton) {
    }
}
