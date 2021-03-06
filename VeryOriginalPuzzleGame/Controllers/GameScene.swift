//
//  GameScene.swift
//  VeryOriginalPuzzleGame
//
//  Created by Shawn Roller on 12/16/17.
//  Copyright © 2017 Shawn Roller. All rights reserved.
//

import SpriteKit
import GameplayKit

/* todo:
 animate the initial pieces in
 animate the removed pieces out
 */

class GameScene: SKScene, GameSceneHelper {
    var sceneModel: GameSceneSceneModel!
    
    // Game properties
    var columns: [[Item]] = []
    var currentMatches = Set<Item>()
    var testMatches = Set<Item>()
    let scoringLabel = SKLabelNode(fontNamed: "Noteworthy-Bold")
    var score = 0 {
        didSet {
            self.scoringLabel.text = "Score: \(score)"
        }
    }
    let movesLabel = SKLabelNode(fontNamed: "Noteworthy-Bold")
    var movesRemaining = 0 {
        didSet {
            self.movesLabel.text = "\(max(0, movesRemaining)) Moves Left"
        }
    }
    let music = SKAudioNode(fileNamed: Sounds.Music)
    let hintNode = SKLabelNode(fontNamed: "Noteworthy-Bold")
    var hintsUsed = 0
    var isGameOver = false
    
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        setupInitialScene()
        createItemsForGrid()       
        
    }
    
    override func sceneDidLoad() {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !self.isGameOver else {
            restartScene()
            return
        }
        guard self.movesRemaining > 0 else { return }
        guard let location = touches.first?.location(in: self) else { return }
        guard let tappedItem = self.item(at: location) else {
            let hint = self.nodes(at: location).flatMap { $0.name == FileNames.hintName }.first
            if hint != nil {
                hintTapped()
            }
            return
        }
    
        self.isUserInteractionEnabled = false
        self.currentMatches.removeAll()
        
        if tappedItem.name == "bomb" {
            run(SKAction.playSoundFileNamed(Sounds.Bomb, waitForCompletion: false))
            triggerBomb(tappedItem)
        } else {
            run(SKAction.playSoundFileNamed(Sounds.Zap, waitForCompletion: false))
        }
        
        self.match(item: tappedItem)
        removeMatches()
        self.movesRemaining -= 1
        moveDown()
        adjustScore()
        
        if self.movesRemaining <= 0 {
            self.music.removeFromParent()
            run(SKAction.playSoundFileNamed(Sounds.Pop, waitForCompletion: false))
            addChild(SKAudioNode(fileNamed: Sounds.WinningMusic))
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                self.endGame()
            })
        } else {
            if self.score >= self.hintsUsed * GameRules.hintsPerScore {
                self.hintNode.isHidden = false
            }
        }
    }

}

// MARK: - Scene management
extension GameScene {
    
    private func setupInitialScene() {
        let background = self.sceneModel.getBackgroundSprite()
        self.addChild(background)
        
        self.scoringLabel.horizontalAlignmentMode = .right
        self.scoringLabel.position = self.scorePoint
        self.scoringLabel.fontSize = 20
        addChild(self.scoringLabel)
        self.score = 0
        
        self.movesLabel.horizontalAlignmentMode = .left
        self.movesLabel.position = self.movesPoint
        self.movesLabel.fontSize = 20
        addChild(self.movesLabel)
        self.movesRemaining = GameRules.InitialMoves
        
        addChild(self.music)
        
        self.hintNode.position = self.hintPoint
        self.hintNode.text = "Hint?"
        self.hintNode.fontSize = 20
        self.hintNode.zPosition = Positions.HintNodeZPosition
        addChild(self.hintNode)
    }
    
    private func createItemsForGrid() {
        for x in 0..<self.itemsPerRow {
            var col = [Item]()
            
            for y in 0..<self.itemsPerColumn {
                let item = createItem(row: y, col: x)
                addChild(item)
                col.append(item)
            }
            self.columns.append(col)
        }
    }
    
    private func endGame() {
        guard !self.isGameOver else { return }
        self.isGameOver = true
        let gameOver = SKSpriteNode(imageNamed: FileNames.GameOver)
        let scaleForScreen = self.size.width / gameOver.size.width
        gameOver.scale(to: CGSize.zero)
        gameOver.zPosition = Positions.GameOverZPosition
        addChild(gameOver)
        
        let scaleAction = SKAction.scale(to: scaleForScreen, duration: 2)
        gameOver.run(scaleAction)
    }
    
    private func restartScene() {
        if let scene = GKScene(fileNamed: "GameScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                
                // Inject the properties
                sceneNode.sceneModel = GameSceneModel()
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .resizeFill
                
                // Present the scene
                if let view = self.view {
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
            }
        }
    }
    
}

// MARK: - Node Management
extension GameScene {
    
