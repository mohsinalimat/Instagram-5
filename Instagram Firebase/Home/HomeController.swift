//
//  HomeController.swift
//  Instagram Firebase
//
//  Created by Vyacheslav Nagornyak on 4/15/17.
//  Copyright © 2017 Vyacheslav Nagornyak. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController {
  
  let cellId = "cellId"
  
  var posts = [Post]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView?.backgroundColor = .white
    
    collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
    
    setupNavigationItems()
    fetchPosts()
  }
  
  private func setupNavigationItems() {
    navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
  }
  
  private func fetchPosts() {
    guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
    
    FIRDatabase.database().reference().child("posts").child(uid).observeSingleEvent(of: .value, with: { [unowned self] (snapshop) in
      guard let dictionaries = snapshop.value as? [String: Any] else { return }
      
      dictionaries.forEach{
        key, value in
        guard let dictionary = value as? [String: Any] else { return }
        
        do {
          if let post = try Post(from: dictionary) {
            self.posts.append(post)
          }
        } catch let error {
          print("Failed to initialize post with error: ", error)
        }
      }
      
      self.collectionView?.reloadData()
    }) { (error) in
      print("Failed to fetch posts from db: ", error)
    }
  }
  
  /// MARK: - UICollectionView stuff
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return posts.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
    cell.post = posts[indexPath.row]
    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.width, height: 200)
  }
}
