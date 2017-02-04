//
//  NewProductViewController.swift
//  GiftTracker
//
//  Created by Yoon Yu on 2/2/17.
//  Copyright © 2017 Grace Yu. All rights reserved.
//

import UIKit

class NewProductViewController: UIViewController, UITextFieldDelegate {
   
   @IBOutlet weak var productImageView: UIImageView!
   @IBOutlet weak var productName: UITextField!
   @IBOutlet weak var friendFirstName: UITextField!
   @IBOutlet weak var friendLastName: UITextField!
   @IBOutlet weak var occassion: UITextField!
   @IBOutlet weak var productPrice: UITextField!
   @IBOutlet weak var upcCode: UILabel!
   @IBOutlet weak var scrollForKeyboard: UIScrollView!
   
   var passUPC:String!
   
   var productsUPC = [ProductUPC]()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      if passUPC != nil {
         UPCApi.fetchUPC(upc: passUPC, closure: { data in
            self.productsUPC = data as! [ProductUPC]
            self.displayProductInfo()
         })
      }
   }

   func displayProductInfo() {
      for x in 0..<productsUPC.count {
         productName.text = productsUPC[x].productName
         productImageView.downLoadImag(from: productsUPC[x].productImageUrl)
         productPrice.text = String(format: "%.2f", productsUPC[x].productPrice)
         upcCode.text = passUPC
      }
   }
   
   // Start Editing The Text Field
   func textFieldDidBeginEditing(_ textField: UITextField) {
      moveTextField(textField, moveDistance: -350, up: true)
   }
   
   // Finish Editing The Text Field
   func textFieldDidEndEditing(_ textField: UITextField) {
      moveTextField(textField, moveDistance: -350, up: false)
   }
   
   // Hide the keyboard when the return key pressed
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      return true
   }
   
   // Move the text field in a pretty animation!
   func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool) {
      let moveDuration = 0.3
      let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
      
      UIView.beginAnimations("animateTextField", context: nil)
      UIView.setAnimationBeginsFromCurrentState(true)
      UIView.setAnimationDuration(moveDuration)
      self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
      UIView.commitAnimations()
   }
   
   // Button to segue into scanner
   @IBAction func unwindToProductScreen(segue: UIStoryboardSegue) {
      dismiss(animated: true, completion: nil)
   }
}

