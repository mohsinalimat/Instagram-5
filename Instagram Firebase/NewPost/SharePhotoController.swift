//
//  SharePhotoController.swift
//  Instagram Firebase
//
//  Created by Vyacheslav Nagornyak on 4/13/17.
//  Copyright © 2017 Vyacheslav Nagornyak. All rights reserved.
//

import UIKit
import Firebase

class SharePhotoController: UIViewController {
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  // MARK: - Variables
  var selectedImage: UIImage? {
    didSet {
      imageView.image = selectedImage
    }
  }
  
  // MARK: - UI
  var imageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFill
    iv.clipsToBounds = true
    return iv
  }()
  
  var textView: UITextView = {
    let tv = UITextView()
    tv.font = UIFont.systemFont(ofSize: 14)
    return tv
  }()
  
  // MARK: - Handlers
  func handleShare() {
    guard let image = selectedImage,
      let uploadData = UIImageJPEGRepresentation(image, 0.2) else { return }
    
    navigationItem.rightBarButtonItem?.isEnabled = false
    
    let filename = UUID().uuidString
    FIRStorage.storage().reference().child("posts").child(filename).put(uploadData, metadata: nil) { [unowned self] (metadata, error) in
      
      if let error = error {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        print("Failed to upload an image to Firebase with error:", error)
        return
      }
      
      guard let imageUrl = metadata?.downloadURL()?.absoluteString else { return }
      
      print("Successfully uploaded an image to Firebase:", imageUrl)
      
      self.saveToDatabase(with: imageUrl)
    }
  }
  
  // MARK: - Functions
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
    
    setupImageAndTextViews()
  }
  
  private func saveToDatabase(with imageUrl: String) {
    guard let uid = FIRAuth.auth()?.currentUser?.uid,
//      let caption = textView.text,
      let postImage = selectedImage else { return }
    
    var values: [String: Any] = [
      "imageUrl": imageUrl,
//      "caption": caption,
      "imageWidth": postImage.size.width,
      "creationDate": Date().timeIntervalSince1970
    ]
    if let caption = textView.text, !caption.isEmpty {
      values["caption"] = caption
    }
    
    FIRDatabase.database().reference().child("posts")
      .child(uid)
      .childByAutoId()
      .updateChildValues(values) { [unowned self] (err, ref) in
      if let error = err {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        print("Failed to save image into db:", error)
      }
      
      print("Successfully saved image into db")
      
      self.dismiss(animated: true, completion: nil)
    }
  }
  
  private func setupImageAndTextViews() {
    let containerView = UIView()
    containerView.backgroundColor = .white
    
    view.addSubview(containerView)
    containerView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, heightConstant: 100)
    
    containerView.addSubview(imageView)
    imageView.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: containerView.bottomAnchor, width: imageView.heightAnchor, topConstant: 8, leadingConstant: 8, bottomConstant: 8)
    
    containerView.addSubview(textView)
    textView.anchor(top: containerView.topAnchor, leading: imageView.trailingAnchor, trailing: containerView.trailingAnchor, bottom: containerView.bottomAnchor, leadingConstant: 4)
  }
}
