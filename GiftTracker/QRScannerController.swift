//
//  QRScannerController.swift
//  GiftTracker
//
//  QRCodeReader
//
//  Created by Simon Ng on 13/10/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//  http://www.appcoda.com/barcode-reader-swift/
//

import UIKit
import AVFoundation

class QRScannerController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
   
   @IBOutlet weak var messageLabel: UILabel!
   @IBOutlet weak var topbar: UIView!
   
   var captureSession:AVCaptureSession?
   var videoPreviewLayer:AVCaptureVideoPreviewLayer?
   var qrCodeFrameView:UIView?
   
   let captureMetadataOutput = AVCaptureMetadataOutput()
   var lastCapturedCode:String?
   let supportedCodeTypes = [AVMetadataObjectTypeUPCECode,
                             AVMetadataObjectTypeCode39Code,
                             AVMetadataObjectTypeCode39Mod43Code,
                             AVMetadataObjectTypeCode93Code,
                             AVMetadataObjectTypeCode128Code,
                             AVMetadataObjectTypeEAN8Code,
                             AVMetadataObjectTypeEAN13Code,
                             AVMetadataObjectTypeAztecCode,
                             AVMetadataObjectTypePDF417Code]
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter.
      let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
      
      do {
         // Get an instance of the AVCaptureDeviceInput class using the previous device object.
         let input = try AVCaptureDeviceInput(device: captureDevice)
         
         // Initialize the captureSession object.
         captureSession = AVCaptureSession()
         
         // Set the input device on the capture session.
         captureSession?.addInput(input)
         
         // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
         captureSession?.addOutput(captureMetadataOutput)
         
         // Set delegate and use the default dispatch queue to execute the call back
         captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
         captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
         
         // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
         videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
         videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
         videoPreviewLayer?.frame = view.layer.bounds
         view.layer.addSublayer(videoPreviewLayer!)
         
         // Start video capture.
         captureSession?.startRunning()
         
         // Move the message label and top bar to the front
         view.bringSubview(toFront: messageLabel)
         view.bringSubview(toFront: topbar)
         
      } catch {
         // If any error occurs, simply print it out and don't continue any more.
         print(error)
         return
      }
   }
   
   // MARK: - AVCaptureMetadataOutputObjectsDelegate Methods
   
   func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
      
      // Check if the metadataObjects array is not nil and it contains at least one object.
      if metadataObjects == nil || metadataObjects.count == 0 {
         qrCodeFrameView?.frame = CGRect.zero
         messageLabel.text = "No UPC is detected"
         return
      }
      
      // Get the metadata object.
      let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
      
      if supportedCodeTypes.contains(metadataObj.type) {
         // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
         let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
         
         qrCodeFrameView?.frame = barCodeObject.bounds
         
         if metadataObj.stringValue != nil {
            messageLabel.text = metadataObj.stringValue
            lastCapturedCode = metadataObj.stringValue
            print(lastCapturedCode)
         }
         
         // Ths is a bit hacky to prevent many callbacks
         captureMetadataOutput.setMetadataObjectsDelegate(nil, queue: nil)
         
         DispatchQueue.main.async(execute: {
            self.performSegue(withIdentifier: "backToProduct", sender: self.lastCapturedCode)
         })
      }
      
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if let destination = segue.destination as? NewProductViewController {
         destination.passUPC = lastCapturedCode
      }
   }
   
}
