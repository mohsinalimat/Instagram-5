//
//  Post.swift
//  Instagram Firebase
//
//  Created by Vyacheslav Nagornyak on 4/13/17.
//  Copyright © 2017 Vyacheslav Nagornyak. All rights reserved.
//

import Foundation

enum SerializationError: Error {
  case missing(String)
}

struct Post {
  let imageUrl: String
  let user: User
  let caption: String
  let creationDate: Date
  
  init?(with user: User, from dictionary: [String: Any]) throws {
    guard let imageUrl = dictionary["imageUrl"] as? String else {
      throw SerializationError.missing("missing imageUrl")
    }
    
    self.imageUrl = imageUrl
    self.user = user
    
    self.caption = dictionary["caption"] as? String ?? ""
    
    let seconds = dictionary["creationDate"] as? Double ?? 0
    self.creationDate = Date(timeIntervalSince1970: seconds)
  }
}
