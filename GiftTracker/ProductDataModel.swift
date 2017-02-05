//
//  ProductDataModel.swift
//  GiftTracker
//
//  Created by Yoon Yu on 2/4/17.
//  Copyright © 2017 Grace Yu. All rights reserved.
//

import Foundation
import Firebase

var ref: FIRDatabaseReference!

class ProductDataModel {
   static let shared = ProductDataModel()
   private init() {}
   
   func listenForProducts() {
      let products = FIRDatabase.database().reference(withPath: "products")
      products.observe(.value, with: didUpdateProducts)
   }
   
   func createProduct(dateRecieved: String, eventDate: String, eventName: String, friendFirstName: String, friendLastName: String, giftStatus: String, productImageUrl: String, productName: String, productPrice: String, productUPCCode: String, userID: String) {
      
      let productsRef = FIRDatabase.database().reference(withPath: "products")
      let product = Product(dateRecieved: dateRecieved, eventDate: eventDate, eventName: eventName, friendFirstName: friendFirstName, friendLastName: friendLastName, giftStatus: giftStatus, productImageUrl: productImageUrl, productName: productName, productPrice: productPrice, productUPCCode: productUPCCode, userID: userID)
      let productRef = productsRef.childByAutoId()
      productRef.setValue(product.toAnyObject())
   }
   
   func didUpdateProducts(snapshot: FIRDataSnapshot) {
      products.removeAll()
      for item in snapshot.children {
         let product = Product(snapshot: item as! FIRDataSnapshot)
         products.append(product)
      }
   }
   
   func deleteProduct(product: Product) {
      product.ref?.removeValue()
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
