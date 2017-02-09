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

    }
   
   // https://www.amazon.com/s/ref=nb_sb_noss_1?url=search-alias%3Daps&field-keywords=
   
   @IBAction func exploreAmaonPressed(_ sender: Any) {
   }

}
