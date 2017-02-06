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

class LoginViewController: UIViewController {
   
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
   }
   
   
   override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      
      if FIRAuth.auth()?.currentUser != nil {
         print("=======current user exist============")
         // segue into next page
         performSegue(withIdentifier: "goToGTHome", sender: self)
         
         //UserDataModel.shared.logout()
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
