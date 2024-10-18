//
//  SpeechService.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 10/17/24.
//

import Foundation
import AVFoundation

class SpeechService {
    private let synthesizer = AVSpeechSynthesizer()

    func speak(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
    }
}
