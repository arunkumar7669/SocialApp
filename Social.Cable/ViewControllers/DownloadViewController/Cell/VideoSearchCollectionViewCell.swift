//
//  VideoSearchCollectionViewCell.swift
//  Social.Cable
//
//  Created by Arun Kumar Rathore on 04/08/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class VideoSearchCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewLike: UIView!
    @IBOutlet weak var labelLikeCount: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelCategory: UILabel!
    @IBOutlet weak var imageViewCategory: UIImageView!
    @IBOutlet weak var ViewCategoryBg: UIView!
    @IBOutlet weak var imageViewVideo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
