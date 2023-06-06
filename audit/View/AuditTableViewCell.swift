//
//  AuditTableViewCell.swift
//  audit
//
//  Created by LI,JYUN-SIAN on 29/5/23.
//

import UIKit

class AuditTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var updateImage: UIImageView!
    @IBOutlet weak var siteLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
