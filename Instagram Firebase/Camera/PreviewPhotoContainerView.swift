//
//  PreviewPhotoContainerView.swift
//  Instagram Firebase
//
//  Created by Vyacheslav Nagornyak on 4/30/17.
//  Copyright © 2017 Vyacheslav Nagornyak. All rights reserved.
//

import UIKit
import Photos

class PreviewPhotoContainerView: UIView {
  
  // MARK: - UI
  let previewImageView: UIImageView = {
    let iv = UIImageView()
    return iv
  }()
  
  let cancelButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "cancel_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
    button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
    return button
  }()
  
  let saveButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "save_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
    button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
    return button
  }()
  
  // MARK: - Handlers
  func handleCancel() {
    removeFromSuperview()
  }
  
  func handleSave() {
    guard let previewImage = previewImageView.image else { return }
    
    let library = PHPhotoLibrary.shared()
    library.performChanges({ 
      PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
    }) { (success, error) in
      if let error = error {
        print("Failed to save image to photo library:", error)
        return
      }
      
      print("Successfully saved image to library")
      
      let savedLabel = UILabel()
      savedLabel.text = "Saved Successfully"
      savedLabel.textColor = .white
      savedLabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
      savedLabel.font = UIFont.boldSystemFont(ofSize: 18)
      savedLabel.textAlignment = .center
      
      DispatchQueue.main.async {
        self.addSubview(savedLabel)
        savedLabel.anchor(centerX: self.centerXAnchor, centerY: self.centerYAnchor)
        savedLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: { 
          savedLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
        }, completion: { (completed) in
          UIView.animate(withDuration: 0.5, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: { 
            savedLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
            savedLabel.alpha = 0
          }, completion: { (_) in
            savedLabel.removeFromSuperview()
          })
        })
      }
    }
  }
  
  // MARK: - Initializers
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(previewImageView)
    previewImageView.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor)
    
    addSubview(cancelButton)
    cancelButton.anchor(top: topAnchor, leading: leadingAnchor, height: cancelButton.widthAnchor, topConstant: 12, leadingConstant: 12, widthConstant: 50)
    
    addSubview(saveButton)
    saveButton.anchor(leading: leadingAnchor, bottom: bottomAnchor, height: saveButton.widthAnchor, leadingConstant: 24, bottomConstant: 24, widthConstant: 50)
  }
}
