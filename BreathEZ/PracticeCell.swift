//
//  PracticeCell.swift
//  BreathEZ
//
//  Created by Tunscopi on 3/25/17.
//  Copyright © 2017 Wilson Ding. All rights reserved.
//

import UIKit

class PracticeCell: UITableViewCell {
  
  @IBOutlet weak var practiceImageView: UIImageView!
  @IBOutlet weak var practiceNameLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var distAway: UILabel!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    practiceImageView.layer.cornerRadius = 40
    practiceImageView.clipsToBounds = true
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
