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
  
  // MARK: - UI
  let searchBar: UISearchBar = {
    let sb = UISearchBar()
    sb.placeholder = "Enter username"
    sb.barTintColor = .gray
    UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
    return sb
  }()
  
  // MARK: - Functions
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView?.backgroundColor = .white
    collectionView?.register(UserSearchCell.self, forCellWithReuseIdentifier: cellId)
    collectionView?.alwaysBounceVertical = true
    
    navigationController?.navigationBar.addSubview(searchBar)
    
    let navBar = navigationController?.navigationBar
    searchBar.anchor(top: navBar?.topAnchor, leading: navBar?.leadingAnchor, trailing: navBar?.trailingAnchor, bottom: navBar?.bottomAnchor, leadingConstant: 8, trailingConstant: 8)
  }
}

// MARK: - UICollectionViewController
extension UserSearchController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 5
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserSearchCell
    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension UserSearchController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.width, height: 66)
  }
}
