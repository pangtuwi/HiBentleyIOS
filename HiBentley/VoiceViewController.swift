//
//  VoiceViewController.swift
//  HiBentley
//
//  Created by Paul Williams on 11/08/2016.
//  Copyright © 2016 BentleyMotors. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class VoiceViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate{

    @IBOutlet weak var recordVoice: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    var myUid = ""
    var recordingURL: NSURL?
    
    
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?

    func directoryURL() -> NSURL? {
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.URLByAppendingPathComponent("sound.caf")  //was .caf   was .m4a
       // print (soundURL)
        return soundURL
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton.enabled = false
        stopButton.enabled = false
        
        recordingURL = directoryURL()
        let recordSettings : [String : AnyObject] =
            [AVEncoderAudioQualityKey: AVAudioQuality.Min.rawValue,
            // AVFormatIDKey : NSNumber(int: Int32(kAudioFormatMPEGLayer3)),
             AVEncoderBitRateKey: 16,
             AVNumberOfChannelsKey: 2,
             AVSampleRateKey: 44100.0]
        
        var error: NSError?
        
        let audioSession = AVAudioSession.sharedInstance()
        
        let audioOptions  : AVAudioSessionCategoryOptions = []
        try! audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord,
                                 withOptions: audioOptions)
        
        if let err = error {
            print("audioSession error: \(err.localizedDescription)")
        }
        
        try! audioRecorder = AVAudioRecorder(URL : recordingURL!, settings: recordSettings)
        
        if let err = error {
            print("audioSession error: \(err.localizedDescription)")
        } else {
            audioRecorder?.prepareToRecord()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    func record() {
        //init
        let audioSession:AVAudioSession = AVAudioSession.sharedInstance()
        
        //ask for permission
        if (audioSession.respondsToSelector(#selector(AVAudioSession.requestRecordPermission(_:)))) {
            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                if granted {
                    print("granted")
                    
                    //set category and activate recorder session
                    try! audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
                    try! audioSession.setActive(true)
                    
                    let url = self.directoryURL()
                    
                    let recordSettings = [AVSampleRateKey : NSNumber(float: Float(44100.0)),
                        AVFormatIDKey : NSNumber(int: Int32(kAudioFormatMPEG4AAC)),
                        AVNumberOfChannelsKey : NSNumber(int: 1),
                        AVEncoderAudioQualityKey : NSNumber(int: Int32(AVAudioQuality.Medium.rawValue))]
                    
                    //record
                    try! self.audioRecorder = AVAudioRecorder(URL: url!, settings: recordSettings)
                    
                } else{
                    print("not granted")
                }
            })
        }

    } //func Record
    
    @IBAction func recordAudio(sender: AnyObject) {
        if audioRecorder?.recording == false {
            playButton.enabled = false
            stopButton.enabled = true
            audioRecorder?.record()
        }
    }
    
    @IBAction func stopAudio(sender: AnyObject) {
        stopButton.enabled = false
        playButton.enabled = true
        recordVoice.enabled = true
        
        if audioRecorder?.recording == true {
            audioRecorder?.stop()
        } else {
            audioPlayer?.stop()
        }
    }
    
    @IBAction func playAudio(sender: AnyObject) {
        if audioRecorder?.recording == false {
            stopButton.enabled = true
            recordVoice.enabled = false
            
            var error: NSError?
            
            //audioPlayer = AVAudioPlayer(contentsOfURL: audioRecorder?.url,error: &error)
            try! audioPlayer = AVAudioPlayer(contentsOfURL: (audioRecorder?.url)!)
            audioPlayer?.delegate = self
            API.sharedInstance.cds.createNewComment(recordingURL!)
            
            if let err = error {
                print("audioPlayer error: \(err.localizedDescription)")
            } else {
                audioPlayer?.play()
            }
        }
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        recordVoice.enabled = true
        stopButton.enabled = false
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
        print("Audio Play Decode Error")
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        

    }
    
    func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder, error: NSError?) {
        print("Audio Record Encode Error")
    }
    
}

