//
//  LoginViewController.swift
//  GiftTracker
//
//  Created by Yoon Yu on 2/4/17.
//  Copyright © 2017 Grace Yu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class LoginViewController: UIViewController, UITextFieldDelegate {
   
   // MARK: IBOutlet -------------------------------
   
   @IBOutlet weak var userEmailTextField: UITextField!
   @IBOutlet weak var userPasswordTextField: UITextField!
   
   // temporary
   @IBAction func signoutPressed(_ sender: Any) {
      UserDataModel.shared.logout()
   }
   // MARK: Life-cycle -------------------------------
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // text field delegates
      userEmailTextField.delegate = self
      userPasswordTextField.delegate = self
      
      // set return key styles
      userEmailTextField.returnKeyType = UIReturnKeyType.next
      userPasswordTextField.returnKeyType = UIReturnKeyType.done
      
      // only enable userPasswordTextField if userEmailTextField is non-empty
      userPasswordTextField.isEnabled = false
      
      // only enable 'go' key of userPasswordTextField if the field itself is non-empty
      userPasswordTextField.enablesReturnKeyAutomatically = true
      
   }
   
   // UITextFieldDelegate
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      
      if (userEmailTextField.text?.isEmpty ?? true) {
         userPasswordTextField.isEnabled = false
         textField.resignFirstResponder()
      }
      else if textField == userEmailTextField {
         userPasswordTextField.isEnabled = true
         userPasswordTextField.becomeFirstResponder()
      }
      else {
         textField.resignFirstResponder()
      }
      
      return true
   }
   
   override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      
      if FIRAuth.auth()?.currentUser != nil {
         print("=======current user exist============")
         // segue into next page
         performSegue(withIdentifier: "goToGTHome", sender: self)
      } else {
         print("=========no current user============")
      }
   }
   // to get rid of keyboard by touching the outside of the textfield
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      self.view.endEditing(true)
   }
   
   // MARK: IBAction -------------------------------
   @IBAction func loginBtnPressed(_ sender: Any) {
      
      let userLoginEmail = userEmailTextField.text!
      let userLoginPassword = userPasswordTextField.text!
      
      UserDataModel.shared.login(email: userLoginEmail, password: userLoginPassword, complete: { success in
         if success {
            self.performSegue(withIdentifier: "goToGTHome", sender: self)
         } else {
            let alertController = UIAlertController(title: "Error", message: "Please provide a valid email or password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
         }
      })
   }
}
