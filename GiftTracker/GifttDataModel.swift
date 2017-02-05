//
//  GiftDataModel.swift
//  GiftTracker
//
//  Created by Yoon Yu on 2/4/17.
//  Copyright © 2017 Grace Yu. All rights reserved.
//

import Foundation
import Firebase

var ref: FIRDatabaseReference!

class GiftDataModel {
   static let shared = GiftDataModel()
   private init() {}
   
   func listenForGifts() {
      let gifts = FIRDatabase.database().reference(withPath: "gifts")
      gifts.observe(.value, with: didUpdateGifts)
   }
   
   func createGift(dateRecieved: String, eventDate: String, eventName: String, friendFirstName: String, friendLastName: String, giftStatus: String, giftImageUrl: String, giftName: String, giftPrice: String, giftUPCCode: String, notes: String, userID: String) {
      
      let giftsRef = FIRDatabase.database().reference(withPath: "gifts")
      let gift = Gift(dateRecieved: dateRecieved, eventDate: eventDate, eventName: eventName, friendFirstName: friendFirstName, friendLastName: friendLastName, giftStatus: giftStatus, giftImageUrl: giftImageUrl, giftName: giftName, giftPrice: giftPrice, giftUPCCode: giftUPCCode, notes: notes, userID: userID)
      let giftRef = giftsRef.childByAutoId()
      giftRef.setValue(gift.toAnyObject())
   }
   
   func didUpdateGifts(snapshot: FIRDataSnapshot) {
      gifts.removeAll()
      for item in snapshot.children {
         let gift = Gift(snapshot: item as! FIRDataSnapshot)
         gifts.append(gift)
      }
   }
   
   func deleteGift(gift: Gift) {
      gift.ref?.removeValue()
   }

}

class Format {
   static let shared = Format()
   let dateFormatter = DateFormatter()
  
   private init() {
      dateFormatter.dateStyle = .long
      dateFormatter.timeStyle = .long
   }
}
