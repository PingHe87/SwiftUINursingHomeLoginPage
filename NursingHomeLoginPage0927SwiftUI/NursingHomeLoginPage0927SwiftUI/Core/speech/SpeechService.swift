//
//  SpeechService.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 10/18/24.
//

import Foundation
import AVFoundation

class SpeechService {
    private let synthesizer = AVSpeechSynthesizer()

    func speak(text: String) {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .duckOthers)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            synthesizer.speak(utterance)
        } catch {
            print("Error activating audio session: \(error)")
        }
    }
}

