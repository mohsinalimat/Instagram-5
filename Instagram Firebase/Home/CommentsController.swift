//
//  CommentsController.swift
//  Instagram Firebase
//
//  Created by Vyacheslav Nagornyak on 5/4/17.
//  Copyright © 2017 Vyacheslav Nagornyak. All rights reserved.
//

import UIKit

class CommentsController: UICollectionViewController {
  
  // MARK: - Variables
  var post: Post? {
    didSet {
      
    }
  }
  
  override var canBecomeFirstResponder: Bool {
    return true
  }
  
  // MARK: - UI
  let inputContainerView: UIView = {
    let containerView = UIView()
    containerView.backgroundColor = .green
    containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
    
    let textfield = UITextField()
    textfield.placeholder = "Enter comment..."
    
    let sendButton = UIButton(type: .system)
    sendButton.setTitle("Send", for: .normal)
    sendButton.setTitleColor(.black, for: .normal)
    sendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
    
    containerView.addSubview(textfield)
    containerView.addSubview(sendButton)
    
    textfield.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, trailing: sendButton.leadingAnchor, bottom: containerView.bottomAnchor, leadingConstant: 12, trailingConstant: 12)
    sendButton.anchor(top: containerView.topAnchor, trailing: containerView.trailingAnchor, bottom: containerView.bottomAnchor, trailingConstant: 12, widthConstant: 50)
    
    return containerView
  }()
  
  override var inputAccessoryView: UIView? {
    get {
      return inputContainerView
    }
  }
  
  // MARK: - Handlers
  func handleSend() {
    
  }
  
  // MARK: - Functions
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView?.backgroundColor = .white
    tabBarController?.tabBar.isHidden = true
    navigationItem.title = "Comments"
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    tabBarController?.tabBar.isHidden = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)
    
    tabBarController?.tabBar.isHidden = false
  }
}
