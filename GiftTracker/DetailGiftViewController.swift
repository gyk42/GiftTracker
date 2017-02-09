//
//  DetailGiftViewController.swift
//  GiftTracker
//
//  Created by Yoon Yu on 2/7/17.
//  Copyright © 2017 Grace Yu. All rights reserved.
//

import UIKit
import Firebase

class DetailGiftViewController: UIViewController {
   
   var gift: Gift!
   
   @IBOutlet weak var giftImageView: UIImageView!
   @IBOutlet weak var giftNameLabel: UILabel!
   @IBOutlet weak var friendFirstNameLabel: UILabel!
   @IBOutlet weak var friendLastNameLabel: UILabel!
   @IBOutlet weak var giftPriceLabel: UILabel!
   @IBOutlet weak var upcLabel: UILabel!
   @IBOutlet weak var eventLabel: UILabel!
   @IBOutlet weak var eventDateLabel: UILabel!
   @IBOutlet weak var notesTextView: UITextView!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      self.title = "Gift Recorder"
      self.giftImageView.downLoadImag(from: gift.giftImageUrl!)
      self.giftNameLabel.text = gift?.giftName?.capitalized
      self.friendFirstNameLabel.text = gift?.friendFirstName?.capitalized
      self.friendLastNameLabel.text = gift?.friendLastName?.capitalized
      self.giftPriceLabel.text = gift?.giftPrice
      self.upcLabel.text = gift?.giftUPCCode
      self.eventLabel.text = gift?.eventName?.capitalized
      self.eventDateLabel.text = gift?.eventDate
      self.notesTextView.text = gift?.notes
   }
   
}
