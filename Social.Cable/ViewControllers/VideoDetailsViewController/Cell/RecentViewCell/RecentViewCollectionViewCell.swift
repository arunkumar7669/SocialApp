//
//  RecentViewCollectionViewCell.swift
//  Social.Cable
//
//  Created by Arun Kumar Rathore on 06/08/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class RecentViewCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageViewStar: UIImageView!
    @IBOutlet weak var labelStar: UILabel!
    @IBOutlet weak var imageViewVideo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.imageViewVideo.layer.cornerRadius = 5.0
        self.imageViewVideo.layer.masksToBounds = true
    }

}
