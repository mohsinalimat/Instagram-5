//
//  CustomAnimationPresentor.swift
//  Instagram Firebase
//
//  Created by Vyacheslav Nagornyak on 5/4/17.
//  Copyright © 2017 Vyacheslav Nagornyak. All rights reserved.
//

import UIKit

class CustomAnimationPresentor: NSObject, UIViewControllerAnimatedTransitioning {
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.5
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let toView = transitionContext.view(forKey: .to),
      let fromView = transitionContext.view(forKey: .from) else { return }
    
    let containerView = transitionContext.containerView
    containerView.addSubview(toView)
    
    let startingFrame = CGRect(x: -toView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height)
    toView.frame = startingFrame
    
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { 
      toView.frame = CGRect(x: 0, y: 0, width: toView.frame.width, height: toView.frame.height)
      fromView.frame = CGRect(x: fromView.frame.width, y: 0, width: fromView.frame.width, height: fromView.frame.height)
    }) { (_) in
      transitionContext.completeTransition(true)
    }
  }
}
