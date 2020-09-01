//
//  InviteFriendTableViewCell.swift
//  Social.Cable
//
//  Created by Arun Kumar Rathore on 07/08/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class InviteFriendTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewInvite: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelNumber: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonVoiceCallAction(_ sender: UIButton) {
        
    }
    
    @IBAction func buttonVideoCallAction(_ sender: UIButton) {
        
    }
}
