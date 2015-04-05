//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Naresh Chavda on 3/16/15.
//  Copyright (c) 2015 Naresh Chavda. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var recordButton: UIButton!

    var audioRecorder:AVAudioRecorder!
    var audioRecording:AudioRecording!
    var recordNewAudio:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        recordingInProgress.text = "Tap microphone to record"
        recordingInProgress.textColor = UIColor.blueColor()
        recordNewAudio = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as AudioRecording
            playSoundsVC.receivedAudioRecording = data
        }
    }

    @IBAction func recordAudio(sender: UIButton) {
        println("in recordAudio")
        if (!recordNewAudio) {
            initializeAudioRecording()
        }
                
        if recordNewAudio {
            if audioRecorder.recording {
                audioRecorder.pause()
                println("pause()... recordNewAudio is \(recordNewAudio) and audioRecorder.recording is \(audioRecorder.recording)")
//                recordingInProgress.text = "Paused... tap microphone to resume recording"
                displayMessage(2)
            }
            else {
                audioRecorder.record()
                println("record()... recordNewAudio is \(recordNewAudio) and audioRecorder.recording is \(audioRecorder.recording)")
//                recordingInProgress.text = "Recording... tap microphone to pause recording"
                displayMessage(1)
            }
          
        }
        else {
            audioRecorder.record()
            println("record()... recordNewAudio is \(recordNewAudio) and audioRecorder.recording is \(audioRecorder.recording)")
            recordNewAudio = true
        }
    }

    @IBAction func stopRecordingAudio(sender: UIButton) {
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    func initializeAudioRecording() {
//        recordingInProgress.text = "Recording... tap microphone to pause recording"
        displayMessage(1)
        recordingInProgress.textColor = UIColor.redColor()
        stopButton.hidden = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            audioRecording = AudioRecording(filePathUrl:recorder.url, title:recorder.url.lastPathComponent)
        
            self.performSegueWithIdentifier("stopRecording", sender: audioRecording)
        } else {
            println("Error - Recording was not successful")
            recordButton.enabled = true
            recordingInProgress.hidden = true
            stopButton.hidden = true
        }
    }
    
    func displayMessage(messageID : Int) {
        switch messageID {
        case 1: // recording in progress
            recordingInProgress.text = "Recording... tap again to pause"
        case 2: // recording is paused
            recordingInProgress.text = "Paused... tap again to resume"
        default:
            println("Error - displayMessage received invalid messageID")
        }
    }
}

