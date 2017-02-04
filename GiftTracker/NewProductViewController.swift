//
//  NewProductViewController.swift
//  GiftTracker
//
//  Created by Yoon Yu on 2/2/17.
//  Copyright © 2017 Grace Yu. All rights reserved.
//

import UIKit

class NewProductViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

   var passUPC:String!
   var productsUPC = [ProductUPC]()
   var eventPickerData: [String] = ["Birthday", "Valentine\'s day", "Mother\'s day", "Father's day", "Thanksgiving","Hanukkah","Christmas", "Other"]
   var eventName = ""
   
   @IBOutlet weak var productImageView: UIImageView!
   @IBOutlet weak var productName: UITextField!
   @IBOutlet weak var friendFirstName: UITextField!
   @IBOutlet weak var friendLastName: UITextField!
   @IBOutlet weak var productPrice: UITextField!
   @IBOutlet weak var upcCode: UILabel!
   @IBOutlet weak var eventPicker: UIPickerView!
//   @IBOutlet weak var scrollForKeyboard: UIScrollView!

   // MARK: Life 
   override func viewDidLoad() {
      super.viewDidLoad()
      
      eventPicker.delegate = self
      eventPicker.dataSource = self
      
      if passUPC != nil {
         UPCApi.fetchUPC(upc: passUPC, closure: { data in
            self.productsUPC = data as! [ProductUPC]
            self.displayProductInfo()
         })
      }
   }
   
   // displays information fetched from api.upcitemdb.com
   func displayProductInfo() {
      for x in 0..<productsUPC.count {
         productName.text = productsUPC[x].productName
         productImageView.downLoadImag(from: productsUPC[x].productImageUrl)
         productPrice.text = String(format: "%.2f", productsUPC[x].productPrice)
         upcCode.text = passUPC
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
      eventName = eventPickerData[row]
      print(eventName)
   }
   
   // MARK: IBAction ------------------------------------------------
   
   // Button to segue into scanner
   @IBAction func unwindToProductScreen(segue: UIStoryboardSegue) {
      dismiss(animated: true, completion: nil)
   }
}

