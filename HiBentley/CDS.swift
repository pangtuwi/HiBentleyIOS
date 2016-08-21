//
//  CDS.swift
//  HiBentley
//
//  Created by Paul Williams on 18/08/2016.
//  Copyright © 2016 BentleyMotors. All rights reserved.
//

import UIKit
import Firebase
    

class CDS : NSObject {

    
   // let myCDSURL = "https://project-7046838988190282194.firebaseio.com/"
    let myEmail = "pangtuwi@gmail.com"
    let myPassword = "xxxxxx"
    var myName = ""
    var myUid = ""
    var connectionStatus = "not Connected"
    
    var storageRef : FIRStorageReference?
    var databaseRef : FIRDatabaseReference?
    
    
    func getEmail () -> String {
        return myEmail
    }
    
  /*  func usersURL() -> String {
        return myCDSURL+"/users"
    }
*/
    
    
    //MARK: Initialisation
    
    override init() {
        print ("Initialising CDS")
        
        super.init()
        FIRApp.configure();
        databaseRef = FIRDatabase.database().reference()
        
        //FIRDatabase.database().persistenceEnabled = true
        
        // Get a reference to the storage service, using the default Firebase App
        let storage = FIRStorage.storage()
        // Create a storage reference from our storage service
        storageRef = storage.referenceForURL("gs://project-7046838988190282194.appspot.com/")
        
        // Create a child reference
        // imagesRef now points to "images"
       // let soundBitesRef = storageRef.child("soundBites")
        
        //Authenticate
        FIRAuth.auth()?.signInWithEmail(getEmail(), password: myPassword) { (user, error) in
            //not sure what to put here
            print ("successful login")
        
        
        if let user = FIRAuth.auth()?.currentUser {
            //let myName = user.displayName
            //let myEemail = user.email
            //let photoUrl = user.photoURL
            self.myUid = user.uid;  // The user's ID, unique to the Firebase project.
            print ("Found user with ID "+self.myUid)
        } else {
            // No user is signed in.
        }
        
        //let myLoginRef = FIRDatabase.database().referenceFromURL(usersURL())
        let loginRef = self.databaseRef?.child("users")
        
        //read data from database
        if let myUserID = FIRAuth.auth()?.currentUser?.uid {
            print ("myUserID="+self.myUid)
            loginRef!.child(myUserID).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                // Get user value
                self.myName = snapshot.value!["name"] as! String
                self.connectionStatus = "logged in"
                
                self.readJobData()
                
            }) { (error) in
                print("ERROR "+error.localizedDescription)
            }
        } else {
            // self.ConnectionLabel.text = "could not log in"
            self.connectionStatus = "log in Error"
        }
        }
    } //init
    
    
    func readJobData ()  { //Carried over from MyJobs application
        // Create a reference to a Firebase location
        
     /*   let myJobsRef = FIRDatabase.database().referenceFromURL(self.myCDSURL+"/jobs")
        
        //Read Job Data
        myJobsRef.observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
            let description = snapshot.value!["description"] as! String
            //print ("Found new Job: "+description)
            let dueBy = snapshot.value!["dueBy"] as! Double
            let ID = snapshot.value! ["ID"] as! String
        //    let job1 = Job(ID : ID, description: description, dueBy: dueBy)!
         //   API.sharedInstance.addJobToList(job1)
            let nc = NSNotificationCenter.defaultCenter()
            nc.postNotificationName("CDSJobAdded", object: nil)
            
            //Show Notification
            // create a corresponding local notification
            let notification = UILocalNotification()
            notification.alertBody = "New Job Recieved "+(dueBy as! String) + ID // text that will be displayed in the notification
            notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
            notification.fireDate = NSDate(timeIntervalSinceNow:5)//item.deadline // todo item due date (when notification will be fired)
            notification.soundName = UILocalNotificationDefaultSoundName // play default sound
            notification.userInfo = ["title": description, "UUID": NSUUID().UUIDString] // assign a unique identifier to the notification so that we can retrieve it later
            
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            
            
        }) */
    }//readJobData
    
    
    func createNewComment(recordingURL: NSURL) {
        let newCommentID = NSUUID().UUIDString
        let createdAt = round(NSDate().timeIntervalSince1970)
        //let createdAtString = String(createdAt)
        
        // Write data to Firebase
        //let myOldJobsRef = FIRDatabase.database().referenceFromURL(self.oldJobsURL())
        let firebaseRef = FIRDatabase.database().reference()
       // myOldJobsRef.child(job.ID).setValue(["ID": job.ID, "description": job.description, "dueBy": job.dueBy, "doneAt": doneAt])
        firebaseRef.child("new").child(newCommentID).setValue(["ID":newCommentID, "userID": myUid, "createdAt": createdAt, "message": "this is a test"])
        
        // Upload the file to the path "images/rivers.jpg"
        let uploadRef = storageRef?.child("storage/myfirstfile.cds")
        let uploadTask = uploadRef!.putFile(recordingURL, metadata: nil) { metadata, error in
            if (error != nil) {
                // Uh-oh, an error occurred!
                print ("Error in upload")
            } else {
                // Metadata contains file metadata such as size, content-type, and download URL.
                let downloadURL = metadata!.downloadURL
                print ("Download your file at....")
            }
        }
        
       // let currentJobsRef = FIRDatabase.database().referenceFromURL(self.jobsURL())
       // currentJobsRef.child(job.ID).removeValue()
        
    }
    
    

  /*
    func setJobDone(job : Job) {
        let doneAt = round(NSDate().timeIntervalSince1970)
        // Write data to Firebase
        let myOldJobsRef = FIRDatabase.database().referenceFromURL(self.oldJobsURL())
        myOldJobsRef.child(job.ID).setValue(["ID": job.ID, "description": job.description, "dueBy": job.dueBy, "doneAt": doneAt])
        
        let currentJobsRef = FIRDatabase.database().referenceFromURL(self.jobsURL())
        currentJobsRef.child(job.ID).removeValue()
        
    }
    
    func addNewJob (job : Job) {
        let jobsRef = FIRDatabase.database().referenceFromURL(self.jobsURL())
        jobsRef.child(job.ID).setValue(["ID": job.ID, "description": job.description, "dueBy": job.dueBy])
    }
 */
    
    
    
    
}