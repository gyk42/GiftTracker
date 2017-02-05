//
//  UPCApi.swift
//  GiftTracker
//
//  Created by Yoon Yu on 1/30/17.
//  Copyright © 2017 Grace Yu. All rights reserved.
//

import Foundation

class UPCApi {
   static func parseUPCJson(data: Data, closure: @escaping ([GiftUPC?]) -> ()) {
      
      if let jsonObject = (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? [String: Any] {
         
         let giftsJSON = jsonObject["items"] as! [[String: Any]]
         
         var giftsUPC: [GiftUPC] = []
         
         for giftJSON in giftsJSON {
            let giftUPC = GiftUPC(jsonObject: giftJSON)
            giftsUPC.append(giftUPC)
         }
         
         DispatchQueue.main.async {
            closure(giftsUPC)
         }
      }
   }

   static func fetchUPC(upc: String, closure: @escaping ([GiftUPC?]) -> ()) {
      
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
