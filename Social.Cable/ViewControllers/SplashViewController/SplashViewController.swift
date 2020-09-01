//
//  SplashViewController.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 01/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
//import SwiftyJSON
//import MBProgressHUD

class SplashViewController: BaseViewController {
    
    @IBOutlet weak var imageViewLogo: UIImageView!
    
    var timer = Timer()
    var count = Int()
    
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
    
//    Setup View Did load method
    func setupViewDidLoadMethod() -> Void {
        
        self.view.backgroundColor = UIColor.colorWithHexString(ColorCode.appBackground.rawValue)
        self.startTimer()
    }
    
    func startTimer() {
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.scrollToNextCell), userInfo: nil, repeats: true)
    }
    
    @objc func scrollToNextCell() {
        
        self.imageViewLogo.image = self.imageViewLogo.image!.rotate(radians: .pi/2)
        if count == 1 {
            self.timer.invalidate()
            if UserDefaultOperations.getBoolObject(ConstantStrings.IS_USER_LOGGED_IN) {
                if #available(iOS 13.0, *) {
                    self.setupDrawerForiOSHigherVersion()
                }else {
                    self.setupDrawerController()
                }
            }else {
                let loginVC = LoginViewController.init(nibName: "LoginViewController", bundle: nil)
                self.navigationController?.pushViewController(loginVC, animated: true)
            }
        }
        self.count += 1
    }
}

extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!

        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}
