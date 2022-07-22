//
//  WelcomeViewController.swift
//  BTrivia
//
//  Created by Isabela Karen Louli on 19.07.22.
//

import UIKit

final class WelcomeViewController: UIViewController {

    var textToSpeech: TextToSpeech = TextToSpeech()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSwipeGestureRecognizer()
        
        textToSpeech.speak(text: "Welcome to our game! Swipe Right to play a new game, Swipe left to play an online game, Tap twice to learn how to play the game")
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
        // TODO: Add game instructions
        if textToSpeech.synthesizer.isSpeaking == false {
            textToSpeech.speak(text: "Game Instructions")
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
