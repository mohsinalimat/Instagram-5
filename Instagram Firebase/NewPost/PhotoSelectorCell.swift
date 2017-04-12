//
//  PhotoSelectorCell.swift
//  Instagram Firebase
//
//  Created by Vyacheslav Nagornyak on 4/13/17.
//  Copyright © 2017 Vyacheslav Nagornyak. All rights reserved.
//

import UIKit

class PhotoSelectorCell: UICollectionViewCell {
  
  let imageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFill
    iv.clipsToBounds = true
    return iv;
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(imageView)
    imageView.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
