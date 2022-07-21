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

class QuizViewController: UIViewController, SoundPlayerDelegate {

    var triviaData = [TriviaModel]()
    var currentQuestion: TriviaModel?
    var selectedTopic = ""
    var shouldRunTheWheel = true
    var totalPoints = 0
    let topics = ["entertainment","art","sports","history","geography","science"]
    
    var textToSpeech = TextToSpeech()
    var soundPlayer = SoundPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        soundPlayer.delegate = self
        
        addSwipeGestureRecognizer()
        addLongPressGestureRecognizer()
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        textToSpeech.speak(text: "Spin the wheel")
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?){
        if motion == .motionShake && shouldRunTheWheel {
            soundPlayer.playSound(songName: "spinwheeleffect")
            getTopic()
            shouldRunTheWheel = false
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    func audioPlayerDidFinishPlaying() {
        if let currentQuestion = currentQuestion, currentQuestion.alreadyAnswer == false {
            print("Answer \(currentQuestion.answer)")
            textToSpeech.speak(text: "The Topic is: \(selectedTopic), The question is: \(currentQuestion.questionAndOptions)")
        }
    }
    
    func getTopic() {
        if let randomElement = topics.randomElement() {
            print("New topic: \(randomElement)")
            selectedTopic = randomElement
            getCurrentQuestion()
        }
    }
    
    func addLongPressGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
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
        if shouldRunTheWheel == false {
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
    }
    
    @objc func doubleTapped() {
        textToSpeech.speak(text: "Your points are: \(totalPoints)")
    }
    
    func checkIfAnswerIsCorrect(userAnswer: Options) {
        if userAnswer.rawValue == currentQuestion?.answer {
            soundPlayer.playSound(songName: "correctAnswer")
            totalPoints += 10
        } else {
            soundPlayer.playSound(songName: "wrongAnswer")
            totalPoints = 0
        }
        
        shouldRunTheWheel = true
        setLocalAlreadyAnswerQuestions()
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
        }
    }
    
    func filterBy(topic: String) -> [TriviaModel] {
        return triviaData.filter({ question in
            question.topic == topic
        })
    }
    
    func getCurrentQuestion() {
        let filteredData = filterBy(topic: selectedTopic).filter(){$0.alreadyAnswer != true}
        if let randomQuestion = filteredData.randomElement() {
            currentQuestion = randomQuestion
        }
    }
    
    func setLocalAlreadyAnswerQuestions() {
        if let index = triviaData.firstIndex(where: {$0.id == currentQuestion?.id}) {
            triviaData[index].alreadyAnswer = true
            currentQuestion?.alreadyAnswer = true
        }
    }
}
