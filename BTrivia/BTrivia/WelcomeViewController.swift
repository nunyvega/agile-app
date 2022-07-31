//
//  WelcomeViewController.swift
//  BTrivia
//
//  Created by Isabela Karen Louli on 19.07.22.
//

import UIKit
import AVFoundation

final class WelcomeViewController: UIViewController {

    var textToSpeech: TextToSpeech = TextToSpeech()
    let welcomeText = "Welcome to our game! Swipe Right to start a single player game, Swipe left to start a multiplayer game, Tap twice to learn how to play the game"
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addSwipeGestureRecognizer()
        textToSpeech.speak(text: welcomeText)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        self.view.addGestureRecognizer(longPressRecognizer)
    }
    
    @objc func longPressed(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            textToSpeech.speak(text: "Swipe Right to start a single player game, Swipe left to start a multiplayer game, Tap twice to learn how to play the game")
        }
    }
    
    func addSwipeGestureRecognizer() {
        
        let directions: [UISwipeGestureRecognizer.Direction] = [.right, .left]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
            gesture.direction = direction
            self.view.addGestureRecognizer(gesture)
        }
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        doubleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTap)
    }
    
    func startNewGame() {
        if let quizView = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "QuizViewController") as? QuizViewController {
            self.navigationController?.pushViewController(quizView, animated: true)
        }
    }
    
    func startOnlineGame() {
        textToSpeech.speak(text: "In development")
    }
    
    @objc func doubleTapped() {
        if textToSpeech.synthesizer.isSpeaking == false {
            textToSpeech.speak(text: "Welcome to BTrivia's game instructions. Show us how many correct questions you can get right in a row! On each round, start by shaking your phone to spin the wheel and select a random category and question. You will get a question and four possible answers. Swipe up, down, left or right to select your answer. If you get it right, you'll get a point and move to the next round. If you get it wrong, BTrivia will let you know your final score.")
        }
    }
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        if textToSpeech.synthesizer.isSpeaking == false {
            let direction = sender.direction
            switch direction {
                case .right:
                 startNewGame()
            case .left:
                startOnlineGame()
            default: break
            }
        }
    }
}
