//
//  SignUpController.swift
//  Instagram Firebase
//
//  Created by Vyacheslav Nagornyak on 4/5/17.
//  Copyright © 2017 Vyacheslav Nagornyak. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController {
  
  let plusPhotoButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
    button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
    return button
  }()
  
  let emailTextField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "Email"
    tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
    tf.borderStyle = .roundedRect
    tf.font = UIFont.systemFont(ofSize: 14)
    tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
    return tf
  }()
  
  let usernameTextField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "Username"
    tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
    tf.borderStyle = .roundedRect
    tf.font = UIFont.systemFont(ofSize: 14)
    tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
    return tf
  }()

  let passwordTextField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "Password"
    tf.isSecureTextEntry = true
    tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
    tf.borderStyle = .roundedRect
    tf.font = UIFont.systemFont(ofSize: 14)
    tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
    return tf
  }()
  
  let signUpButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Sign Up", for: .normal)
    button.backgroundColor = #colorLiteral(red: 0.644659102, green: 0.8389277458, blue: 0.9662960172, alpha: 1)
    button.layer.cornerRadius = 5
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    button.setTitleColor(.white, for: .normal)
    button.isEnabled = false
    button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
    return button
  }()
  
  let alreadyHaveAccountButton: UIButton = {
    let button = UIButton(type: .system)
    let attributedText = NSMutableAttributedString(string: "Already have an account? ", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.lightGray])
    attributedText.append(NSAttributedString(string: "Sign In", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14), NSForegroundColorAttributeName: #colorLiteral(red: 0.06666666667, green: 0.6039215686, blue: 0.9294117647, alpha: 1)]))
    attributedText.append(NSAttributedString(string: ".", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.lightGray]))
    button.setAttributedTitle(attributedText, for: .normal)
    button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
    return button
  }()
  
  func handlePlusPhoto() {
    let imagePickerController = UIImagePickerController()
    imagePickerController.allowsEditing = true
    imagePickerController.delegate = self
    present(imagePickerController, animated: true, completion: nil)
  }
  
  func handleTextInputChange() {
    let isFormValid = !(emailTextField.text?.isEmpty ?? true) &&
                      !(usernameTextField.text?.isEmpty ?? true) &&
                      !(passwordTextField.text?.isEmpty ?? true)
    
    if isFormValid {
      signUpButton.backgroundColor = #colorLiteral(red: 0.06666666667, green: 0.6039215686, blue: 0.9294117647, alpha: 1)
      signUpButton.isEnabled = true
    } else {
      signUpButton.backgroundColor = #colorLiteral(red: 0.644659102, green: 0.8389277458, blue: 0.9662960172, alpha: 1)
      signUpButton.isEnabled = false
    }
  }
  
  func handleSignUp() {
    guard let email = emailTextField.text, !email.isEmpty,
      let username = usernameTextField.text, !username.isEmpty,
      let password = passwordTextField.text, !password.isEmpty else {
        return
    }
    
    FIRAuth.auth()?.createUser(withEmail: email, password: password) {
      [unowned self] user, error in
      
      if let error = error {
        print("Error creating new user: ", error)
        return
      }
      
      print("Created user: ", user?.uid ?? "")
      
      guard let image = self.plusPhotoButton.imageView?.image else { return }
      guard let uploadData = UIImageJPEGRepresentation(image, 0.2) else { return }
      
      let uuidString = UUID().uuidString
      FIRStorage.storage().reference().child("profile_images").child(uuidString).put(uploadData, metadata: nil) {
        metadata, error in
        
        if let error = error {
          print("Failed to upload profile image: ", error)
        }
        guard let profileImageUrl = metadata?.downloadURL()?.absoluteString else { return }
        
        print("Successfully uploaded profile image: ", profileImageUrl)
        
        guard let uid = user?.uid else { return }
        
        let dictionaryValues = ["username": username, "profileImageUrl": profileImageUrl]
        let values = [uid: dictionaryValues]
        
        FIRDatabase.database().reference().child("users").updateChildValues(values) {
          error, reference in
          if let error = error {
            print("Error setting new values for user: \(error)")
            return
          }
          
          print("New values for user(\(user?.uid ?? "")) set")
          
          guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
          mainTabBarController.setupViewControllers()
          
          self.dismiss(animated: true, completion: nil)
        }

      }
    }
  }
  
  func handleShowLogin() {
    _ = navigationController?.popViewController(animated: true)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    view.addSubview(plusPhotoButton)
    plusPhotoButton.anchor(top: topLayoutGuide.bottomAnchor, centerX: view.centerXAnchor, width: plusPhotoButton.heightAnchor, topConstant: 20, heightConstant: 140)
    
    setupInputFields()
    
    view.addSubview(alreadyHaveAccountButton)
    alreadyHaveAccountButton.anchor(bottom: view.bottomAnchor, centerX: view.centerXAnchor, bottomConstant: 8)
  }
  
  private func setupInputFields() {
    let stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signUpButton])
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    stackView.spacing = 10
    
    view.addSubview(stackView)
    stackView.anchor(top: plusPhotoButton.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, topConstant: 20, leadingConstant: 40, trailingConstant: 40, heightConstant: 200)
  }
}

/// MARK: - UIImagePickerControllerDelegate
extension SignUpController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
      plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
    } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
      plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width * 0.5
    plusPhotoButton.layer.masksToBounds = true
    plusPhotoButton.layer.borderColor = #colorLiteral(red: 0.644659102, green: 0.8389277458, blue: 0.9662960172, alpha: 1).cgColor
    plusPhotoButton.layer.borderWidth = 2
    
    dismiss(animated: true, completion: nil)
  }
}
