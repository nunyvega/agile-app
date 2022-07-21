//
//  TriviaModel.swift
//  BTrivia
//
//  Created by Isabela Karen Louli on 19.07.22.
//

struct TriviaModelResponse: Codable {
    let trivia: [TriviaModel]
}

struct TriviaModel: Codable {
    let id: Int
    let topic, difficulty, questionAndOptions, answer: String
    
    var alreadyAnswer: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id, topic, difficulty, questionAndOptions, answer
    }
}
