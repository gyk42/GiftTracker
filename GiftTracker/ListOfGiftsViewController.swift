//
//  ListOfGiftsViewController.swift
//  GiftTracker
//
//  Created by Yoon Yu on 1/30/17.
//  Copyright © 2017 Grace Yu. All rights reserved.
//

import UIKit

class ListOfGiftsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
   var productsUPC = [ProductUPC]()
   
   @IBOutlet weak var listOfGiftsTableView: UITableView!
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return productsUPC.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "listOfGifts", for: indexPath) as! ListOfGiftsTableViewCell
      
      let prdIndexRow = productsUPC[indexPath.row]
      let prdPrice = String(format: "%.2f", prdIndexRow.productPrice)
      
      cell.productNameLabel.text = prdIndexRow.productName
      cell.productImageView.downLoadImag(from: prdIndexRow.productImageUrl)
      cell.productPriceLabel.text = prdPrice
      
      return cell
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
// TODO: Need to guard the UPC code so that app doesn't crash when item is not in the API
      
      UPCApi.fetchUPC(upc: "9780545362580", closure: { data in
         self.productsUPC = data as! [ProductUPC]
         self.listOfGiftsTableView.reloadData()
      })
      
      listOfGiftsTableView.reloadData()
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      listOfGiftsTableView.reloadData()
   }
}
