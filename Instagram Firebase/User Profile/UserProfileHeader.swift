//
//  UserProfileHeader.swift
//  Instagram Firebase
//
//  Created by Vyacheslav Nagornyak on 4/6/17.
//  Copyright © 2017 Vyacheslav Nagornyak. All rights reserved.
//

import UIKit
import Firebase

class UserProfileHeader: UICollectionViewCell {
  
  var user: User? {
    didSet {
      setupProfileImage()
    }
  }
  
  let profileImageView: UIImageView = {
    let imageView = UIImageView()
    return imageView
  }()
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(profileImageView)
    
    let profileImageHeight: CGFloat = 80
    profileImageView.anchor(top: topAnchor, leading: leadingAnchor, width: profileImageView.heightAnchor, topConstant: 12, leadingConstant: 12, heightConstant: profileImageHeight)
    profileImageView.layer.cornerRadius = profileImageHeight * 0.5
    profileImageView.clipsToBounds = true
  }
  
  private func setupProfileImage() {
    guard let profileImageUrl = user?.profileImageUrl else { return }
    guard let url = URL(string: profileImageUrl) else { return }
    
    URLSession.shared.dataTask(with: url) {
      [unowned self] data, response, error in
      if let data = data {
        let image = UIImage(data: data)
        DispatchQueue.main.async {
          self.profileImageView.image = image
        }
      }
    }.resume()
  }
}
