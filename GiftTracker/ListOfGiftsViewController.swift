//
//  ListOfGiftsViewController.swift
//  GiftTracker
//
//  Created by Yoon Yu on 1/30/17.
//  Copyright © 2017 Grace Yu. All rights reserved.
//

import UIKit
import Firebase

class ListOfGiftsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
   var gifts = [Gift]()
   var ref: FIRDatabaseReference!
   static var userID = FIRAuth.auth()!.currentUser!.uid
   
   // MARK: IBOutlet --------------------------------------
   
   @IBOutlet weak var listOfGiftsTableView: UITableView!
   
   // MARK: Life-Cycle  --------------------------------------
   
   override func viewDidLoad() {
      super.viewDidLoad()
      giftTableviewDisplay()
      listOfGiftsTableView.reloadData()
   }
   
   // MARK: Tableview -------------------------------------
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return gifts.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "listOfGifts", for: indexPath) as! ListOfGiftsTableViewCell
      let giftsInxdex = gifts[indexPath.row]
      
     // cell.ref = gifts[indexPath.row].ref!
      cell.giftNameLabel.text = giftsInxdex.giftName?.capitalized
      cell.giftPriceLabel.text = giftsInxdex.giftPrice
      cell.eventLabel.text = giftsInxdex.eventName?.capitalized
      cell.dateLabel.text = giftsInxdex.eventDate
      cell.friendFirstNameLabel.text = giftsInxdex.friendFirstName?.capitalized
      cell.giftImageView.downLoadImag(from: giftsInxdex.giftImageUrl!)
      
      // checks what db to see if gift was received or giving.. and it displays label accordingly
      if giftsInxdex.giftStatus == "received" {
         cell.toFromLabel.text = "From"
      } else {
         cell.toFromLabel.text = "To"
      }
      return cell
   }
   
   func giftTableviewDisplay() {
      let giftsRef = FIRDatabase.database().reference(withPath:"gifts")
      let giftsQuery = giftsRef.queryOrdered(byChild: "userID").queryEqual(toValue: ListOfGiftsViewController.userID)
      
      giftsQuery.observeSingleEvent(of: .value, with: { (snapshot) in
         self.gifts.removeAll()
         
         for gift in snapshot.children {
            let gift = Gift(snapshot: gift as! FIRDataSnapshot)
            self.gifts.append(gift)
            print(gift)
         }
         
         DispatchQueue.main.async {
            self.listOfGiftsTableView.reloadData()
         }
      })
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      listOfGiftsTableView.reloadData()
   }
}
