//
//  QuizViewController.swift
//  BTrivia
//
//  Created by Isabela Karen Louli on 19.07.22.
//

import UIKit
import AVFoundation

class QuizViewController: UIViewController, SoundPlayerDelegate {

    var triviaData = [TriviaModel]()
    var currentQuestion: TriviaModel?
    var selectedTopic = ""
    var currentDificulty: Difficulty = .easy
    var shouldChangeDificulty = false
    var shouldRunTheWheel = true
    var gameOver = false
    var totalPoints = 0
    var totalLives = 3
    
    var topics = [String]()
    var answeredQuestionsCount = 0
    
    enum Options: String {
        case right = "right"
        case left = "left"
        case up = "up"
        case down = "down"
    }

    enum Difficulty: String {
        case hard = "hard"
        case easy = "easy"
        case medium = "medium"
    }
    
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
        
        textToSpeech.speak(text: "Shake the phone to spin the wheel")
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?){
        if motion == .motionShake && shouldRunTheWheel {
            soundPlayer.playSound(songName: "spinwheeleffect")
            calculateCurrentDifficulty()
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
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        self.view.addGestureRecognizer(longPressRecognizer)
    }
    
    func addSwipeGestureRecognizer() {
        let directions: [UISwipeGestureRecognizer.Direction] = [.right, .left, .up, .down]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
            gesture.direction = direction
            self.view.addGestureRecognizer(gesture)
        }
    }
    
    @objc func longPressed(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {

        }
    }
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        if shouldRunTheWheel == false {
            let direction = sender.direction
            switch direction {
                case .right:
                    checkIfAnswerIsCorrect(userAnswer: .right)
                case .left:
                    checkIfAnswerIsCorrect(userAnswer: .left)
                case .up:
                    checkIfAnswerIsCorrect(userAnswer: .up)
                case .down:
                checkIfAnswerIsCorrect(userAnswer: .down)
            default: break
            }
        }
    }
    
    @objc func doubleTapped() {
        let plural = totalLives > 1 ? "lives" : "life"
        textToSpeech.speak(text: "You got \(totalPoints) points and you stil have \(totalLives) \(plural)")
    }
    
    func checkIfAnswerIsCorrect(userAnswer: Options) {
        
        if userAnswer.rawValue == currentQuestion?.answer {
            soundPlayer.playSound(songName: "correctAnswer")
            totalPoints += currentDificulty == .easy ? 10 : currentDificulty == .medium ? 20 : 30
        } else {
            soundPlayer.playSound(songName: "wrongAnswer")
            addALiveSystem()
            
            if gameOver == false {
                let plural = totalLives > 1 ? "lives" : "life"
                let correctText = totalLives == 0 ? "You lost your last life, one more wrong answer and the game will end" : "You lost 1 life, you still have \(totalLives) \(plural)"
                textToSpeech.speak(text: correctText)
            }
        }
        
        answeredQuestionsCount += 1
        
        if answeredQuestionsCount >= 3 {
            shouldChangeDificulty = true
            answeredQuestionsCount = 0
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
        if let triviaModel = loadJson(filename: "generated_questions") {
            getCategories(from: triviaModel)
            triviaData = triviaModel
        }
    }
    
    func getCategories(from questions: [TriviaModel]) {
        topics = Array(Set(questions.compactMap { $0.topic }))
    }
    
    func filterBy(topic: String) -> [TriviaModel] {
        print("The current dificulty is: \(currentDificulty.rawValue)")
        return triviaData.filter({ question in
            question.topic == topic && question.difficulty == currentDificulty.rawValue
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
    
    func calculateCurrentDifficulty() {
        if shouldChangeDificulty {
            shouldChangeDificulty = false
            switch currentDificulty {
            case .hard:
                currentDificulty = .easy
            case .easy:
                currentDificulty = .medium
            case .medium:
                currentDificulty = .hard
            }
        }
    }
    
    func addALiveSystem() {
        totalLives -= 1
        if totalLives < 0 {
            gameOver = true
            if let resultsView = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ResultsViewController") as? ResultsViewController {
                resultsView.finalScore = totalPoints
                self.navigationController?.pushViewController(resultsView, animated: true)
            }
        }
    }
}
