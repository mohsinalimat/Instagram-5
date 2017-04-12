//
//  MainTabBarController.swift
//  Instagram Firebase
//
//  Created by Vyacheslav Nagornyak on 4/6/17.
//  Copyright © 2017 Vyacheslav Nagornyak. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if FIRAuth.auth()?.currentUser == nil {
      DispatchQueue.main.async {
        [unowned self] in
        let loginController = LoginController()
        let navController = UINavigationController(rootViewController: loginController)
        self.present(navController, animated: false, completion: nil)
      }
      return
    }
    
    setupViewControllers()
  }
  
  func setupViewControllers() {
    let homeNavController = templateNavController(for: UserProfileController(collectionViewLayout: UICollectionViewFlowLayout()), selectedImage: #imageLiteral(resourceName: "home_selected"), unselectedImage: #imageLiteral(resourceName: "home_unselected"))
    let searchNavController = templateNavController(for: UIViewController(), selectedImage: #imageLiteral(resourceName: "search_selected"), unselectedImage: #imageLiteral(resourceName: "search_unselected"))
    let plusNavController = templateNavController(for: UIViewController(), selectedImage: #imageLiteral(resourceName: "plus_unselected"), unselectedImage: #imageLiteral(resourceName: "plus_unselected"))
    let likeNavController = templateNavController(for: UIViewController(), selectedImage: #imageLiteral(resourceName: "like_selected"), unselectedImage: #imageLiteral(resourceName: "like_unselected"))
    let userProfileNavController = templateNavController(for: UserProfileController(collectionViewLayout: UICollectionViewFlowLayout()), selectedImage: #imageLiteral(resourceName: "profile_selected"), unselectedImage: #imageLiteral(resourceName: "profile_unselected"))
    
    tabBar.tintColor = .black
    
    viewControllers = [
      homeNavController,
      searchNavController,
      plusNavController,
      likeNavController,
      userProfileNavController
    ]
    
    // Tab bar button insets
    if let items = tabBar.items {
      for item in items {
        item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
      }
    }
  }
  
  private func templateNavController<VC: UIViewController>(for viewController: VC, selectedImage: UIImage, unselectedImage: UIImage) -> UINavigationController {
    let navController = UINavigationController(rootViewController: viewController)
    navController.tabBarItem.image = unselectedImage
    navController.tabBarItem.selectedImage = selectedImage
    return navController
  }
}
