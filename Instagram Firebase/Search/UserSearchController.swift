//
//  MainTabBarController.swift
//  Instagram Firebase
//
//  Created by Vyacheslav Nagornyak on 4/16/17.
//  Copyright © 2017 Vyacheslav Nagornyak. All rights reserved.
//

import UIKit
import Firebase

class UserSearchController: UICollectionViewController {
  
  // MARK: - Literals
  let cellId = "cellId"
  
  // MARK: - Variables
  var users = [User]()
  var filteredUsers = [User]()
  
  // MARK: - UI
  lazy var searchBar: UISearchBar = {
    let sb = UISearchBar()
    sb.placeholder = "Enter username"
    sb.barTintColor = .gray
    UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
    sb.delegate = self
    return sb
  }()
  
  // MARK: - Functions
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView?.backgroundColor = .white
    collectionView?.register(UserSearchCell.self, forCellWithReuseIdentifier: cellId)
    collectionView?.alwaysBounceVertical = true
    collectionView?.keyboardDismissMode = .onDrag
    
    navigationController?.navigationBar.addSubview(searchBar)
    
    let navBar = navigationController?.navigationBar
    searchBar.anchor(top: navBar?.topAnchor, leading: navBar?.leadingAnchor, trailing: navBar?.trailingAnchor, bottom: navBar?.bottomAnchor, leadingConstant: 8, trailingConstant: 8)
    
    fetchUsers()
  }
  
  private func fetchUsers() {
    FIRDatabase.database().reference().child("users").observeSingleEvent(of: .value, with: { [unowned self] (snapshot) in
      guard let dictionaries = snapshot.value as? [String: Any] else { return }
      
      dictionaries.forEach { (key, value) in
        guard let userDictionary = value as? [String: Any] else { return }
        
        let user = User(with: key, and: userDictionary)
        self.users.append(user)
      }
      
      self.users.sort{ $0.username.compare($1.username) == .orderedAscending }
      
      self.filteredUsers = self.users
      self.collectionView?.reloadData()
    }) { (error) in
      print("Failed to fetch users for search:", error)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    searchBar.isHidden = false
  }
}

// MARK: - UICollectionViewController
extension UserSearchController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return filteredUsers.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserSearchCell
    cell.user = filteredUsers[indexPath.row]
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    searchBar.isHidden = true
    searchBar.resignFirstResponder()
    
    let user = filteredUsers[indexPath.row]
    
    let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
    userProfileController.userId = user.uid
    navigationController?.pushViewController(userProfileController, animated: true)
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension UserSearchController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.width, height: 66)
  }
}

// MARK: - UISearchBarDelegate
extension UserSearchController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText.isEmpty {
      filteredUsers = users
    } else {
      filteredUsers = users.filter { (user) -> Bool in
        return user.username.lowercased().contains(searchText.lowercased())
      }
    }
    
    collectionView?.reloadData()
  }
}
