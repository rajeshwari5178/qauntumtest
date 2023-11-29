//
//  NewsCell.swift
//  QuntumTest
//
//  Created by Rajeshwari Sharma on 29/11/23.
//

import UIKit

class NewsCell: UITableViewCell {
    @IBOutlet weak var headlinecell: UIView!
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var headlinelbl: UILabel!
    
    @IBOutlet weak var nsamelbl: UILabel!
    
    @IBOutlet weak var date: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        img.layer.cornerRadius=14
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
