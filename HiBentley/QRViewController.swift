//
//  QRViewController.swift
//  HiBentley
//
//  Created by Paul Williams on 19/08/2016.
//  Copyright © 2016 BentleyMotors. All rights reserved.
//
// based on https://www.appcoda.com/qr-code-reader-swift/

// QRCode example text is {"VIN" : "SCBLF45FX7CH12031", "email" : "pangtuwi@gmail.com", "password" : "xxxxxx", "name": "Paul Williams"}
// generated at http://www.qrcode-monkey.com/#text

import UIKit
import AVFoundation

extension String
{
    var parseJSONString: AnyObject?
    {
        let data = self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        
        if let jsonData = data
        {
            // Will return an object or nil if JSON decoding fails
            do
            {
                let message = try NSJSONSerialization.JSONObjectWithData(jsonData, options:.MutableContainers)
                if let jsonResult = message as? NSMutableArray {
                    return jsonResult //Will return the json array output
                } else if let jsonResult = message as? NSMutableDictionary {
                    return jsonResult //Will return the json dictionary output
                } else {
                    return nil
                }
            }
            catch let error as NSError
            {
                print("An error occurred: \(error)")
                return nil
            }
        }
        else
        {
            // Lossless conversion of the string was not possible
            return nil
        }
    }
}


class QRViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var messageLabel : UILabel!
    @IBOutlet weak var backButton : UIButton!

    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var input:AVCaptureInput?
    
    var newVINString : String?
    var newEmailString : String?
    var newPasswordString : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
        var error:NSError?
        try! input = AVCaptureDeviceInput(device: captureDevice)
        
        if (error != nil) {
            // If any error occurs, simply log the description of it and don't continue any more.
            print("\(error?.localizedDescription)")
            return
        }
        
        // Initialize the captureSession object.
        captureSession = AVCaptureSession()
        // Set the input device on the capture session.
        captureSession?.addInput(input)
        
        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        // Set delegate and use the default dispatch queue to execute the call back
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.greenColor().CGColor
        qrCodeFrameView?.layer.borderWidth = 2
        view.addSubview(qrCodeFrameView!)
        view.bringSubviewToFront(qrCodeFrameView!)
        
        // Start video capture.
        captureSession?.startRunning()
        
        view.bringSubviewToFront(messageLabel)
        view.bringSubviewToFront(backButton)
        
    }
    

    //Pass data back
    //http://jamesleist.com/ios-swift-passing-data-between-viewcontrollers/
    //does not work as not using segue to go back!
    /*override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (segue.identifier == "segueQR") {
            var svc = segue!.destinationViewController as! SecondViewController;
            if (newVINString != nil) {
                svc.VINString = newVINString
            }
            
        }
    } */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close() {
        if (newVINString != nil) {
            API.sharedInstance.VINString = newVINString
            API.sharedInstance.EmailString = newEmailString
            API.sharedInstance.PasswordString = newPasswordString
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRectZero
            messageLabel.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject.bounds;
            
            if metadataObj.stringValue != nil {
                messageLabel.text = metadataObj.stringValue
                //print ("String In: "+metadataObj.stringValue)
                
                let json: AnyObject? = metadataObj.stringValue.parseJSONString
                
                if let value = json!["VIN"] {
                    if let value2 = json!["email"] {
                        if let value3 = json!["password"] {
                            newVINString = json!["VIN"] as! String
                            newEmailString = json!["email"] as! String
                            newPasswordString = json!["password"] as! String
                            close()
                        }
                    }
                }
               
                
                //print ("GOT VIN: "+newVINString!)
                //print("Parsed JSON: \(json!)")
              
            }
        }
    } //func CaptureOutput

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}