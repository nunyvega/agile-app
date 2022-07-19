//
//  QuizViewController.swift
//  BTrivia
//
//  Created by Isabela Karen Louli on 19.07.22.
//

import UIKit
import AVFoundation

enum Options: String {
    case a = "a"
    case b = "b"
    case c = "c"
    case d = "d"
}

class QuizViewController: UIViewController {

    var triviaData = [TriviaModel]()
    var correctAnswer = "a"
    var currentTopic = ""
    
    var textToSpeech = TextToSpeech()
    var soundPlayer = SoundPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSwipeGestureRecognizer()
        loadData()
    }
    
    func addSwipeGestureRecognizer() {
        let directions: [UISwipeGestureRecognizer.Direction] = [.right, .left, .up, .down]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
            gesture.direction = direction
            self.view.addGestureRecognizer(gesture)
        }
    }
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        let direction = sender.direction
        switch direction {
            case .right:
                checkIfAnswerIsCorrect(userAnswer: .a)
            case .left:
                checkIfAnswerIsCorrect(userAnswer: .b)
            case .up:
                checkIfAnswerIsCorrect(userAnswer: .c)
            case .down:
            checkIfAnswerIsCorrect(userAnswer: .d)
        default: break
        }
    }
    
    // TODO: Finish this
    func checkIfAnswerIsCorrect(userAnswer: Options) {
        
    }
    
    func loadJson(filename fileName: String) -> [TriviaModel]? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(TriviaModelResponse.self, from: data)
                return jsonData.trivia
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
    
    func loadData() {
        if let triviaModel = loadJson(filename: "questions") {
            triviaData = triviaModel
            filterBy(topic: currentTopic)
            
        }
    }
    
    func filterBy(topic: String) {
        triviaData = triviaData.filter({ question in
            question.topic == topic
        })
        textToSpeech.speak(text: triviaData[0].questionAndOptions)
    }

}
