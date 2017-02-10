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
   @IBOutlet weak var createAccountBtn: UIButton!
   @IBOutlet weak var signInBtn: UIButton!
   
   // MARK: Life-cycle -------------------------------

   override func viewDidLoad() {
      super.viewDidLoad()
      
      // style buttons to give softer look
      StyleModel.shared.styleButtons(buttonName: signInBtn)
      StyleModel.shared.styleButtons(buttonName: createAccountBtn)
      
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
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      self.navigationController?.isNavigationBarHidden = false
      //self.navigationController!.popToRootViewController(animated: true)
   }
   
   override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      self.navigationController?.isNavigationBarHidden = false
      //self.navigationController!.popToRootViewController(animated: true)
   }
   
   override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      
      if FIRAuth.auth()?.currentUser != nil {
         print("=======current user exist============")
         // segue into next page
         performSegue(withIdentifier: "goToHome", sender: self)
      } else {
         print("=========no current user============")
      }
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
   
   // to get rid of keyboard by touching the outside of the textfield
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      self.view.endEditing(true)
   }
   
   // MARK: IBAction -------------------------------
 //  @IBAction func unwindToLogin(segue: UIStoryboardSegue) {}
   
   @IBAction func signInPressed(_ sender: Any) {
      
      let userLoginEmail = userEmailTextField.text!
      let userLoginPassword = userPasswordTextField.text!
      
      UserDataModel.shared.login(email: userLoginEmail, password: userLoginPassword, complete: { success in
         if success {
            self.performSegue(withIdentifier: "goToHome", sender: self)
         } else {
            let alertController = UIAlertController(title: "Error", message: "Please provide a valid email or password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
         }
      })
   }
}
