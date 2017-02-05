//
//  UserDataModel.swift
//  GiftTracker
//
//  Created by Yoon Yu on 2/4/17.
//  Copyright © 2017 Grace Yu. All rights reserved.
//

import Foundation
import FirebaseAuth

class UserDataModel {
   static let shared = UserDataModel()
   private init() {}
   
   var user: User?
   
   // global code to login users
   func login(email: String, password: String, complete: @escaping (Bool) -> ()) {
      FIRAuth.auth()?.signIn(withEmail: email, password: password) { user, error in
         complete(user != nil)
      }
   }
   
   // global code to logout users
   func logout() {
      do {
         try FIRAuth.auth()?.signOut()
         
        // performSegue(withIdentifier: "logoutToLogin", sender: self)
         
      } catch {
         print(error.localizedDescription)
      }
   }

}
