//
//  NewUserPopUpViewController.swift
//  GiftTracker
//
//  Created by Yoon Yu on 2/10/17.
//  Copyright © 2017 Grace Yu. All rights reserved.
//

import UIKit

class NewUserPopUpViewController: UIViewController {
   
   // MARK: IBAOutlet -------------------------------------
   
   @IBOutlet weak var popUpMessageOutlet: UIView!
   
   @IBOutlet weak var popUpEnterBtn: UIButton!
   
   // MARK: Life-cycle -------------------------------------
   
   override func viewDidLoad() {
      super.viewDidLoad()
      popUpMessageOutlet.layer.cornerRadius = 8
   }
   
   // MARK: IBAction -------------------------------------
   
   @IBAction func dissmissPopupPressed(_ sender: Any) {
      self.performSegue(withIdentifier: "toHome", sender: self)
   }
   
   @IBAction func enterBtnPressed(_ sender: Any) {
      self.performSegue(withIdentifier: "toHome", sender: self)
   }
}
