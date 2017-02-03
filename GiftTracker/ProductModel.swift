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
   var title: String
   var imageUrl: String
   var price: Float
   
   init(jsonObject: [String : Any]) {
      title = jsonObject["title"] as? String ?? "Unknown"
      let imageUrls = jsonObject["images"] as? [String] ?? ["Unknown"]
      imageUrl = imageUrls[0]
      let offers = jsonObject["offers"] as? [[String : Any]] ?? [["Unknown" : "Unknown"]]
      let firstOffer = offers[0]
      price = (firstOffer["price"] as? Float!)!
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

