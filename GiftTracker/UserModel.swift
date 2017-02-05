//
//  UserDataModel.swift
//  GiftTracker
//
//  Created by Yoon Yu on 2/4/17.
//  Copyright © 2017 Grace Yu. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class User {
   
   var userID = FIRAuth.auth()?.currentUser?.uid
   var userEmail: String
   var userFirstName: String
   var userLastName: String
   var ref: FIRDatabaseReference?
   
   init(userID: String, userEmail: String, userFirstName: String, userLastName: String) {
      self.userID = userID
      self.userEmail = userEmail
      self.userFirstName = userFirstName
      self.userLastName = userLastName
   }
   
   init(snapshot: FIRDataSnapshot) {
      userID = snapshot.key
      let snapshotValue = snapshot.value as! [String: AnyObject]
      userEmail = snapshotValue["userEmail"] as! String
      userFirstName = snapshotValue["userFirstName"] as! String
      userLastName = snapshotValue["userLastName"] as! String
   }
   
   func toAnyObject() -> [String: AnyObject] {
      return [
         "userID":userID as Any as AnyObject,
         "userEmail": userEmail as String as AnyObject,
         "userFirstName" : userFirstName as String as AnyObject,
         "userLastName": userLastName as String as AnyObject
      ]
   }
}
