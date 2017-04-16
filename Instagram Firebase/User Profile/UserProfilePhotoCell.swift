//
//  UserProfilePhotoCell.swift
//  Instagram Firebase
//
//  Created by Vyacheslav Nagornyak on 4/14/17.
//  Copyright © 2017 Vyacheslav Nagornyak. All rights reserved.
//

import UIKit

class UserProfilePhotoCell: PhotoCell {
  
  // MARK: - Variables
  var post: Post? {
    didSet {
      guard let imageUrl = post?.imageUrl else { return }
      imageView.loadImage(url: imageUrl)
    }
  }
}
