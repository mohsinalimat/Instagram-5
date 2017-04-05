//
//  SignUpController.swift
//  Instagram Firebase
//
//  Created by Vyacheslav Nagornyak on 4/5/17.
//  Copyright © 2017 Vyacheslav Nagornyak. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpController: UIViewController {
  
  let plusPhotoButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
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
    guard let email = emailTextField.text, !email.isEmpty else {
      print("email field should be specified")
      return
    }
    
    guard let username = usernameTextField.text, !username.isEmpty else {
      print("username field should be specified")
      return
    }
    
    guard let password = passwordTextField.text, !password.isEmpty else {
      print("password field should be specified")
      return
    }
    
    FIRAuth.auth()?.createUser(withEmail: email, password: password) {
      user, error in
      
      guard error != nil else {
        print("Error creating new user: \(error!)")
        return
      }
      
      
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(plusPhotoButton)
    plusPhotoButton.anchor(top: topLayoutGuide.bottomAnchor, centerX: view.centerXAnchor, width: plusPhotoButton.heightAnchor, topConstant: 20, heightConstant: 140)
    
    setupInputFields()
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

