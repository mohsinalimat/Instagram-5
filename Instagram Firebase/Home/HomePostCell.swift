//
//  HomePostCell.swift
//  Instagram Firebase
//
//  Created by Vyacheslav Nagornyak on 4/15/17.
//  Copyright © 2017 Vyacheslav Nagornyak. All rights reserved.
//

import UIKit

class HomePostCell: UICollectionViewCell {
  
  // MARK: - Variables
  var post: Post? {
    didSet {
      guard let imageUrl = post?.imageUrl else { return }
      
      photoImageView.loadImage(url: imageUrl)
      usernameLabel.text = post?.user.username
      
      if let profileImageUrl = post?.user.profileImageUrl {
        userProfileImageView.loadImage(url: profileImageUrl)
      }
      
      setupCaption()
    }
  }
  
  // MARK: - UI
  let userProfileImageView: CustomImageView = {
    let iv = CustomImageView()
    iv.contentMode = .scaleAspectFill
    iv.clipsToBounds = true
    return iv
  }()
  
  let usernameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 14)
    return label
  }()
  
  let optionsButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("•••", for: .normal)
    button.setTitleColor(.black, for: .normal)
    return button
  }()
  
  let photoImageView: CustomImageView = {
    let iv = CustomImageView()
    iv.contentMode = .scaleAspectFill
    iv.clipsToBounds = true
    return iv
  }()
  
  let likeButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
    return button
  }()
  
  let commentButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysOriginal), for: .normal)
    return button
  }()
  
  let directButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "send2").withRenderingMode(.alwaysOriginal), for: .normal)
    return button
  }()
  
  let bookmarkButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "ribbon").withRenderingMode(.alwaysOriginal), for: .normal)
    return button
  }()
  
  let captionLabel: UILabel = {
    let label = UILabel()
    let attributedText = NSMutableAttributedString(string: "username", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
    attributedText.append(NSAttributedString(string: " something important about this post. Maybe even more important, than you can imagine", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]))
    attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 4)]))
    attributedText.append(NSAttributedString(string: "1 week ago", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.gray]))
    label.attributedText = attributedText
    label.numberOfLines = 0
    return label
  }()
  
  // MARK: - Initializers
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(userProfileImageView)
    addSubview(usernameLabel)
    addSubview(optionsButton)
    addSubview(photoImageView)
    addSubview(captionLabel)
    
    userProfileImageView.anchor(top: topAnchor, leading: leadingAnchor, height: userProfileImageView.widthAnchor, topConstant: 8, leadingConstant: 8, widthConstant: 40)
    
    usernameLabel.anchor(leading: userProfileImageView.trailingAnchor, trailing: optionsButton.trailingAnchor, centerY: userProfileImageView.centerYAnchor, topConstant: 8, leadingConstant: 8)
    
    optionsButton.anchor(top: userProfileImageView.topAnchor, trailing: trailingAnchor, bottom: userProfileImageView.bottomAnchor, centerY: userProfileImageView.centerYAnchor, width: optionsButton.heightAnchor, trailingConstant: 8)
    
    photoImageView.anchor(top: userProfileImageView.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, height: photoImageView.widthAnchor, topConstant: 8)
    
    setupActionButtons()
    
    captionLabel.anchor(top: likeButton.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, leadingConstant: 8, trailingConstant: 8)
  }
  
  // MARK: - Functions
  private func setupActionButtons() {
    let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, directButton])
    stackView.distribution = .fillEqually
    
    addSubview(stackView)
    addSubview(bookmarkButton)
    
    stackView.anchor(top: photoImageView.bottomAnchor, leading: leadingAnchor, topConstant: 0, leadingConstant: 8, widthConstant: 120, heightConstant: 50)
    bookmarkButton.anchor(top: photoImageView.bottomAnchor, trailing: trailingAnchor, height: stackView.heightAnchor, widthConstant: 40)
  }
  
  private func setupCaption() {
    guard let post = post else { return }
    
    let attributedText = NSMutableAttributedString(string: "\(post.user.username)", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
    attributedText.append(NSAttributedString(string: " \(post.caption)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]))
    attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 4)]))
    attributedText.append(NSAttributedString(string: "1 week ago", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.gray]))
    captionLabel.attributedText = attributedText
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    userProfileImageView.layer.cornerRadius = 20
  }
}
