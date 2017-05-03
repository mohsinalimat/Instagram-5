//
//  CameraController.swift
//  Instagram Firebase
//
//  Created by Vyacheslav Nagornyak on 4/25/17.
//  Copyright © 2017 Vyacheslav Nagornyak. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController {
  
  // MARK: - Variables
  let output = AVCapturePhotoOutput()
  let customAnimationPresentor = CustomAnimationPresentor()
  let customAnimationDismissor = CustomAnimationDismissor()
  
  // MARK: - UI
  let dismissButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "right_arrow_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
    button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
    return button
  }()
  
  let captureButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "capture_photo").withRenderingMode(.alwaysOriginal), for: .normal)
    button.addTarget(self, action: #selector(handleCapture), for: .touchUpInside)
    return button
  }()
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  // MARK: - Handlers
  func handleCapture() {
    let settings = AVCapturePhotoSettings()
    guard let previewFormatType = settings.availablePreviewPhotoPixelFormatTypes.first else { return }
    
    settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewFormatType]
    
    output.capturePhoto(with: settings, delegate: self)
  }
  
  func handleDismiss() {
    dismiss(animated: true, completion: nil)
  }
  
  // MARK: - Functions
  override func viewDidLoad() {
    super.viewDidLoad()
    
    transitioningDelegate = self
    
    setupCaptureSession()
    setupViews()
  }
  
  private func setupCaptureSession() {
    let captureSession = AVCaptureSession()
    
    // Input
    let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    do {
      let input = try AVCaptureDeviceInput(device: captureDevice)
      if captureSession.canAddInput(input) {
        captureSession.addInput(input)
      }
    } catch let error {
      print("Failed to setup AVCaptureDeviceInput:", error)
    }
    
    // Output
    if captureSession.canAddOutput(output) {
      captureSession.addOutput(output)
    }
    
    // Preview
    guard let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) else { return }
    
    previewLayer.frame = view.frame
    view.layer.addSublayer(previewLayer)
    
    captureSession.startRunning()
  }
  
  private func setupViews() {
    view.addSubview(dismissButton)
    view.addSubview(captureButton)
    
    dismissButton.anchor(top: view.topAnchor, trailing: view.trailingAnchor, width: dismissButton.heightAnchor, topConstant: 12, trailingConstant: 12, heightConstant: 50)
    captureButton.anchor(bottom: view.bottomAnchor, centerX: view.centerXAnchor, width: captureButton.heightAnchor, bottomConstant: 24, heightConstant: 80)
  }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension CameraController: AVCapturePhotoCaptureDelegate {
  func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
    
    let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer!)
    let previewImage = UIImage(data: data!)
    
    let containerView = PreviewPhotoContainerView()
    containerView.previewImageView.image = previewImage
    view.addSubview(containerView)
    containerView.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor)
  }
}

// MARK: - UIViewControllerAnimatedTransitioning
extension CameraController: UIViewControllerTransitioningDelegate {
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return customAnimationPresentor
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return customAnimationDismissor
  }
}
