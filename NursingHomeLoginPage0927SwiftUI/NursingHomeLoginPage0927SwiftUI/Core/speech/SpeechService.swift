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
    
    // Function to speak a given text
    func speak(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")  // Set language to English
        synthesizer.speak(utterance)
    }
}
