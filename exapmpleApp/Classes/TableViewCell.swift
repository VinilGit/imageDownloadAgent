//
//  TableViewCell.swift
//  exapmpleApp
//
//  Created by testuser on 11/29/14.
//  Copyright (c) 2014 testuser. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    var shotImageView: UIImageView!
    var idLabel: UILabel!
    var shotId:Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupVew()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupVew()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        self.imageView.image = nil
        self.shotId = nil
    }
    
    private func setupVew() {
        self.clipsToBounds = true
        let size = self.frame.size
        let imageHeight = size.height
        shotImageView = UIImageView(frame: CGRectMake(size.width-imageHeight, 0, imageHeight, imageHeight))
        self.addSubview(shotImageView)
        
        
        idLabel = UILabel(frame: CGRectMake(0, 0, size.width - imageHeight, imageHeight))
        self.addSubview(idLabel)
    }

}
