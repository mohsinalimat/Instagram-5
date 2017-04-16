//
//  FirebaseUtils.swift
//  Instagram Firebase
//
//  Created by Vyacheslav Nagornyak on 4/16/17.
//  Copyright © 2017 Vyacheslav Nagornyak. All rights reserved.
//

import Foundation
import Firebase

extension FIRDatabase {
  class func fetchUser(with uid: String, completion: @escaping (User) -> ()) {
    FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
      guard let userDictionaty = snapshot.value as? [String: Any] else { return }
      
      let user = User(with: uid, and: userDictionaty)
      
      completion(user)
    }) { (error) in
      print("Failed to fetch user: ", error)
    }
  }
}
