//
//  ProductModel.swift
//  GiftTracker
//
//  Created by Yoon Yu on 1/30/17.
//  Copyright © 2017 Grace Yu. All rights reserved.
//

import Foundation

class Product {
   var title: String
   var image: String
//   var price: Float
   
   init(jsonObject: [String : Any]) {
      title = jsonObject["title"] as? String ?? "Unknown"
      image = jsonObject["images"] as? String ?? "Unknown"
//      jsonObject["offers"] as? [String : Any] ?? ["Unknown" : "Unknown"]
   }
}


