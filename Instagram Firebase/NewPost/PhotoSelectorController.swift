//
//  PhotoSelectorController.swift
//  Instagram Firebase
//
//  Created by Vyacheslav Nagornyak on 4/12/17.
//  Copyright © 2017 Vyacheslav Nagornyak. All rights reserved.
//

import UIKit
import Photos

class PhotoSelectorController: UICollectionViewController {
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  // MARK: - Literals
  let headerId = "headerId"
  let cellId = "cellId"
  
  // MARK: - Variables
  var assets = [PHAsset]()
  var images = [UIImage]()
  var selectedImage: UIImage?
  var header: PhotoCell?
  
  // MARK: - Handlers
  func handleCancel() {
    dismiss(animated: true, completion: nil)
  }
  
  func handleNext() {
    let sharePhotoController = SharePhotoController()
    sharePhotoController.selectedImage = header?.imageView.image
    navigationController?.pushViewController(sharePhotoController, animated: true)
  }
  
  // MARK: - Functions
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView?.backgroundColor = .white
    
    collectionView?.register(PhotoCell.self, forCellWithReuseIdentifier: cellId)
    collectionView?.register(PhotoCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
    
    setupNavigationButtons()
    
    fetchPhotos()
  }
  
  private func setupNavigationButtons() {
    navigationController?.navigationBar.tintColor = .black
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
  }
  
  private func fetchPhotos() {
    DispatchQueue.global(qos: .background).async {
      let allPhotos = PHAsset.fetchAssets(with: .image, options: self.asstesFetchOptions())
      
      allPhotos.enumerateObjects({ (asset, count, stop) in
        let imageManager = PHImageManager()
        let targetSize = CGSize(width: 200, height: 200)
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { [unowned self] (image, info) in
          if let image = image {
            self.images.append(image)
            self.assets.append(asset)
            
            if self.selectedImage == nil {
              self.selectedImage = image
            }
          }
          
          if count == allPhotos.count - 1 {
            DispatchQueue.main.async {
              self.collectionView?.reloadData()
            }
          }
        }
      })
    }
  }
  
  private func asstesFetchOptions() -> PHFetchOptions {
    let fetchOptions = PHFetchOptions()
    fetchOptions.fetchLimit = 30
    let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
    fetchOptions.sortDescriptors = [sortDescriptor]
    return fetchOptions
  }
}

// MARK: - UICollectionViewController
extension PhotoSelectorController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return images.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PhotoCell
    cell.imageView.image = images[indexPath.row]
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! PhotoCell
    
    self.header = header
    header.imageView.image = selectedImage
    
    if let selectedImage = selectedImage, let index = images.index(of: selectedImage) {
      let selectedAsset = assets[index]
      let imageManaget = PHImageManager()
      let targetSize = CGSize(width: 600, height: 600)
      imageManaget.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .default, options: nil) { (image, info) in
        header.imageView.image = image
      }
    }
    return header
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    selectedImage = images[indexPath.row]
    collectionView.reloadData()
    
    let topIndexPath = IndexPath(row: 0, section: 0)
    collectionView.scrollToItem(at: topIndexPath, at: .bottom, animated: true)
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PhotoSelectorController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = (view.frame.width - 3) / 4
    return CGSize(width: width, height: width)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    let width = view.frame.width
    return CGSize(width: width, height: width)
  }
}
