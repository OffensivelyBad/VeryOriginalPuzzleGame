//
//  GameSceneHelper.swift
//  VeryOriginalPuzzleGame
//
//  Created by Shawn Roller on 12/17/17.
//  Copyright © 2017 Shawn Roller. All rights reserved.
//

import UIKit
import SpriteKit

protocol GameSceneHelper where Self: SKScene {
    func halfWidth() -> CGFloat
    func halfHeight() -> CGFloat
}

extension GameSceneHelper {
    func halfWidth() -> CGFloat {
        return self.size.width / 2
    }
    
    func halfHeight() -> CGFloat {
        return self.size.height / 2
    }
}
