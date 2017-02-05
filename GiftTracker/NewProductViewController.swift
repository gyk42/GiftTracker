//
//  NewProductViewController.swift
//  GiftTracker
//
//  Created by Yoon Yu on 2/2/17.
//  Copyright © 2017 Grace Yu. All rights reserved.
//

import UIKit
import Firebase

class NewProductViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
   
   var source = String()
   var passUPC: String!
   var productsUPC = [ProductUPC]()
   var eventPickerData: [String] = ["Birthday", "Valentine\'s day", "Mother\'s day", "Father's day", "Thanksgiving","Hanukkah","Christmas", "Other"]
   var eventName = "birthday"
   let datePicker = UIDatePicker()
   var productImageURL = String()
   
   @IBOutlet weak var productImageView: UIImageView!
   @IBOutlet weak var productName: UITextField!
   @IBOutlet weak var friendFirstName: UITextField!
   @IBOutlet weak var friendLastName: UITextField!
   @IBOutlet weak var productPrice: UITextField!
   @IBOutlet weak var date: UITextField!
   @IBOutlet weak var eventPicker: UIPickerView!
   @IBOutlet weak var titleLabel: UILabel!
   @IBOutlet weak var dateLabel: UILabel!
   
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
            self.productsUPC = data as! [ProductUPC]
            self.displayProductInfo()
         })
      } else {
         passUPC = "not provided"
         productImageURL = "0"
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
   func displayProductInfo() {
      for x in 0..<productsUPC.count {
         productName.text = productsUPC[x].productName
         productImageView.downLoadImag(from: productsUPC[x].productImageUrl)
         productPrice.text = String(format: "%.2f", productsUPC[x].productPrice)
         //upcCode.text = passUPC
         productImageURL = productsUPC[x].productImageUrl
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
      friendFirstName.resignFirstResponder()
      friendLastName.resignFirstResponder()
      eventPicker.resignFirstResponder()
      productPrice.resignFirstResponder()
   }
   
   // Date picker
   
   func createDatePicker() {
      let toolbar = UIToolbar()
      toolbar.sizeToFit()
      
      let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneDatePickerPressed))
      toolbar.setItems([doneButton], animated: false)
      
      date.inputAccessoryView = toolbar
      date.inputView = datePicker
      datePicker.datePickerMode = .date
   }
   
   func doneDatePickerPressed() {
      Format.shared.dateFormatter.dateStyle = .short
      Format.shared.dateFormatter.timeStyle = .none
      date.text = Format.shared.dateFormatter.string(from: datePicker.date)
      self.view.endEditing(true)
   }
   
   // MARK: IBAction ------------------------------------------------
   
   // Button to segue into scanner
   @IBAction func unwindToProductScreen(segue: UIStoryboardSegue) {
      dismiss(animated: true, completion: nil)
//      performSegue(withIdentifier: "toScanner", sender: source)
   }
   
   @IBAction func savePressed(_ sender: Any) {
      // Save product info into FB
      let productName = self.productName.text?.lowercased()
      let firstName = friendFirstName.text?.lowercased()
      let lastName = friendLastName.text?.lowercased()
      let productPrice = self.productPrice.text
      let date = self.date.text
      
      if productName == "" {
         alert(message: "product name")
      } else if firstName == "" {
         alert(message: "first name")
      } else if lastName == "" {
         alert(message: "last name")
      } else if date == "" {
         alert(message: "date")
      } else {
         ProductDataModel.shared.createProduct(dateRecieved: date!, eventDate: date!, eventName: eventName, friendFirstName: firstName!, friendLastName: lastName!, giftStatus: source, productImageUrl: productImageURL, productName: productName!, productPrice: productPrice!, productUPCCode: passUPC, userID: FIRAuth.auth()!.currentUser!.uid)
      }
   }   
}

