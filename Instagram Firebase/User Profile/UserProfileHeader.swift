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
      usernameLabel.text = user?.username
    }
  }
  
  let profileImageView: UIImageView = {
    let imageView = UIImageView()
    return imageView
  }()
  
  let postsLabel: UILabel = {
    let label = UILabel()
    let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
    attributedText.append(NSAttributedString(string: "posts", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.lightGray]))
    label.attributedText = attributedText
    label.textAlignment = .center
    label.numberOfLines = 2
    return label
  }()
  
  let followersLabel: UILabel = {
    let label = UILabel()
    let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
    attributedText.append(NSAttributedString(string: "followers", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.lightGray]))
    label.attributedText = attributedText
    label.textAlignment = .center
    label.numberOfLines = 2
    return label
  }()
  
  let followingLabel: UILabel = {
    let label = UILabel()
    let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
    attributedText.append(NSAttributedString(string: "following", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.lightGray]))
    label.attributedText = attributedText
    label.textAlignment = .center
    label.numberOfLines = 2
    return label
  }()
  
  let editProfileButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Edit Profile", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    button.layer.borderColor = UIColor.lightGray.cgColor
    button.layer.borderWidth = 0.5
    button.layer.cornerRadius = 4
    return button
  }()
  
  let usernameLabel: UILabel = {
    let label = UILabel()
    label.text = "username"
    label.font = UIFont.boldSystemFont(ofSize: 14)
    return label
  }()
  
  let gridButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
    button.tintColor = UIColor(white: 0, alpha: 0.2)
    return button
  }()
  
  let listButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
    button.tintColor = UIColor(white: 0, alpha: 0.2)
    return button
  }()
  
  let bookmarkButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
    button.tintColor = UIColor(white: 0, alpha: 0.2)
    return button
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
    
    let statsView = setupUserStats()
    
    addSubview(editProfileButton)
    editProfileButton.anchor(top: postsLabel.bottomAnchor, leading: statsView.leadingAnchor, trailing: statsView.trailingAnchor, topConstant: 6, leadingConstant: 4, trailingConstant: 4, heightConstant: 28)
    
    addSubview(usernameLabel)
    usernameLabel.anchor(top: profileImageView.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, topConstant: 12, leadingConstant: 12, trailingConstant: 12)
    
    setupBottomToolbar()
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
  
  private func setupUserStats() -> UIView {
    let stackView = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])
    stackView.distribution = .fillEqually
    
    addSubview(stackView)
    stackView.anchor(top: profileImageView.topAnchor, leading: profileImageView.trailingAnchor, trailing: trailingAnchor, leadingConstant: 12, trailingConstant: 12)
    
    return stackView
  }
  
  private func setupBottomToolbar() {
    let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
    stackView.distribution = .fillEqually
    
    addSubview(stackView)
    stackView.anchor(leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, heightConstant: 50)
    [stackView.topAnchor, stackView.bottomAnchor].forEach {
      [unowned self] anchor in
      let v = UIView()
      v.backgroundColor = .lightGray
      self.addSubview(v)
      v.anchor(top: anchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, heightConstant: 0.5)
    }
  }
}
