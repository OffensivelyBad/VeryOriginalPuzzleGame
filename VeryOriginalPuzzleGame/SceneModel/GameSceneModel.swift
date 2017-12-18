//
//  GameSceneModel.swift
//  VeryOriginalPuzzleGame
//
//  Created by Shawn Roller on 12/16/17.
//  Copyright © 2017 Shawn Roller. All rights reserved.
//

import SpriteKit

struct GameSceneModel: GameSceneSceneModel {
    
    func getBackgroundSprite() -> SKSpriteNode {
        let background = SKSpriteNode(imageNamed: FileNames.Background)
        background.zPosition = Positions.BackgroundZPosition
        return background
    }
    
}
