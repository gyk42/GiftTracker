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
   
   var source = String()
   var passUPC: String!
   var giftsUPC = [GiftUPC]()
   var giftImageURL = String()
   //static var firstName = String()
   var firstName = String()
   var lastName = String()
   var notes = String()
   var date = String()
   var eventName = String()
   var sourceType: String = ""
   
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
      
      print("from gift \(firstName)")
      
      // style button to give softer look
      StyleModel.shared.styleButtons(buttonName: saveGiftInfoBtn)
      
      // Grabs the upc code from scanner and pass it through API
      grabPassUPC()
      
      // WIP trying to grab source and set it to pass it to scanner...
      self.source = sourceType
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
         giftImageURL = "https://cdn.pixabay.com/photo/2013/09/21/15/47/gift-184574_1280.png"
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
      //      performSegue(withIdentifier: "toScanner", sender: source)
   }
   
   @IBAction func savePressed(_ sender: Any) {
      // Save gift info into FB
      let giftName = self.giftNameTextField.text?.lowercased()
      let firstName = self.firstName.lowercased()
      let lastName = self.lastName.lowercased()
      let giftPrice = self.giftPriceTextField?.text
      let notes = self.notes
      let date = self.date
      
      if giftName == "" {
         alert(message: "gift name")
      } else {
         GiftDataModel.shared.createGift(dateRecieved: date, eventDate: date, eventName: self.eventName, friendFirstName: firstName, friendLastName: lastName, giftStatus: self.source, giftImageUrl: giftImageURL, giftName: giftName!, giftPrice: giftPrice!, giftUPCCode: passUPC, notes: notes, userID: FIRAuth.auth()!.currentUser!.uid, complete: { success in
            if success {
               self.performSegue(withIdentifier: "goToHome", sender: self)
            }
         })
      }
   }
}

