//
//  GiftUPCModel.swift
//  GiftTracker
//
//  Created by Yoon Yu on 1/30/17.
//  Copyright © 2017 Grace Yu. All rights reserved.
//

import Foundation

class GiftUPC {
   var giftName: String
   var giftImageUrl: String
   var giftPrice: Float
   
   init(jsonObject: [String : Any]) {
      giftName = jsonObject["title"] as? String ?? "Unknown"
      let imageUrls = jsonObject["images"] as? [String] ?? ["Unknown"]
      giftImageUrl = imageUrls[0]
      let offers = jsonObject["offers"] as? [[String : Any]] ?? [["Unknown" : "Unknown"]]
      let firstOffer = offers[0]
      giftPrice = (firstOffer["price"] as? Float!)!
   }
}


