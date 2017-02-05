//
//  NewGiftViewController.swift
//  GiftTracker
//
//  Created by Yoon Yu on 2/2/17.
//  Copyright © 2017 Grace Yu. All rights reserved.
//

import UIKit
import Firebase

class NewGiftViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
   
   var source = String()
   var passUPC: String!
   var giftsUPC = [GiftUPC]()
   var eventPickerData: [String] = ["Birthday", "Valentine\'s day", "Mother\'s day", "Father's day", "Thanksgiving","Hanukkah","Christmas", "Other"]
   var eventName = "birthday"
   let datePicker = UIDatePicker()
   var giftImageURL = String()
   
   @IBOutlet weak var giftImageView: UIImageView!
   @IBOutlet weak var giftNameTextField: UITextField!
   @IBOutlet weak var friendFirstNameTextField: UITextField!
   @IBOutlet weak var friendLastNameTextField: UITextField!
   @IBOutlet weak var giftPriceTextField: UITextField!
   @IBOutlet weak var giftDateTextField: UITextField!
   @IBOutlet weak var eventPicker: UIPickerView!
   @IBOutlet weak var titleLabel: UILabel!
   @IBOutlet weak var dateLabel: UILabel!
   @IBOutlet weak var upcLabel: UILabel!
   @IBOutlet weak var notesTextField: UITextField!
   
   //   @IBOutlet weak var scrollForKeyboard: UIScrollView!
   
   // MARK: Life cycle
   override func viewDidLoad() {
      super.viewDidLoad()
      
      displayLabels()
      createDatePicker()
   
      eventPicker.delegate = self
      eventPicker.dataSource = self
      
      if passUPC != nil {
         UPCApi.fetchUPC(upc: passUPC!, closure: { data in
            self.giftsUPC = data as! [GiftUPC]
            self.displayGiftInfo()
         })
      } else {
         passUPC = "not provided"
         giftImageURL = "https://cdn.pixabay.com/photo/2013/09/21/15/47/gift-184574_1280.png"
      }
   }
   
   // function for alerts
   func alert(message: String) {
      let alertController = UIAlertController(title: "\(message.capitalized) is a required field" , message: "Please enter your \(message)", preferredStyle: .alert)
      let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
      alertController.addAction(defaultAction)
      self.present(alertController, animated: true, completion: nil)
   }
   
   func displayLabels() {
      let fromto = source == "received" ? "From" : "To"
      let whichDate = source == "received" ? "Date Recieved" : "Event Date"
      titleLabel.text = "Gift \(source.capitalized) \(fromto)"
      dateLabel.text = whichDate
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
   
   // functions related to event picker
   // The number of columns of data
   func numberOfComponents(in pickerView: UIPickerView) -> Int {
      return 1
   }
   
   func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      return eventPickerData.count
   }
   
   // The data to return for the row and component (column) that's being passed in
   func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
      return eventPickerData[row]
   }
   
   // Catpure the picker view selection
   func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      eventName = eventPickerData[row].lowercased()
   }
   
   // to get rid of keyboard by touching the outside of the textfield
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      self.view.endEditing(true)
      friendFirstNameTextField.resignFirstResponder()
      friendLastNameTextField.resignFirstResponder()
      eventPicker.resignFirstResponder()
      giftPriceTextField.resignFirstResponder()
   }
   
   // Date picker
   
   func createDatePicker() {
      let toolbar = UIToolbar()
      toolbar.sizeToFit()
      
      let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneDatePickerPressed))
      toolbar.setItems([doneButton], animated: false)
      
      giftDateTextField.inputAccessoryView = toolbar
      giftDateTextField.inputView = datePicker
      datePicker.datePickerMode = .date
   }
   
   func doneDatePickerPressed() {
      Format.shared.dateFormatter.dateStyle = .short
      Format.shared.dateFormatter.timeStyle = .none
      giftDateTextField.text = Format.shared.dateFormatter.string(from: datePicker.date)
      self.view.endEditing(true)
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
      let firstName = friendFirstNameTextField.text?.lowercased()
      let lastName = friendLastNameTextField.text?.lowercased()
      let giftPrice = self.giftPriceTextField.text
      let notes = self.notesTextField.text
      let date = self.giftDateTextField.text
      
      if giftName == "" {
         alert(message: "gift name")
      } else if firstName == "" {
         alert(message: "first name")
      } else if lastName == "" {
         alert(message: "last name")
      } else if date == "" {
         alert(message: "date")
      } else {
         GiftDataModel.shared.createGift(dateRecieved: date!, eventDate: date!, eventName: eventName, friendFirstName: firstName!, friendLastName: lastName!, giftStatus: source, giftImageUrl: giftImageURL, giftName: giftName!, giftPrice: giftPrice!, giftUPCCode: passUPC, notes: notes!, userID: FIRAuth.auth()!.currentUser!.uid)
      }
   }   
}

