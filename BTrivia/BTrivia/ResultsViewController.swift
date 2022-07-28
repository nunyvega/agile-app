//
//  ResultsViewController.swift
//  BTrivia
//
//  Created by Isabela Karen Louli on 27.07.22.
//

import UIKit

class ResultsViewController: UIViewController {
    
    var textToSpeech: TextToSpeech = TextToSpeech()
    var finalScore = 0
    let defaults = UserDefaults.standard

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        
        let highScore = defaults.integer(forKey: "finalScore")
        
        let text = finalScore > highScore ? "you have a new highScore of \(finalScore) points" : "your final score is: \(finalScore)"
        
        textToSpeech.speak(text: "This is the end of this game, \(text) , tap twice to go back to home screen")
        
        if finalScore > highScore {
            defaults.set(finalScore, forKey: "finalScore")
        }
    }
    
    @objc func doubleTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
