//
//  LibraryAPI.swift
//  HiBentley
//
//  Created by Paul Williams on 18/08/2016.
//  Copyright © 2016 BentleyMotors. All rights reserved.
//

import UIKit

class API: NSObject {
    
  //  private let jobs : Jobs
    let cds : CDS
    private let isOnline : Bool
    var VINString : String?
    var EmailString : String?
    var PasswordString : String?
    
    
    class var sharedInstance: API {
        
        struct Singleton {
            
            static let instance = API()
        }
        
        return Singleton.instance
    }
    
    override init() {
      //  jobs = Jobs()
        cds = CDS()
        isOnline = false
        super.init()
    }
    
    
    
    
}
