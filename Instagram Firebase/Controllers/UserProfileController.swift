//
//  UserProfileController.swift
//  Instagram Firebase
//
//  Created by Vyacheslav Nagornyak on 4/6/17.
//  Copyright © 2017 Vyacheslav Nagornyak. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView?.backgroundColor = .white
    
    fetchUser()
  }
  
  private func fetchUser() {
    guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
    
    FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: {
      snapshot in
      guard let dictionary = snapshot.value as? [String: Any] else { return }
      guard let username = dictionary["username"] as? String else { return }
      self.navigationItem.title = username
    }, withCancel: {
      error in
      print("Failed to fetch user: ", error)
    })
  }
}
