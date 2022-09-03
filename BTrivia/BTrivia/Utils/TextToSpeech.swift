//
//  TextToSpeech.swift
//  BTrivia
//
//  Created by Isabela Karen Louli on 19.07.22.
//

import AVFoundation
import UIKit

protocol TextToSpeechDelegate: AnyObject {
    func speechSynthesizer(didFinish utterance: AVSpeechUtterance)
}

class TextToSpeech: NSObject, AVSpeechSynthesizerDelegate  {
    
    weak var delegate: TextToSpeechDelegate?
    var synthesizer = AVSpeechSynthesizer()
    
    override init() {
        super.init()
        synthesizer.delegate = self
    }

    func speak(text:String) {
        // 1
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance.rate = 0.4
        //2
        synthesizer.speak(utterance)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        delegate?.speechSynthesizer(didFinish: utterance)
    }
}
