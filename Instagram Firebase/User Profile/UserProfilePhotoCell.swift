//
//  UserProfilePhotoCell.swift
//  Instagram Firebase
//
//  Created by Vyacheslav Nagornyak on 4/14/17.
//  Copyright © 2017 Vyacheslav Nagornyak. All rights reserved.
//

import UIKit

class UserProfilePhotoCell: UICollectionViewCell {
  
  var post: Post? {
    didSet {
      guard let imageUrl = post?.imageUrl,
        let url = URL(string: imageUrl) else { return }
      
      URLSession.shared.dataTask(with: url) { [unowned self] (data, response, error) in
        if let error = error {
          print("Failed to load image from db: ", error)
          return
        }
        
        guard let imageData = data else { return }
       
        DispatchQueue.main.async {
          self.imageView.image = UIImage(data: imageData)
        }
      }.resume()
    }
  }
  
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
