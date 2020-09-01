//
//  ContinueWatchCollectionViewCell.swift
//  Social.Cable
//
//  Created by Arun Kumar Rathore on 01/08/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class ContinueWatchCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageViewContinueWatch: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.imageViewContinueWatch.layer.cornerRadius = 5.0
        self.imageViewContinueWatch.layer.masksToBounds = true
    }

}
