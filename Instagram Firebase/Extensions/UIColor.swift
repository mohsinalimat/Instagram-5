//
//  UIColor.swift
//  Instagram Firebase
//
//  Created by Vyacheslav Nagornyak on 4/6/17.
//  Copyright © 2017 Vyacheslav Nagornyak. All rights reserved.
//

import UIKit

extension UIColor {
  convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
    self.init(red: r / 255, green: g / 255, blue: b / 255, alpha: a)
  }
  
  convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
    self.init(r: r, g: g, b: b, a: 1)
  }
}
