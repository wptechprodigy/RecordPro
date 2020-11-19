//
//  RecordProController+Extension.swift
//  RecordPro
//
//  Created by waheedCodes on 19/11/2020.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

extension RecordProController {
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0,
                                     repeats: true, block: { (timer) in
                                        self.elapsedTimeInSeconds += 1
                                        self.updateTimeLabel()
                                     })
    }
    
    func pauseTimer() {
        timer?.invalidate()
    }
    
    func resetTimer() {
        timer?.invalidate()
        elapsedTimeInSeconds = 0
        updateTimeLabel()
    }
    
    func updateTimeLabel() {
        let seconds = elapsedTimeInSeconds % 60
        let minutes = (elapsedTimeInSeconds / 60) % 60
        
        timeLabel.text = String(format: TimeLabelConstants.format, minutes, seconds)
    }
}
