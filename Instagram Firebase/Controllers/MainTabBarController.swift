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
    let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
    let navigationController = UINavigationController(rootViewController: userProfileController)
    navigationController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
    navigationController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
    
    tabBar.tintColor = .black
    
    viewControllers = [navigationController, UIViewController()]
  }
}
