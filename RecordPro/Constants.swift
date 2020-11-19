//
//  Constants.swift
//  RecordPro
//
//  Created by waheedCodes on 19/11/2020.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import Foundation

enum RecordAudioConstants {
    
}

enum RecordAudioErrorConstants {
    static let title = "Error"
    static let message = "Failed to get document directory for recording the audio. Please try again later."
}

enum AudioNameConstants {
    static let defaultName = "MyAudioMemo.m4a"
}

enum ControlConstants {
    static let pause = "Pause"
    static let record = "Record"
}

enum RecordingStatusConstants {
    static let success = "Finish Recording"
    static let successMessage = "Successfully recorded the audio!"
}

enum AudioPlayingConstants {
    static let title = "Finish Playing"
    static let message = "Finish playing the recording!"
}
