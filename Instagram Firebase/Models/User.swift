//
//  User.swift
//  Instagram Firebase
//
//  Created by Vyacheslav Nagornyak on 4/16/17.
//  Copyright © 2017 Vyacheslav Nagornyak. All rights reserved.
//

import Foundation

struct User {
  let uid: String
  let username: String
  let profileImageUrl: String
  
  init(with uid: String, and dictionary: [String: Any]) {
    self.uid = uid
    username = dictionary["username"] as? String ?? ""
    profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
  }
}
