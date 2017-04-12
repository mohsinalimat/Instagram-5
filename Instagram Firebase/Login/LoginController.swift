//
//  LoginController.swift
//  Instagram Firebase
//
//  Created by Vyacheslav Nagornyak on 4/6/17.
//  Copyright © 2017 Vyacheslav Nagornyak. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
  
  let logoContainerView: UIView = {
    let view = UIView()
    view.backgroundColor = #colorLiteral(red: 0, green: 0.4705882353, blue: 0.6862745098, alpha: 1)
    
    let logoImageView = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
    view.addSubview(logoImageView)
    logoImageView.anchor(centerX: view.centerXAnchor, centerY: view.centerYAnchor)
    
    return view
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
  
  let loginButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Login", for: .normal)
    button.backgroundColor = #colorLiteral(red: 0.644659102, green: 0.8389277458, blue: 0.9662960172, alpha: 1)
    button.layer.cornerRadius = 5
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    button.setTitleColor(.white, for: .normal)
    button.isEnabled = false
    button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    return button
  }()
  
  let dontHaveAcoountButton: UIButton = {
    let button = UIButton(type: .system)
    let attributedText = NSMutableAttributedString(string: "Don't have an account? ", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.lightGray])
    attributedText.append(NSAttributedString(string: "Sign Up", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14), NSForegroundColorAttributeName: #colorLiteral(red: 0.06666666667, green: 0.6039215686, blue: 0.9294117647, alpha: 1)]))
    attributedText.append(NSAttributedString(string: ".", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.lightGray]))
    button.setAttributedTitle(attributedText, for: .normal)
    button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
    return button
  }()
  
  func handleTextInputChange() {
    let isFormValid = !(emailTextField.text?.isEmpty ?? true) &&
      !(passwordTextField.text?.isEmpty ?? true)
    
    if isFormValid {
      loginButton.backgroundColor = #colorLiteral(red: 0.06666666667, green: 0.6039215686, blue: 0.9294117647, alpha: 1)
      loginButton.isEnabled = true
    } else {
      loginButton.backgroundColor = #colorLiteral(red: 0.644659102, green: 0.8389277458, blue: 0.9662960172, alpha: 1)
      loginButton.isEnabled = false
    }
  }
  
  func handleLogin() {
    guard let email = emailTextField.text, let password = passwordTextField.text else { return }
    
    FIRAuth.auth()?.signIn(withEmail: email, password: password) {
      [unowned self] user, error in
      if let error = error {
        print("Failed to login with error: ", error)
        return
      }
      
      print("Successfully logged back in with user: ", user?.uid ?? "")
      
      guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
      mainTabBarController.setupViewControllers()
      
      self.dismiss(animated: true, completion: nil)
    }
  }
  
  func handleShowSignUp() {
    navigationController?.pushViewController(SignUpController(), animated: true)
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    navigationController?.isNavigationBarHidden = true
    
    view.addSubview(logoContainerView)
    view.addSubview(dontHaveAcoountButton)
    
    logoContainerView.anchor(top: topLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, heightConstant: 150)
    
    setupInputFields()
    
    dontHaveAcoountButton.anchor(bottom: view.bottomAnchor, centerX: view.centerXAnchor, bottomConstant: 8)
  }
  
  private func setupInputFields() {
    let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
    stackView.axis = .vertical
    stackView.spacing = 10
    stackView.distribution = .fillEqually
    
    view.addSubview(stackView)
    stackView.anchor(top: logoContainerView.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, topConstant: 40, leadingConstant: 40, trailingConstant: 40, heightConstant: 140)
  }
}
