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
  
  // MARK: - Literals
  let cellId = "cellId"
  
  // MARK: - Variables
  var posts = [Post]()
  var filteredPosts: [Post] {
    return posts.sorted { $0.creationDate.compare($1.creationDate) == .orderedDescending }
  }
  
  // MARK: - Handlers
  func handleRefresh() {
    posts.removeAll()
    fetchPosts()
  }
  
  // MARK: - Functions
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView?.backgroundColor = .white
    
    collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
    
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    collectionView?.refreshControl = refreshControl
    
    let name = Notification.Name(rawValue: "updateFeed")
    NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil) { (_) in
      self.handleRefresh()
    }
    
    setupNavigationItems()
    fetchPosts()
  }
  
  private func setupNavigationItems() {
    navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
  }
  
  private func fetchPosts() {
    guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
    
    FIRDatabase.database().reference().child("following").child(uid).observeSingleEvent(of: .value, with: { [unowned self] (snapshot) in
      guard let userDictionaries = snapshot.value as? [String: Any] else { return }
      
      userDictionaries.forEach { (key, value) in
        FIRDatabase.fetchUser(with: key) { [unowned self] (user) in
          self.fetchPosts(for: user)
        }
      }
    }) { (error) in
      print("Failed to fetch following users", error)
    }
  }
  
  private func fetchPosts(for user: User) {
    FIRDatabase.database().reference().child("posts").child(user.uid).observeSingleEvent(of: .value, with: { [unowned self] (snapshop) in
      guard let dictionaries = snapshop.value as? [String: Any] else { return }
      
      dictionaries.forEach { (key, value) in
        guard let dictionary = value as? [String: Any] else { return }
        
        do {
          if let post = try Post(with: user, from: dictionary) {
            self.posts.append(post)
          }
        } catch let error {
          print("Failed to initialize post with error:", error)
        }
      }
      
      self.collectionView?.reloadData()
      self.collectionView?.refreshControl?.endRefreshing()
    }) { (error) in
      print("Failed to fetch posts from db:", error)
    }
  }
}

// MARK: - UICollectionViewController
extension HomeController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return filteredPosts.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
    cell.post = filteredPosts[indexPath.row]
    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    var height: CGFloat = 40 + 8 + 8 //header of cell
    height += view.frame.width // image
    height += 50 // bottom buttons
    height += 60 // caption
    
    return CGSize(width: view.frame.width, height: height)
  }
}
