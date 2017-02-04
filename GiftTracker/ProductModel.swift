//
//  ProductModel.swift
//  GiftTracker
//
//  Created by Yoon Yu on 1/30/17.
//  Copyright © 2017 Grace Yu. All rights reserved.
//

import Foundation

enum GiftTarget: String {
   case to = "To"
   case from = "From"
}

class ProductUPC {
   var productName: String
   var productImageUrl: String
   var productPrice: Float
   
   init(jsonObject: [String : Any]) {
      productName = jsonObject["title"] as? String ?? "Unknown"
      let imageUrls = jsonObject["images"] as? [String] ?? ["Unknown"]
      productImageUrl = imageUrls[0]
      let offers = jsonObject["offers"] as? [[String : Any]] ?? [["Unknown" : "Unknown"]]
      let firstOffer = offers[0]
      productPrice = (firstOffer["price"] as? Float!)!
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

