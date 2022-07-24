//
//  TextToSpeech.swift
//  BTrivia
//
//  Created by Isabela Karen Louli on 19.07.22.
//

import AVFoundation
import UIKit

protocol SpeakTriviaDelegate: AnyObject {
    func speechSynthesizer(speechText: String)
}

struct TextToSpeech {
    
    var synthesizer = AVSpeechSynthesizer()

    func speak(text:String) {
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance.rate = 0.4
        
        synthesizer.speak(utterance)
    }
}
