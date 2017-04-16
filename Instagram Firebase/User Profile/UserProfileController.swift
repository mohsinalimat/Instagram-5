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
  
  var user: User?
  var posts = [Post]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    fetchUser()
    
    collectionView?.backgroundColor = .white
    collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
    collectionView?.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: "cellId")
    
    setupLogoutButton()
    
    fetchOrderedPosts()
  }
  
  private func fetchUser() {
    guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
    
    FIRDatabase.fetchUser(with: uid) { (user) in
      self.user = user
      self.navigationItem.title = self.user?.username
      self.collectionView?.reloadData()
    }
  }
  
  private func fetchOrderedPosts() {
    guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
    
    let ref = FIRDatabase.database().reference().child("posts").child(uid)
    ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { [unowned self] (snapshot) in
      guard let dictionary = snapshot.value as? [String: Any],
        let user = self.user else { return }
      
      do {
        if let post = try Post(with: user, from: dictionary) {
          self.posts.insert(post, at: 0)
        }
        
        self.collectionView?.reloadData()
      } catch let error {
        print("Failed to initialize Post: ", error)
      }
    }) { (error) in
      print("Failed to fetch ordered posts: ", error)
    }
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
    return posts.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! UserProfilePhotoCell
    cell.post = posts[indexPath.row]
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
