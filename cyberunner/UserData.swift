//
//  UserData.swift
//  cyberunner
//
//  Created by Sthefanny Gonzaga on 05/02/22.
//

import Foundation

class UserData {
    let bestScore = "bestScore"
    let soundSettings = "soundSettings"
    let defaults = UserDefaults.standard
    
    func saveBestScore(score: Int) {
        let lastBest = getBestScore()
        
        if score > lastBest {
            defaults.set(score, forKey: bestScore)
        }
    }
    
    func getBestScore() -> Int {
        return defaults.integer(forKey: bestScore)
    }
}
