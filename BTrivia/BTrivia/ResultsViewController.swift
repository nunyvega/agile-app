//
//  ResultsViewController.swift
//  BTrivia
//
//  Created by Isabela Karen Louli on 19.07.22.
//

import UIKit

class ResultsViewController: UIViewController {

    var finalPoints = 0
    var textToSpeech = TextToSpeech()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        textToSpeech.speak(text: "Your final score is: \(finalPoints)")
    }
}
