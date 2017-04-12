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
    
    fetchUser()
    
    collectionView?.backgroundColor = .white
    collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
    collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
    
    setupLogoutButton()
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
  
  private func setupLogoutButton() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear"), style: .plain, target: self, action: #selector(handleLogout))
  }
  
  func handleLogout() {
    let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    actionSheetController.addAction(UIAlertAction(title: "Log Out", style: .destructive) {
      [unowned self] _ in
      do {
        try FIRAuth.auth()?.signOut()
        let loginController = LoginController()
        let navController = UINavigationController(rootViewController: loginController)
        self.present(navController, animated: true, completion: nil)
      } catch let error {
        print("Failed to sign out: ", error)
      }
      print("Successfully signed out")
    })
    actionSheetController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
    present(actionSheetController, animated: true, completion: nil)
  }
  
  // MARK: - CollectionView
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 7
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
    cell.backgroundColor = UIColor(r: CGFloat(arc4random() % 255), g: CGFloat(arc4random() % 255), b: CGFloat(arc4random() % 255))
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeader
    header.user = user
    return header
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension UserProfileController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: view.frame.width, height: 200)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = (view.frame.width - 2) / 3
    
    return CGSize(width: width, height: width)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 1
  }
}
