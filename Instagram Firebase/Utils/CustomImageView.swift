//
//  CustomImageView.swift
//  Instagram Firebase
//
//  Created by Vyacheslav Nagornyak on 4/15/17.
//  Copyright © 2017 Vyacheslav Nagornyak. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {
  
  var lastUrlUsed: String?
  
  func loadImage(url urlString: String) {
    
    lastUrlUsed = urlString
    
    guard let url = URL(string: urlString) else { return }
    
    URLSession.shared.dataTask(with: url) { [unowned self] (data, response, error) in
      if let error = error {
        print("Failed to load image from db: ", error)
        return
      }
      
      if url.absoluteString != self.lastUrlUsed {
        return
      }
      
      guard let imageData = data else { return }
      
      DispatchQueue.main.async {
        self.image = UIImage(data: imageData)
      }
    }.resume()
  }
}
