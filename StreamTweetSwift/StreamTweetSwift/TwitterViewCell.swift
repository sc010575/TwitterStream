//
//  TwitterViewCell.swift
//  StreamTweetSwift
//
//  Created by Suman Chatterjee on 03/06/2015.
//  Copyright (c) 2015 Suman Chatterjee. All rights reserved.
//

import UIKit

class TwitterViewCell: UITableViewCell {
    
    @IBOutlet weak var twittLabel:UILabel!
    @IBOutlet weak var nameLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        twittLabel.text = ""
        nameLabel.text  = ""
        
    }
    
    func configureCellWithText(var text:String, var name:String){
        self.twittLabel.text = text
        self.nameLabel.text = name
    }

    
}
