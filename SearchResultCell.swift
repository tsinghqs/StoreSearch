//
//  SearchResultCell.swift
//  StoreSearch
//
//  Created by Tarun Singh on 6/28/18.
//  Copyright © 2018 Tarun Singh. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {

    @IBOutlet var artworkImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var artistNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let selectedView = UIView(frame: CGRect.zero)
        selectedView.backgroundColor = UIColor(red: 30/255, green: 160/255, blue: 160/255, alpha: 0.5)
        
        selectedBackgroundView = selectedView
    }
}
