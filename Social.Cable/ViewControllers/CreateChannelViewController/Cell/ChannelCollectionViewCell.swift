//
//  ChannelCollectionViewCell.swift
//  Social.Cable
//
//  Created by Arun Kumar Rathore on 30/07/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class ChannelCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageViewChannel: UIImageView!
    @IBOutlet weak var viewBg: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.imageViewChannel.layer.cornerRadius = 5.0
        self.imageViewChannel.layer.masksToBounds = true
    }

}
