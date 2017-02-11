//
//  Extention.swift
//  GiftTracker
//
//  Created by Yoon Yu on 1/30/17.
//  Copyright © 2017 Grace Yu. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
   func downLoadImag(from url: String) {
      let urlRequest = URLRequest(url: URL(string: url)!)
      let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
         guard let data = data, error == nil else { return }
         
         DispatchQueue.main.async {
            self.image = UIImage(data: data)
         }
      }
      task.resume()
   }
}

extension Date {
   func format() -> String {
      return Format.shared.dateFormatter.string(from: self)
   }
}

extension UITextField {
   class func connectFields(fields:[UITextField]) -> Void {
      guard let last = fields.last else {
         return
      }
      for i in 0 ..< fields.count - 1 {
         fields[i].returnKeyType = .next
         fields[i].addTarget(fields[i+1], action: #selector(UIResponder.becomeFirstResponder), for: .editingDidEndOnExit)
      }
      last.returnKeyType = .go
      last.addTarget(last, action: #selector(UIResponder.resignFirstResponder), for: .editingDidEndOnExit)
   }
}
