//
//  ProductModel.swift
//  GiftTracker
//
//  Created by Yoon Yu on 2/5/17.
//  Copyright © 2017 Grace Yu. All rights reserved.
//

import Foundation
import Firebase

var products = [Product]()

class Product {
   var productID: String?
   var dateRecieved: String?
   var eventDate: String?
   var eventName: String?
   var friendFirstName: String?
   var friendLastName: String?
   var giftStatus: String
   var productImageUrl: String?
   var productName: String?
   var productPrice: String?
   var productUPCCode: String?
   var userID = FIRAuth.auth()?.currentUser?.uid
   var ref: FIRDatabaseReference?
   
   init(dateRecieved: String, eventDate: String, eventName: String, friendFirstName: String, friendLastName: String, giftStatus: String, productImageUrl: String, productName: String, productPrice: String, productUPCCode: String, userID: String) {
      self.dateRecieved = dateRecieved
      self.eventDate = eventDate
      self.eventName = eventName
      self.friendFirstName = friendFirstName
      self.friendLastName = friendLastName
      self.giftStatus = giftStatus
      self.productImageUrl = productImageUrl
      self.productName = productName
      self.productPrice = productPrice
      self.productUPCCode = productUPCCode
      self.userID = userID
   }
   
   init(snapshot: FIRDataSnapshot) {
      productID = snapshot.key
      let snapshotValue = snapshot.value as! [String : AnyObject]
      dateRecieved = snapshotValue["dateRecieved"] as? String ?? "Unknown"
      eventDate = snapshotValue["eventDate"] as? String ?? "Unknown"
      eventName = snapshotValue["eventName"] as? String ?? "Unknown"
      friendFirstName = snapshotValue["friendFirstName"] as? String ?? "Unknown"
      friendLastName = snapshotValue["friendLastName"] as? String ?? "Unknown"
      giftStatus = snapshotValue["giftStatus"] as! String
      productImageUrl = snapshotValue["productImageUrl"] as? String ?? "Unknown"
      productName = snapshotValue["productName"] as? String ?? "Unknown"
      productPrice = snapshotValue["productPrice"] as? String ?? "Unknown"
      productUPCCode = snapshotValue["productUPCCode"] as? String ?? "Unknown"
      userID = snapshotValue["userID"] as? String
   }
   
   func toAnyObject() -> [String: Any] {
      return [
         "productID": productID as Any as AnyObject,
         "dateRecieved": dateRecieved! as String as AnyObject,
         "eventName": eventName! as String as AnyObject,
         "friendFirstName": friendFirstName! as String as AnyObject,
         "friendLastName": friendLastName! as String as AnyObject,
         "giftStatus": giftStatus as String as AnyObject,
         "productImageUrl": productImageUrl! as String as AnyObject,
         "productName": productName! as String as AnyObject,
         "productPrice" : productPrice! as String as AnyObject,
         "productUPCCode" : productUPCCode! as String as AnyObject,
         "userID" : userID! as String as AnyObject
      ]
   }
}
