//
//  ListOfGiftsViewController.swift
//  GiftTracker
//
//  Created by Yoon Yu on 1/30/17.
//  Copyright © 2017 Grace Yu. All rights reserved.
//

import UIKit

class ListOfGiftsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
   var products = [Product]()
   
   @IBOutlet weak var listOfGiftsTableView: UITableView!
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return products.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "listOfGifts", for: indexPath) as! ListOfGiftsTableViewCell
      
      let prdIndexRow = products[indexPath.row]
      let prdPrice = String(format: "%.2f", prdIndexRow.price)
      
      cell.productNameLabel.text = prdIndexRow.title
      cell.productImageView.downLoadImag(from: prdIndexRow.imageUrl)
      cell.productPriceLabel.text = prdPrice
      
      return cell
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      UPCApi.fetchUPC(upc: "673419267106", closure: { data in
         self.products = data as! [Product]
         self.listOfGiftsTableView.reloadData()
      })
      
      listOfGiftsTableView.reloadData()
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      listOfGiftsTableView.reloadData()
   }
}
