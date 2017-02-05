//
//  ListOfGiftsTableViewCell.swift
//  GiftTracker
//
//  Created by Yoon Yu on 1/30/17.
//  Copyright © 2017 Grace Yu. All rights reserved.
//

import UIKit

class ListOfGiftsTableViewCell: UITableViewCell {
   
   @IBOutlet weak var toFromLabel: UILabel!
   @IBOutlet weak var giftNameLabel: UILabel!
   @IBOutlet weak var giftPriceLabel: UILabel!
   @IBOutlet weak var eventLabel: UILabel!
   @IBOutlet weak var dateLabel: UILabel!
   @IBOutlet weak var giftImageView: UIImageView!
   
   override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
   }
   
   override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
      
      // Configure the view for the selected state
   }
   
}
