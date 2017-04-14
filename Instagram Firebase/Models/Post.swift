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
  
  init?(from dictionary: [String: Any]) throws {
    guard let imageUrl = dictionary["imageUrl"] as? String else { throw SerializationError.missing("missing imageUrl") }
    
    self.imageUrl = imageUrl
  }
}