    private func createItem(row: Int, col: Int, startOffScreen: Bool = false) -> Item {
        
        var itemImage = FileNames.itemOne
        let itemCount = FileNames.allItems.count - 1
        if itemCount > 0 {
            // Get a random image
            let randomDistribution = GKRandomDistribution(lowestValue: 0, highestValue: itemCount)
            itemImage = FileNames.allItems[randomDistribution.nextInt()]
        }
        // Create a bomb about once in every 25 items
        if startOffScreen && GKRandomSource.sharedRandom().nextInt(upperBound: 25) == 0 {
            itemImage = FileNames.itemBomb
        }
        let item = Item(imageNamed: itemImage)
        item.scale(to: CGSize(width: item.size.width * self.itemScale, height: item.size.height * self.itemScale))
        item.zPosition = Positions.ItemZPosition
        item.name = itemImage
        item.row = row
        item.col = col
        if startOffScreen {
            let finalPosition = position(for: item)
            item.position = finalPosition
            item.position.y += self.halfHeight
            let moveAction = SKAction.move(to: finalPosition, duration: 0.3)
            item.run(moveAction) {
                self.isUserInteractionEnabled = true
            }
        }
        else {
            item.position = position(for: item)
        }
        return item
        
    }
    
    private func moveDown() {
        for (columnIndex, col) in self.columns.enumerated() {
            for (rowIndex, item) in col.enumerated() {
                // Drop items down
                guard item.row != rowIndex else { continue }
                item.row = rowIndex
                let moveAction = SKAction.move(to: position(for: item), duration: 0.1)
                item.run(moveAction)
            }
            
            // Create new items off screen
            while self.columns[columnIndex].count < self.itemsPerColumn {
                let item = createItem(row: self.columns[columnIndex].count, col: columnIndex, startOffScreen: true)
                addChild(item)
                self.columns[columnIndex].append(item)
            }
        }
    }
    
    private func triggerBomb(_ bomb: Item) {
        let flash = SKSpriteNode(color: .white, size: self.frame.size)
        flash.zPosition = Positions.WhiteOverlayZPosition
        addChild(flash)
        flash.run(SKAction.fadeOut(withDuration: 0.2)) {
            flash.removeFromParent()
        }
    }
    
    private func penalizePlayer() {
        self.movesRemaining += GameRules.Penalty
    }
    
    private func adjustScore() {
        let newScore = currentMatches.count
        
        if newScore == 1 {
            penalizePlayer()
        }
        else if newScore == 2 {
            // no change
        } else {
            let matchCount = min(newScore, 16)
            let scoreToAdd = pow(Double(matchCount), 2)
            self.score += Int(scoreToAdd)
        }
    }
    
    private func position(for item: Item) -> CGPoint {
        let x = self.xOffset + (self.itemSize * CGFloat(item.col))
        let y = self.yOffset + (self.itemSize * CGFloat(item.row))
        return CGPoint(x: x, y: y)
    }
    
    private func item(at point: CGPoint) -> Item? {
        let items = nodes(at: point).flatMap { $0 as? Item }
        return items.first
    }
    
    private func match(item original: Item) {
        var checkItems = [Item?]()
        self.currentMatches.insert(original)
        let position = original.position
        
        checkItems.append(item(at: CGPoint(x: position.x, y: position.y - original.size.height)))
        checkItems.append(item(at: CGPoint(x: position.x, y: position.y + original.size.height)))
        checkItems.append(item(at: CGPoint(x: position.x - original.size.width, y: position.y)))
        checkItems.append(item(at: CGPoint(x: position.x + original.size.width, y: position.y)))
        
        for case let item? in checkItems {
            if self.currentMatches.contains(item) { continue }
            if item.name == original.name || original.name == FileNames.itemBomb {
                match(item: item)
            }
        }
    }
    
    private func removeMatches() {
        let sortedMatches = self.currentMatches.sorted { $0.row > $1.row }
        
        for item in sortedMatches {
            self.columns[item.col].remove(at: item.row)
            item.removeFromParent()
        }
    }
    
    private func hintTapped() {
        
        self.hintNode.isHidden = true
        self.hintsUsed += 1
        var topItem = Item()
        var topItemCount = 0
        
        let items = self.children.flatMap { $0 as? Item }
        for item in items {
            self.testMatches.removeAll()
            testMatch(item: item)
            if self.testMatches.count > topItemCount {
                topItem = item
                topItemCount = self.testMatches.count
            }
        }
        
        let hintNode = SKSpriteNode(color: .yellow, size: topItem.size)
        hintNode.name = FileNames.hintName
        topItem.addChild(hintNode)
        
    }
    
    private func testMatch(item original: Item) {
        var checkItems = [Item?]()
        self.testMatches.insert(original)
        let position = original.position
        
        checkItems.append(item(at: CGPoint(x: position.x, y: position.y - original.size.height)))
        checkItems.append(item(at: CGPoint(x: position.x, y: position.y + original.size.height)))
        checkItems.append(item(at: CGPoint(x: position.x - original.size.width, y: position.y)))
        checkItems.append(item(at: CGPoint(x: position.x + original.size.width, y: position.y)))
        
        for case let item? in checkItems {
            if self.testMatches.contains(item) { continue }
            if item.name == original.name || original.name == FileNames.itemBomb {
                testMatch(item: item)
            }
        }
    }
    
}
