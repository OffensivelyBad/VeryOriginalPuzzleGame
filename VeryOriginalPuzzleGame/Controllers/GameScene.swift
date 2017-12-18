//
//  GameScene.swift
//  VeryOriginalPuzzleGame
//
//  Created by Shawn Roller on 12/16/17.
//  Copyright © 2017 Shawn Roller. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, GameSceneHelper {
    
    var sceneModel: GameSceneSceneModel!
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        setupInitialScene()
    }
    
    override func sceneDidLoad() {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {

    }
}

// MARK: - Setup initial State

extension GameScene {
    
    private func setupInitialScene() {
        let background = self.sceneModel.getBackgroundSprite()
        self.addChild(background)
    }
    
}
