//
//  UserSearchCell.swift
//  Instagram Firebase
//
//  Created by Vyacheslav Nagornyak on 4/17/17.
//  Copyright © 2017 Vyacheslav Nagornyak. All rights reserved.
//

import UIKit

class UserSearchCell: UICollectionViewCell {
  
  // MARK: - Variables
  var user: User? {
    didSet {
      guard let imageUrl = user?.profileImageUrl,
        let username = user?.username else { return }
      
      profileImageView.loadImage(url: imageUrl)
      usernameLabel.text = username
    }
  }
  
  // MARK: - UI
  let profileImageView: CustomImageView = {
    let iv = CustomImageView()
    iv.contentMode = .scaleAspectFill
    iv.clipsToBounds = true
    return iv
  }()
  
  let usernameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 14)
    label.text = "username"
    return label
  }()
  
  // MARK: - Initializers
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(profileImageView)
    addSubview(usernameLabel)
    
    profileImageView.anchor(leading: leadingAnchor, centerY: centerYAnchor, height: profileImageView.widthAnchor, leadingConstant: 8, widthConstant: 50)
    
    usernameLabel.anchor(top: topAnchor, leading: profileImageView.trailingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, leadingConstant: 8)
    
    let separatorView = UIView()
    separatorView.backgroundColor = UIColor(white: 0, alpha: 0.5)
    addSubview(separatorView)
    separatorView.anchor(leading: usernameLabel.leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, heightConstant: 0.5)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    profileImageView.layer.cornerRadius = 25
  }
}
