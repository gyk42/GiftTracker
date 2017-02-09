//
//  AddFriendInfoViewController.swift
//  GiftTracker
//
//  Created by Yoon Yu on 2/9/17.
//  Copyright © 2017 Grace Yu. All rights reserved.
//

import UIKit

class AddFriendInfoViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
   
   var source = String()
   var isGiving:Bool = true
   var eventPickerData: [String] = ["Birthday", "Valentine\'s day", "Mother\'s day", "Father's day", "Thanksgiving", "Hanukkah", "Christmas", "Bridal Shower", "Baby Shower", "Other"]
   var eventName = "birthday"
   let eventPicker = UIPickerView()
   let datePicker = UIDatePicker()
   
   @IBOutlet weak var giftStatus: UISegmentedControl!
   @IBOutlet weak var titleLabel: UILabel!
   @IBOutlet weak var friendFirstNameTextField: UITextField!
   @IBOutlet weak var friendLastNameTextField: UITextField!
   @IBOutlet weak var giftDateTextField: UITextField!
   @IBOutlet weak var eventPickerTextField: UITextField!
   @IBOutlet weak var descriptionTextField: UITextField!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      createDatePicker()
      eventPicker.delegate = self
      eventPicker.dataSource = self
      eventPickerTextField.inputView = eventPicker
      
   }
   
   // to get rid of keyboard by touching the outside of the textfield
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      self.view.endEditing(true)
   }
   
   // dynamic alert controller to handle different textfields
   func alert(message: String) {
      let alertController = UIAlertController(title: "\(message.capitalized) is a required field" , message: "Please enter your \(message)", preferredStyle: .alert)
      let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
      alertController.addAction(defaultAction)
      self.present(alertController, animated: true, completion: nil)
   }
   
   // MARK: event picker
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
      eventPickerTextField.text = eventName
      self.view.endEditing(false)
   }
   
   // MARK: Date picker
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
   
   @IBAction func giftStatusChanged(_ sender: UISegmentedControl) {
      
      // flip boolean
      isGiving = !isGiving
      
      // checks boolean and sets the header label, changes placeholder and gift status value
      if isGiving {
         titleLabel.text = "Gift Giving it To"
         giftDateTextField.placeholder = "Event Date"
         source = "giving"
      } else {
         titleLabel.text = "Gift Recived From"
         giftDateTextField.placeholder = "Received Date"
         source = "received"
      }
   }
   
   @IBAction func addAGiftPressed(_ sender: Any) {
      let firstName = friendFirstNameTextField.text?.lowercased()
      let lastName = friendLastNameTextField.text?.lowercased()
      let notes = descriptionTextField.text
      let date = giftDateTextField.text
      let eventName = eventPickerTextField.text
      
      if firstName == "" {
         alert(message: "first name")
      } else if lastName == "" {
         alert(message: "last name")
      } else if date == "" {
         alert(message: "date")
      } else if eventName == "" {
         alert(message: "event name")
      } else {
         
      }
   }
   
   
}

