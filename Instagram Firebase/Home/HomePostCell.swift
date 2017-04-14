//
//  HomePostCell.swift
//  Instagram Firebase
//
//  Created by Vyacheslav Nagornyak on 4/15/17.
//  Copyright © 2017 Vyacheslav Nagornyak. All rights reserved.
//

import UIKit

class HomePostCell: UICollectionViewCell {
  
  var post: Post? {
    didSet {
      guard let imageUrl = post?.imageUrl else { return }
      photoImageView.loadImage(url: imageUrl)
    }
  }
  
  let photoImageView: CustomImageView = {
    let iv = CustomImageView()
    iv.contentMode = .scaleAspectFill
    iv.clipsToBounds = true
    return iv
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(photoImageView)
    photoImageView.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
