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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        
        textToSpeech.speak(text: "Welcome, Tap Twice to start the game")
    }
    
    @objc func doubleTapped() {
        if let spinWheelViewController = storyboard?.instantiateViewController(withIdentifier: "QuizViewController") {
            spinWheelViewController.modalPresentationStyle = .fullScreen
            present(spinWheelViewController, animated: true)
        }
    }
}
