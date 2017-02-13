//
//  StyleModel.swift
//  GiftTracker
//
//  Created by Yoon Yu on 2/9/17.
//  Copyright © 2017 Grace Yu. All rights reserved.
//

import Foundation
import UIKit

// Stying buttons globally so that it's consistent
class StyleModel {
   static let shared = StyleModel()
   private init() {}
   
   func styleButtons(buttonName: UIButton) {
      buttonName.layer.cornerRadius = 8
      buttonName.layer.borderWidth = 1.5
      buttonName.layer.borderColor = UIColor.lightGray.cgColor
   }
}
