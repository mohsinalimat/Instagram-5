//
//  UserProfileController.swift
//  Instagram Firebase
//
//  Created by Vyacheslav Nagornyak on 4/6/17.
//  Copyright © 2017 Vyacheslav Nagornyak. All rights reserved.
//

import UIKit
import Firebase

struct User {
  let username: String
  let profileImageUrl: String
  
  init(with dictionary: [String: Any]) {
    username = dictionary["username"] as? String ?? ""
    profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
  }
}

class UserProfileController: UICollectionViewController {
  
  var user: User?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView?.backgroundColor = .white
    collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
    
    fetchUser()
  }
  
  private func fetchUser() {
    guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
    
    FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: {
      [unowned self] snapshot in
      guard let dictionary = snapshot.value as? [String: Any] else { return }
      self.user = User(with: dictionary)
      self.navigationItem.title = self.user?.username
      self.collectionView?.reloadData()
    }, withCancel: {
      error in
      print("Failed to fetch user: ", error)
    })
  }
  
  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeader
    header.user = user
    return header
  }
}

extension UserProfileController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: view.frame.width, height: 200)
  }
}
