//
//  HomeViewController.swift
//  GiftTracker
//
//  Created by Yoon Yu on 2/4/17.
//  Copyright © 2017 Grace Yu. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
   
   @IBOutlet weak var givingBtn: UIButton!
   @IBOutlet weak var receivedBtn: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
   
   @IBAction func signoutPressed(_ sender: Any) {
      UserDataModel.shared.logout()
   }
   
   @IBAction func buttonTouchUpInside(_ sender: UIButton) {
      switch sender {
      case givingBtn:
         performSegue(withIdentifier: "toNewGift", sender: "giving")
      case receivedBtn:
         performSegue(withIdentifier: "toNewGift", sender: "received")
      default:
         ()
      }
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "toNewGift" {
//         let destination = segue.destination as! NewGiftViewController
         NewGiftViewController.source = sender as! String
      }
   }
}
