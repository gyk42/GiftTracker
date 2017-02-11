//
//  HomeViewController.swift
//  GiftTracker
//
//  Created by Yoon Yu on 1/30/17.
//  Copyright © 2017 Grace Yu. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
   var gifts = [Gift]()
   var ref: FIRDatabaseReference!
   var userID = FIRAuth.auth()!.currentUser!.uid
   var isGiving:Bool = true
   var source = "giving"  // Default
   
   
   // MARK: IBOutlet --------------------------------------
   
   @IBOutlet weak var giftStatus: UISegmentedControl!
   @IBOutlet weak var listOfGiftsTableView: UITableView!
   @IBOutlet weak var spinnerOutlet: UIActivityIndicatorView!
   
   // MARK: Life-Cycle  ------------------------------------
   
   override func viewDidLoad() {
      super.viewDidLoad()

      giftTableviewDisplay()
      customizeNavigation()
      print(userID)
      listOfGiftsTableView.reloadData()
   }
   
   // MARK: Navigation controller related functions
   
   func customizeNavigation() {
      // Set the title via VC because issues with embed navigation controller
      self.title = "Gift Recorder"
      
      // Set the image for logout and adds action to it
      navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"logout"), style: .plain, target: self, action:#selector(menuButtonTapped))
   }
   
   func menuButtonTapped() {
      // Logs out user by singleton
      UserDataModel.shared.logout()
      
      // Redirect as user signouts to login VC
      navigationController?.performSegue(withIdentifier: "toLogin", sender: self)
   }
   
   // MARK: Tableview related functions ------------------------
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return gifts.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "listOfGifts", for: indexPath) as! HomeTableViewCell
      let giftsIndex = gifts[indexPath.row]
      
      cell.giftNameLabel.text = giftsIndex.giftName?.capitalized
      cell.giftPriceLabel.text = giftsIndex.giftPrice
      cell.eventLabel.text = giftsIndex.eventName?.capitalized
      cell.dateLabel.text = giftsIndex.eventDate
      cell.friendFirstNameLabel.text = giftsIndex.friendFirstName?.capitalized
      cell.giftImageView.downLoadImag(from: giftsIndex.giftImageUrl!)
      
      // Checks what db to see if gift was received or giving.. and it displays label accordingly
      if giftsIndex.giftStatus == "giving" {
         cell.toFromLabel.text = "Giving to"
      } else {
         cell.toFromLabel.text = "Received from"
      }
      return cell
   }
   
   // Performs segue into next view controller
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      performSegue(withIdentifier: "toDetail", sender: self)
   }
   
   // Prepare segue to pass in selected item to next view controller
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "toDetail" {
         let vc = segue.destination as! DetailGiftViewController
         let indexPath = listOfGiftsTableView.indexPathForSelectedRow!
         vc.gift = gifts[indexPath.row]
      }
   }
   
   // MARK: Function calls -------------------------------------
   
   // Firebase call for gifts that has a matching userID with current user
   func giftTableviewDisplay() {
      let giftsRef = FIRDatabase.database().reference(withPath:"gifts")
      let giftsQuery = giftsRef.queryOrdered(byChild: "userID").queryEqual(toValue: userID)

      giftsQuery.observeSingleEvent(of: .value, with: { (snapshot) in
         
         if snapshot.hasChildren(){
            self.gifts.removeAll()
            
            for gift in snapshot.children {
               
               // Checks if gift status is giving or received
               if let firGiftStatusSnapshot = gift as? FIRDataSnapshot {
                  let giftStatusSnapshot = firGiftStatusSnapshot.childSnapshot(forPath: "giftStatus").value!
                  
                  // Source param passes in from segmented control
                  if giftStatusSnapshot as! String == self.source {
                     print(self.source)
                     let gift = Gift(snapshot: gift as! FIRDataSnapshot)
                     self.gifts.append(gift)
                  }
               }
            }
            
            DispatchQueue.main.async {
               self.listOfGiftsTableView.reloadData()
            }
         }
      })
      
   }
   
   // MARK: IBAction -------------------------------------
   
   // Segmented control to toggle between giving and received for source variable
   @IBAction func giftStatusChanged(_ sender: UISegmentedControl) {
      
      // Toggles isGiving to true or false
      isGiving = !isGiving
      source = isGiving ? "giving" : "received"
      giftTableviewDisplay()
   }
}
