//
//  UPCApi.swift
//  GiftTracker
//
//  Created by Yoon Yu on 1/30/17.
//  Copyright © 2017 Grace Yu. All rights reserved.
//

import Foundation

class UPCApi {
   static func parseUPCJson(data: Data, closure: @escaping ([Product?]) -> ()) {
      
      if let jsonObject = (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? [String: Any] {
         
         let productsJSON = jsonObject["items"] as! [[String: Any]]
         
         var products: [Product] = []
         
         for productJSON in productsJSON {
            let product = Product(jsonObject: productJSON)
            products.append(product)
         }
         
         DispatchQueue.main.async {
            closure(products)
         }
      }
   }

   static func fetchUPC(upc: String, closure: @escaping ([Product?]) -> ()) {
      
     // let upc = "673419267106"
      let url = URL(string: "https://api.upcitemdb.com/prod/trial/lookup?upc=\(upc)")!
      
      URLSession.shared.dataTask(with: url) { (data, _, _) in
         guard let responseData = data else {
            closure([nil])
            return
         }
         
         parseUPCJson(data: responseData, closure: closure)
         }.resume()
   }

}
