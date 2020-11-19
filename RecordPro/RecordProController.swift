//
//  RecordProController.swift
//  RecordPro
//
//  Created by Simon Ng on 11/10/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import AVFoundation

class RecordProController: UIViewController, AVAudioPlayerDelegate {
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    
    @IBOutlet private var stopButton: UIButton!
    @IBOutlet private var playButton: UIButton!
    @IBOutlet private var recordButton: UIButton!
    @IBOutlet private var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable Stop/Play button when the app launches
        stopButton.isEnabled = false
        playButton.isEnabled = false
        
        // Get the document directory. If it fails, just skip the rest of the code
        guard let directoryURL = FileManager.default.urls(
                for: FileManager.SearchPathDirectory.documentDirectory,
                in: FileManager.SearchPathDomainMask.userDomainMask).first else {
            let alert = UIAlertController(title: RecordAudioErrorConstants.title,
                                                 message: RecordAudioErrorConstants.message,
                                                 preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK",
                                                 style: .default,
                                                 handler: nil))
            present(alert, animated: true, completion: nil)
            
            return
        }
        
        // Set the default audio file
        let audioFileURL = directoryURL.appendingPathComponent(AudioNameConstants.defaultName)
        
        // Setup audio session
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord,
                                         options: AVAudioSession.CategoryOptions.defaultToSpeaker)
            
            // Define the recorder setting
            let recorderSetting: [String: Any] = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                                                  AVSampleRateKey: 44100.0,
                                                  AVNumberOfChannelsKey: 2,
                                                  AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            
            // Initiate and prepare the recorder
            try audioRecorder = AVAudioRecorder(url: audioFileURL, settings: recorderSetting)
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.prepareToRecord()
        } catch {
            print(error)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Action methods
    
    @IBAction func stop(sender: UIButton) {
        // Set the record button back to record
        recordButton.setImage(UIImage(
                                named: ControlConstants.record),
                              for: UIControl.State.normal)
        
        // Disable the record button
        recordButton.isEnabled = false
        
        // Disable the stop button
        stopButton.isEnabled = false
        
        // Enable the play button
        playButton.isEnabled = true
        
        // Stop the audio recorder
        audioRecorder?.stop()
        
        // Disable the AVAudioRecorder
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setActive(false)
        } catch {
            print(error)
        }
        
    }
    
    @IBAction func play(sender: UIButton) {
        if let recorder = audioRecorder {
            if !recorder.isRecording {
                audioPlayer = try? AVAudioPlayer(contentsOf: recorder.url)
                audioPlayer?.delegate = self
                audioPlayer?.play()
            }
        }
    }
    
    @IBAction func record(sender: UIButton) {
        // Stop the audio player before recording
        if let player = audioPlayer {
            if player.isPlaying {
                player.stop()
            }
        }
        
        if let recorder = audioRecorder {
            if !recorder.isRecording {
                let audioSession = AVAudioSession.sharedInstance()
                
                do {
                    try audioSession.setActive(true)
                    
                    // Start recording
                    recorder.record()
                    
                    // Change to the pause image
                    recordButton.setImage(UIImage(named: ControlConstants.pause),
                                          for: UIControl.State.normal)
                } catch {
                    print(error)
                }
            } else {
                // Pause recording
                recorder.pause()
                
                // Change back to the record button
                recordButton.setImage(UIImage(named: ControlConstants.record),
                                      for: UIControl.State.normal)
            }
        }
        
        stopButton.isEnabled = true
        playButton.isEnabled = false
    }
    
    // MARK: - AvAudioPlayer Delegate
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playButton.isSelected = false
        
        let alert = UIAlertController(title: AudioPlayingConstants.title,
                                      message: AudioPlayingConstants.message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
}

extension RecordProController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder,
                                         successfully flag: Bool) {
        if flag {
            let alert = UIAlertController(title: RecordingStatusConstants.success,
                                          message: RecordingStatusConstants.successMessage, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default,
                                          handler: nil))
            
            present(alert, animated: true, completion: nil)
        }
    }
}
