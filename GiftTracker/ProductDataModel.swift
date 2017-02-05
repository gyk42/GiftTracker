//
//  ProductDataModel.swift
//  GiftTracker
//
//  Created by Yoon Yu on 2/4/17.
//  Copyright © 2017 Grace Yu. All rights reserved.
//

import Foundation

class ProductDataModel {
   static let shared = ProductDataModel()
   private init() {}
   
}

class Format {
   static let shared = Format()
   let dateFormatter = DateFormatter()
  
   private init() {
      dateFormatter.dateStyle = .long
      dateFormatter.timeStyle = .long
   }
}
