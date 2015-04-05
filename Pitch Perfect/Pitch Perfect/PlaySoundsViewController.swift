//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Naresh Chavda on 3/19/15.
//  Copyright (c) 2015 Naresh Chavda. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var receivedAudioRecording:AudioRecording!
    var audioEngine: AVAudioEngine!
    var audioFile:AVAudioFile!
    
    var overrideError: NSError?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudioRecording.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudioRecording.filePathUrl, error: nil)

        // Playback sound is too low on iPhone
        // http://stackoverflow.com/questions/5662297/how-to-record-and-play-sound-in-iphone-app?rq=1
        if AVAudioSession.sharedInstance().overrideOutputAudioPort(.Speaker, error: &overrideError) {
            
        }else {
            println("error in overridOutputAudioPort " + overrideError!.localizedDescription)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func stopAudioPlayer() {
        // stopy audioPlayer and audioPlayerNode
        audioPlayer.stop()
        audioEngine.stop()
    }
    
    func playAudioWithVariableRate(rate: Float) {
        audioPlayer.stop()
        audioEngine.stop()
        audioPlayer.rate = rate
        audioPlayer.play()

    }
    
    func playAudioWithEffect(senderButton: Int){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)

        switch senderButton {
        case 2:
            var changeEffect = AVAudioUnitTimePitch()
            changeEffect.pitch = 1000
            audioEngine.attachNode(changeEffect)
            audioEngine.connect(audioPlayerNode, to: changeEffect, format: nil)
            audioEngine.connect(changeEffect, to: audioEngine.outputNode, format: nil)
        case 3:
            var changeEffect = AVAudioUnitTimePitch()
            changeEffect.pitch = -1000
            audioEngine.attachNode(changeEffect)
            audioEngine.connect(audioPlayerNode, to: changeEffect, format: nil)
            audioEngine.connect(changeEffect, to: audioEngine.outputNode, format: nil)
        case 4:
            var changeEffect = AVAudioUnitReverb()
            changeEffect.wetDryMix = 100
            audioEngine.attachNode(changeEffect)
            audioEngine.connect(audioPlayerNode, to: changeEffect, format: nil)
            audioEngine.connect(changeEffect, to: audioEngine.outputNode, format: nil)
        default:
            println("ERROR - unknown audio effect")
        }
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }

    // Audio buttons invoke common function
    // Each button has a unique tag value
    // playAudioEffect eliminates IBAction for each button
    @IBAction func playAudioEffect(sender: UIButton) {
        let senderButton = sender.tag
        switch senderButton {
        case 0: // Snail
            playAudioWithVariableRate(0.5)
        case 1: // Rabbit
            playAudioWithVariableRate(1.5)
        case 2, 3, 4: // Chipmunk, Darth Vader, Reverberate
            playAudioWithEffect(senderButton)
        default:
            println("No Audio Effect!")
            playAudioWithVariableRate(1.0)

        }
    }
}
