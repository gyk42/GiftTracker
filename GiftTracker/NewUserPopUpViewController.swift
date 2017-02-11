//
//  NewUserPopUpViewController.swift
//  GiftTracker
//
//  Created by Yoon Yu on 2/10/17.
//  Copyright © 2017 Grace Yu. All rights reserved.
//

import UIKit

class NewUserPopUpViewController: UIViewController {
   
   @IBOutlet weak var popUpMessageOutlet: UIView!
   
   @IBOutlet weak var popUpEnterBtn: UIButton!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      popUpMessageOutlet.layer.cornerRadius = 8
      //popUpMessageOutlet.layer.borderWidth = 1.5
     // popUpMessageOutlet.layer.borderColor = UIColor.lightGray.cgColor
   }
   
   @IBAction func dissmissPopupPressed(_ sender: Any) {
      //dismiss(animated: true, completion: nil)
      self.performSegue(withIdentifier: "toHome", sender: self)
   }
   
   @IBAction func enterBtnPressed(_ sender: Any) {
      self.performSegue(withIdentifier: "toHome", sender: self)
   }
}
