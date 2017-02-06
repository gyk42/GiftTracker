//
//  ListOfGiftsGivenViewController.swift
//  GiftTracker
//
//  Created by Yoon Yu on 2/5/17.
//  Copyright © 2017 Grace Yu. All rights reserved.
//

import UIKit
import Firebase

class ListOfGiftsGivenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
   
   var gifts = [Gift]()
   var ref: FIRDatabaseReference!
   static var userID = FIRAuth.auth()!.currentUser!.uid
   
   // MARK: IBOutlet --------------------------------------
   
   @IBOutlet weak var listOfGiftsGivenTableView: UITableView!
   
   // MARK: Life-Cycle  --------------------------------------
   
   override func viewDidLoad() {
      super.viewDidLoad()
      giftTableviewDisplay()
      listOfGiftsGivenTableView.reloadData()
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      listOfGiftsGivenTableView.reloadData()
   }
   
   // MARK: Tableview -------------------------------------
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return gifts.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "listOfGiftsGiven", for: indexPath) as! ListOfGiftsGivenTableViewCell
      let giftsInxdex = gifts[indexPath.row]
      
      // cell.ref = gifts[indexPath.row].ref!
      cell.giftNameLabel.text = giftsInxdex.giftName?.capitalized
      cell.giftPriceLabel.text = giftsInxdex.giftPrice
      cell.eventLabel.text = giftsInxdex.eventName?.capitalized
      cell.dateLabel.text = giftsInxdex.eventDate
      cell.friendFirstNameLabel.text = giftsInxdex.friendFirstName?.capitalized
      cell.giftImageView.downLoadImag(from: giftsInxdex.giftImageUrl!)
      
      return cell
   }
   
   /*
    let username = "SomeUser"
    
    FIRDatabase.database().reference.child("users").queryOrderedByChild("username").queryStartingAtValue(username).queryEndingAtValue(username).observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
    
    }
    
    */
   
   func giftTableviewDisplay() {
      let giftsRef = FIRDatabase.database().reference(withPath:"gifts")
//      giftsRef.queryOrdered(byChild: "userID").queryStarting(atValue: ListOfGiftsViewController.userID).queryEnding(atValue: <#T##Any?#>)
      let giftsQuery = giftsRef.queryOrdered(byChild: "userID").queryEqual(toValue: ListOfGiftsGivenViewController.userID)
      //let giftStatusRef = giftsQuery.queryOrdered(byChild: "giftStatus").queryEqual(toValue: "giving")
      
      giftsQuery.observeSingleEvent(of: .value, with: { (snapshot) in
         
         if snapshot.hasChildren(){
            self.gifts.removeAll()
            
            for gift in snapshot.children {
               let gift = Gift(snapshot: gift as! FIRDataSnapshot)
               self.gifts.append(gift)
               
            }

            DispatchQueue.main.async {
               self.listOfGiftsGivenTableView.reloadData()
            }
         }
      })
   }
}
