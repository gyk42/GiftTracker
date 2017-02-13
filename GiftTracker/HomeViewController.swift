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
   
   var ref: FIRDatabaseReference!
   var userID = FIRAuth.auth()!.currentUser!.uid
   var isGiving:Bool = true
   var source = "giving"  // Default
   var gifts = [Gift]()
   var filterGifts:[Gift] = []
   var searchController = UISearchController(searchResultsController: nil)
   
   // MARK: IBOutlet --------------------------------------
   
   @IBOutlet weak var giftStatus: UISegmentedControl!
   @IBOutlet weak var listOfGiftsTableView: UITableView!
   @IBOutlet weak var spinnerOutlet: UIActivityIndicatorView!
   
   // MARK: Life-Cycle  ------------------------------------
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      giftTableviewDisplay()
      customizeNavigation()
      setSearchBar()
      listOfGiftsTableView.reloadData()
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      self.listOfGiftsTableView.reloadData()
   }
   
   override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      self.listOfGiftsTableView.reloadData()
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
   
   // MARK: Serach bar
   
   // View did load search settings
   func setSearchBar() {
      searchController.searchResultsUpdater = self
      searchController.dimsBackgroundDuringPresentation = false
      definesPresentationContext = true
      listOfGiftsTableView.tableHeaderView = searchController.searchBar
   }
   
   // Filtering of serach with friend's name
   func filterContentSearch(searchext: String, scoope: String = "All"){
      filterGifts = gifts.filter({ (name) -> Bool in
         return (name.friendFirstName?.lowercased().contains(searchext.lowercased()))!
      })
      listOfGiftsTableView.reloadData()
   }
   
   // Adding text into search bar
   func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      filterGifts = gifts.filter({ (gifts) -> Bool in
         return (gifts.friendFirstName?.lowercased().contains(searchText.lowercased()))!
      })
      self.listOfGiftsTableView.reloadData()
   }
   
   // MARK: Tableview related functions ------------------------
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      if searchController.isActive && searchController.searchBar.text != "" {
         return filterGifts.count
      }
      return gifts.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "listOfGifts", for: indexPath) as! HomeTableViewCell
      
      let giftsIndex: Gift
      
      if searchController.isActive && searchController.searchBar.text != "" {
         giftsIndex = filterGifts[indexPath.row]
      } else {
         giftsIndex  = gifts[indexPath.row]
      }
      
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
         if searchController.isActive && searchController.searchBar.text != "" {
            vc.gift = filterGifts[indexPath.row]
            searchController.searchBar.text = ""
         } else {
            vc.gift  = gifts[indexPath.row]
         }
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

//MARK: extension
extension HomeViewController: UISearchResultsUpdating {
   @available(iOS 8.0, *)
   public func updateSearchResults(for searchController: UISearchController) {
      filterContentSearch(searchext: searchController.searchBar.text!)
   }
}
