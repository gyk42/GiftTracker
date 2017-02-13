//
//  NewUserViewController.swift
//  GiftTracker
//
//  Created by Yoon Yu on 2/4/17.
//  Copyright © 2017 Grace Yu. All rights reserved.
//

import UIKit
import Firebase

class NewUserViewController: UIViewController {
   
   var ref: FIRDatabaseReference!
   
   //MARK: IBoutlet ---------------------------------
   
   @IBOutlet weak var userFirstName: UITextField!
   @IBOutlet weak var userLastName: UITextField!
   @IBOutlet weak var userEmail: UITextField!
   @IBOutlet weak var userPassword: UITextField!
   @IBOutlet weak var signInBtn: UIButton!
   @IBOutlet weak var createAccountBtn: UIButton!
   
   //MARK: Life-cycle ---------------------------------
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      ref = FIRDatabase.database().reference()
      
      // Style buttons to give softer look
      StyleModel.shared.styleButtons(buttonName: signInBtn)
      StyleModel.shared.styleButtons(buttonName: createAccountBtn)
      
      // Use exention getting to the next textfield
      UITextField.connectFields(fields: [userFirstName, userLastName, userEmail, userPassword])
   }
   
   // to get rid of keyboard by touching the outside of the textfield
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      self.view.endEditing(true)
   }
   
   // function for alerts
   func alert(message: String) {
      let alertController = UIAlertController(title: "\(message.capitalized) is a required field" , message: "Please enter your \(message)", preferredStyle: .alert)
      let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
      alertController.addAction(defaultAction)
      self.present(alertController, animated: true, completion: nil)
   }
   
   //MARK: IBAction ---------------------------------
   
   @IBAction func submitPressed(_ sender: Any) {
      
      let email = userEmail.text!
      let firstName = userFirstName.text!
      let lastName = userLastName.text!
      let password = userPassword.text!
      
      // textfield validation
      if firstName == "" {
         alert(message: "first name")
      } else if lastName == "" {
         alert(message: "last name")
      } else if email == "" {
         alert(message: "email address")
      } else if password == "" {
         alert(message: "password")
      } else {
         FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
            // Checks to see if user exists
            if let error = error {
               let alertController = UIAlertController(title: "User exists.", message: "Please use another email or sign in.", preferredStyle: UIAlertControllerStyle.alert)
               let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
               
               alertController.addAction(defaultAction)
               self.present(alertController, animated: true, completion: nil)
               print(error.localizedDescription)
            } else {
               // Creates user
               let currentUserID = FIRAuth.auth()!.currentUser!.uid
               
               self.ref.child("users").updateChildValues(["\(currentUserID)":["userFirstName": firstName, "userLastName" : lastName, "userEmail" : email]])
               UserDataModel.shared.user = User(userID: currentUserID, userEmail: email, userFirstName: firstName, userLastName: lastName)
               
               // After it creates an account, it goes into new member modal
               self.performSegue(withIdentifier: "toPopUp", sender: self)
            }
         }
      }
   }
}
