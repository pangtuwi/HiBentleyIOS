//
//  SecondViewController.swift
//  HiBentley
//
//  Created by Paul Williams on 11/08/2016.
//  Copyright © 2016 BentleyMotors. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //var VINString : String? //http://lithium3141.com/blog/2014/06/19/learning-swift-optional-types/
    
    @IBOutlet weak var VINTextField : UITextField!
    @IBOutlet weak var EmailTextField : UITextField!
    @IBOutlet weak var PasswordTextField : UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if (API.sharedInstance.VINString != nil) {
            VINTextField.text = API.sharedInstance.VINString
        }
        if (API.sharedInstance.EmailString != nil) {
            EmailTextField.text = API.sharedInstance.EmailString
        }
        if (API.sharedInstance.PasswordString != nil) {
            PasswordTextField.text = API.sharedInstance.PasswordString
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

