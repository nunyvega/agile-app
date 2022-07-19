//
//  SpinWheelViewController.swift
//  BTrivia
//
//  Created by Isabela Karen Louli on 19.07.22.
//

import UIKit
import AVFoundation

class SpinWheelViewController: UIViewController, SoundPlayerDelegate, AVSpeechSynthesizerDelegate {

    let topics = ["entertainment","art","sports","history","geography","science"]
    var selectedTopic = ""
    var welcomeText = "Shake to Spin the Wheel"
    
    var textToSpeech = TextToSpeech()
    var soundPlayer = SoundPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textToSpeech.synthesizer.delegate = self
        soundPlayer.delegate = self
        
        getTopic()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        textToSpeech.speak(text: welcomeText)
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?){
        if motion == .motionShake {
            soundPlayer.playSound(songName: "spinwheeleffect")
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if utterance.speechString != welcomeText {
            let quizViewController = storyboard?.instantiateViewController(withIdentifier: "QuizViewController") as? QuizViewController
            quizViewController?.modalPresentationStyle = .fullScreen
            quizViewController?.currentTopic = selectedTopic
            present(quizViewController!, animated: true)
        }
    }
    
    func audioPlayerDidFinishPlaying() {
        textToSpeech.speak(text: "The Topic is \(selectedTopic)")
    }
    
    func getTopic() {
        if let randomElement = topics.randomElement() {
            selectedTopic = randomElement
        }
    }
}
