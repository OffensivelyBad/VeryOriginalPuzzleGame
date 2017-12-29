//
//  Constants.swift
//  VeryOriginalPuzzleGame
//
//  Created by Shawn Roller on 12/16/17.
//  Copyright © 2017 Shawn Roller. All rights reserved.
//

import UIKit

enum FileNames {
    
    static let Background = "night"
    static let GameOver = "game-over-2"
    
    // Game items
    static let itemOne = "alien-beige"
    static let itemTwo = "alien-blue"
    static let itemThree = "alien-gray"
    static let itemFour = "alien-green"
    static let itemFive = "alien-pink"
    static let itemSix = "alien-purple"
    static let itemSeven = "alien-yellow"
    static let itemBomb = "bomb"
    static var allItems: [String] {
        return [itemOne, itemTwo, itemThree, itemFour, itemFive, itemSix, itemSeven]
    }
    
}

enum Positions {
    
    static let BackgroundZPosition: CGFloat = -2
    static let ItemZPosition: CGFloat = 0
    static let WhiteOverlayZPosition: CGFloat = 2
    static let ScoreZPosition: CGFloat = 1
    static let GameOverZPosition: CGFloat = 10
    
}

enum GameRules {
    
    static let InitialMoves = 2
    static let Penalty = -10
    
}

enum Sounds {
    
    static let Music = "alien-restaurant.mp3"
    static let WinningMusic = "winner-winner.mp3"
    static let Pop = "pop"
    static let Zap = "zap"
    static let Bomb = "smart-bomb"
    
}
