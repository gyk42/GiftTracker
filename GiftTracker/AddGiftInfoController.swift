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
   
   var passUPC: String!
   var giftsUPC = [GiftUPC]()
   var giftImageURL = String()
   static var source = String()
   static var firstName = String()
   static var lastName = String()
   static var notes = String()
   static var date = String()
   static var eventName = String()
   //   var firstName = String()
   //static var sourceType: String = ""
   
   @IBOutlet weak var giftImageView: UIImageView!
   @IBOutlet weak var giftNameTextField: UITextField!
   @IBOutlet weak var giftPriceTextField: UITextField!
   @IBOutlet weak var titleLabel: UILabel!
   @IBOutlet weak var upcLabel: UILabel!
   @IBOutlet weak var saveGiftInfoBtn: UIButton!
   
   //   @IBOutlet weak var scrollForKeyboard: UIScrollView!
   
   // MARK: Life cycle
   override func viewDidLoad() {
      super.viewDidLoad()
      
      print("from gift \(AddGiftInfoController.firstName)")
      
      // style button to give softer look
      StyleModel.shared.styleButtons(buttonName: saveGiftInfoBtn)
      
      // Use exention getting to the next textfield
      UITextField.connectFields(fields: [giftNameTextField, giftPriceTextField])
      
      // Grabs the upc code from scanner and pass it through API
      grabPassUPC()
      
      // sets for timestamp for Firebase
      Format.shared.dateFormatter.timeStyle = .long
   }
   
   // to get rid of keyboard by touching the outside of the textfield
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      self.view.endEditing(true)
   }
   
   // MARK: function for alerts
   
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
   
   // MARK: API related functions
   
   // Grabs the upc code from scanner and pass it through API
   func grabPassUPC() {
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
         giftImageURL = "http://icons.iconarchive.com/icons/himacchi/sweetbox/128/gift-icon.png"
      }
      
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
      // performSegue(withIdentifier: "toScanner", sender: source)
   }
   
   @IBAction func savePressed(_ sender: Any) {
      // Save gift info into FB
      let giftName = self.giftNameTextField.text?.lowercased()
      let firstName = AddGiftInfoController.firstName.lowercased()
      let lastName = AddGiftInfoController.lastName.lowercased()
      let eventName = AddGiftInfoController.eventName.lowercased()
      let giftPrice = self.giftPriceTextField?.text
      let notes = AddGiftInfoController.notes
      let date = AddGiftInfoController.date
      
      if giftName == "" {
         alert(message: "gift name")
      } else {
         GiftDataModel.shared.createGift(dateRecieved: date, eventDate: date, eventName: eventName, friendFirstName: firstName, friendLastName: lastName, giftStatus: AddGiftInfoController.source, giftImageUrl: giftImageURL, giftName: giftName!, giftPrice: giftPrice!, giftUPCCode: passUPC, notes: notes, timeStamp: Date().format(), userID: FIRAuth.auth()!.currentUser!.uid, complete: { success in
            if success {
               self.performSegue(withIdentifier: "goToHome", sender: self)
            }
         })
      }
   }
}

