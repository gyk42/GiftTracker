//
//  AddGiftInfoViewController.swift
//  GiftTracker
//
//  Created by Yoon Yu on 2/2/17.
//  Copyright © 2017 Grace Yu. All rights reserved.
//

import UIKit
import Firebase

class AddGiftInfoController: UIViewController, UITextFieldDelegate {
   
   static var source = String()
   var passUPC: String!
   var giftsUPC = [GiftUPC]()
   var giftImageURL = String()
   
   @IBOutlet weak var giftImageView: UIImageView!
   @IBOutlet weak var giftNameTextField: UITextField!
   @IBOutlet weak var giftPriceTextField: UITextField!
   @IBOutlet weak var titleLabel: UILabel!
   @IBOutlet weak var upcLabel: UILabel!

   //   @IBOutlet weak var scrollForKeyboard: UIScrollView!
   
   // MARK: Life cycle
   override func viewDidLoad() {
      super.viewDidLoad()
      
      if passUPC != nil {
         UPCApi.fetchUPC(upc: passUPC!, closure: { data in
            self.giftsUPC = data as! [GiftUPC]
            self.displayGiftInfo()
            if self.giftsUPC.count == 0 {
               self.alertForUPC()
            }
         })
      } else {
         passUPC = "not provided"
         giftImageURL = "https://cdn.pixabay.com/photo/2013/09/21/15/47/gift-184574_1280.png"
      }
   }
   
   // to get rid of keyboard by touching the outside of the textfield
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      self.view.endEditing(true)
   }
   
   // function for alerts
   
   func alertForUPC() {
      let alertController = UIAlertController(title: "UPC: \(passUPC!) is not found" , message: "Please enter gift information manually", preferredStyle: .alert)
      let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
      alertController.addAction(defaultAction)
      self.present(alertController, animated: true, completion: nil)
   }

   func alert(message: String) {
      let alertController = UIAlertController(title: "\(message.capitalized) is a required field" , message: "Please enter your \(message)", preferredStyle: .alert)
      let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
      alertController.addAction(defaultAction)
      self.present(alertController, animated: true, completion: nil)
   }
   
   
   
   // displays information fetched from api.upcitemdb.com
   func displayGiftInfo() {
      for x in 0..<giftsUPC.count {
         giftNameTextField.text = giftsUPC[x].giftName
         giftImageView.downLoadImag(from: giftsUPC[x].giftImageUrl)
         giftPriceTextField.text = String(format: "%.2f", giftsUPC[x].giftPrice)
         upcLabel.text = passUPC
         giftImageURL = giftsUPC[x].giftImageUrl
      }
   }
   
   // MARK: IBAction ------------------------------------------------
   
   // Button to segue into scanner
   @IBAction func unwindToGiftScreen(segue: UIStoryboardSegue) {
      dismiss(animated: true, completion: nil)
      //      performSegue(withIdentifier: "toScanner", sender: source)
   }
   
//   @IBAction func savePressed(_ sender: Any) {
//      // Save gift info into FB
//      let giftName = self.giftNameTextField.text?.lowercased()
//      let firstName = friendFirstNameTextField.text?.lowercased()
//      let lastName = friendLastNameTextField.text?.lowercased()
//      let giftPrice = self.giftPriceTextField.text
//      let notes = self.notesTextField.text
//      let date = self.giftDateTextField.text
//      
//      if giftName == "" {
//         alert(message: "gift name")
//      } else {
//         GiftDataModel.shared.createGift(dateRecieved: date!, eventDate: date!, eventName: eventName, friendFirstName: firstName!, friendLastName: lastName!, giftStatus: NewGiftViewController.source, giftImageUrl: giftImageURL, giftName: giftName!, giftPrice: giftPrice!, giftUPCCode: passUPC, notes: notes!, userID: FIRAuth.auth()!.currentUser!.uid, complete: { success in
//            if success {
//               self.performSegue(withIdentifier: "goToHistory", sender: self)
//            }
//         })
//      }
//   }
}

