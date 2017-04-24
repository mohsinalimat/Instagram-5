//
//  Extensions.swift
//  Instagram Firebase
//
//  Created by Vyacheslav Nagornyak on 4/13/17.
//  Copyright © 2017 Vyacheslav Nagornyak. All rights reserved.
//

import UIKit

extension UIView {
  func anchor(top: NSLayoutYAxisAnchor? = nil, leading: NSLayoutXAxisAnchor? = nil, trailing: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, centerX: NSLayoutXAxisAnchor? = nil, centerY: NSLayoutYAxisAnchor? = nil, width: NSLayoutDimension? = nil, height: NSLayoutDimension? = nil, topConstant: CGFloat = 0, leadingConstant: CGFloat = 0, trailingConstant: CGFloat = 0, bottomConstant: CGFloat = 0, centerXConstant: CGFloat = 0, centerYConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) {
    translatesAutoresizingMaskIntoConstraints = false
    var anchors = [NSLayoutConstraint]()
    
    if let top = top {
      anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
    }
    
    if let leading = leading {
      anchors.append(leadingAnchor.constraint(equalTo: leading, constant: leadingConstant))
    }
    
    if let trailing = trailing {
      anchors.append(trailingAnchor.constraint(equalTo: trailing, constant: -trailingConstant))
    }
    
    if let bottom = bottom {
      anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
    }
    
    if let centerX = centerX {
      anchors.append(centerXAnchor.constraint(equalTo: centerX, constant: centerXConstant))
    }
    
    if let centerY = centerY {
      anchors.append(centerYAnchor.constraint(equalTo: centerY, constant: centerYConstant))
    }
    
    if let width = width {
      anchors.append(widthAnchor.constraint(equalTo: width, constant: widthConstant))
    } else if widthConstant != 0 {
      anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
    }
    
    if let height = height {
      anchors.append(heightAnchor.constraint(equalTo: height, constant: heightConstant))
    } else if heightConstant != 0 {
      anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
    }
    
    anchors.forEach({$0.isActive = true})
  }
}

extension UIColor {
  convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
    self.init(red: r / 255, green: g / 255, blue: b / 255, alpha: a)
  }
  
  convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
    self.init(r: r, g: g, b: b, a: 1)
  }
}

extension Date {
  func timeAgo() -> String {
    let secondsAgo = Int(Date().timeIntervalSince(self))
    
    let minute = 60
    let hour = minute * 60
    let day = 24 * hour
    let week = 7 * day
    let month = 30 * day
    
    let quotient: Int
    let unit: String
    
    if secondsAgo < 5 {
      quotient = 0
      unit = "Just now"
    } else if secondsAgo < minute {
      quotient = secondsAgo
      if quotient > 1 {
        unit = "seconds"
      } else {
        unit = "second"
      }
    } else if secondsAgo < hour {
      quotient = secondsAgo / minute
      if quotient > 1 {
        unit = "minutes"
      } else {
        unit = "minute"
      }
    } else if secondsAgo < day {
      quotient = secondsAgo / hour
      if quotient > 1 {
        unit = "hours"
      } else {
        unit = "hour"
      }
    } else if secondsAgo < week {
      quotient = secondsAgo / day
      if quotient > 1 {
        unit = "days"
      } else {
        unit = "day"
      }
    } else if secondsAgo < month {
      quotient = secondsAgo / week
      if quotient > 1 {
        unit = "weeks"
      } else {
        unit = "week"
      }
    } else {
      quotient = 0
      let formatter = DateFormatter()
      formatter.dateFormat = "ddmmmmyyyy"
      unit = formatter.string(from: self)
    }
    
    let quotientStr = quotient > 0 ? "\(quotient) " : ""
    let postfix = quotientStr.isEmpty ? "" : " ago"
    let result = quotientStr + unit + postfix
    return result
  }
}
