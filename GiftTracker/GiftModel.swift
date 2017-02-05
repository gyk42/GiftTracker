//
//  GiftModel.swift
//  GiftTracker
//
//  Created by Yoon Yu on 2/5/17.
//  Copyright © 2017 Grace Yu. All rights reserved.
//

import Foundation
import Firebase

//var gifts = [Gift]()

class Gift {
   var giftID: String?
   var dateRecieved: String?
   var eventDate: String?
   var eventName: String?
   var friendFirstName: String?
   var friendLastName: String?
   var giftStatus: String
   var giftImageUrl: String?
   var giftName: String?
   var giftPrice: String?
   var giftUPCCode: String?
   var notes: String?
   var userID = FIRAuth.auth()?.currentUser?.uid
   var ref: FIRDatabaseReference?
   
   init(dateRecieved: String, eventDate: String, eventName: String, friendFirstName: String, friendLastName: String, giftStatus: String, giftImageUrl: String, giftName: String, giftPrice: String, giftUPCCode: String, notes: String, userID: String) {
      self.dateRecieved = dateRecieved
      self.eventDate = eventDate
      self.eventName = eventName
      self.friendFirstName = friendFirstName
      self.friendLastName = friendLastName
      self.giftStatus = giftStatus
      self.giftImageUrl = giftImageUrl
      self.giftName = giftName
      self.giftPrice = giftPrice
      self.giftUPCCode = giftUPCCode
      self.notes = notes
      self.userID = userID
   }
   
   init(snapshot: FIRDataSnapshot) {
      giftID = snapshot.key
      let snapshotValue = snapshot.value as! [String : AnyObject]
      dateRecieved = snapshotValue["dateRecieved"] as? String ?? "Unknown"
      eventDate = snapshotValue["eventDate"] as? String ?? "Unknown"
      eventName = snapshotValue["eventName"] as? String ?? "Unknown"
      friendFirstName = snapshotValue["friendFirstName"] as? String ?? "Unknown"
      friendLastName = snapshotValue["friendLastName"] as? String ?? "Unknown"
      giftStatus = snapshotValue["giftStatus"] as! String
      giftImageUrl = snapshotValue["giftImageUrl"] as? String ?? "Unknown"
      giftName = snapshotValue["giftName"] as? String ?? "Unknown"
      giftPrice = snapshotValue["giftPrice"] as? String ?? "Unknown"
      giftUPCCode = snapshotValue["giftUPCCode"] as? String ?? "Unknown"
      notes = snapshotValue["notes"] as? String ?? "Unknown"
      userID = snapshotValue["userID"] as? String
   }
   
   func toAnyObject() -> [String: Any] {
      return [
         "giftID": giftID as Any as AnyObject,
         "dateRecieved": dateRecieved! as String as AnyObject,
         "eventDate": eventDate! as String as AnyObject,
         "eventName": eventName! as String as AnyObject,
         "friendFirstName": friendFirstName! as String as AnyObject,
         "friendLastName": friendLastName! as String as AnyObject,
         "giftStatus": giftStatus as String as AnyObject,
         "giftImageUrl": giftImageUrl! as String as AnyObject,
         "giftName": giftName! as String as AnyObject,
         "giftPrice" : giftPrice! as String as AnyObject,
         "giftUPCCode" : giftUPCCode! as String as AnyObject,
         "notes" : notes! as String as AnyObject,
         "userID" : userID! as String as AnyObject
      ]
   }
}
