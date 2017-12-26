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
    
    // Game properties
    var columns: [[Item]] = []
    var currentMatches = Set<Item>()
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        setupInitialScene()
        createItemsForGrid()       
        
    }
    
    override func sceneDidLoad() {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }
        guard let tappedItem = self.item(at: location) else { return }
        self.currentMatches.removeAll()
        self.match(item: tappedItem)
        removeMatches()
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
    
    private func createItemsForGrid() {
        for x in 0..<self.itemsPerRow {
            var col = [Item]()
            
            for y in 0..<self.itemsPerColumn {
                let item = createItem(row: x, col: y)
                col.append(item)
            }
            self.columns.append(col)
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
        let item = Item(imageNamed: itemImage)
        item.scale(to: CGSize(width: item.size.width * self.itemScale, height: item.size.height * self.itemScale))
        item.zPosition = Positions.ItemZPosition
        item.name = itemImage
        item.row = row
        item.col = col
        item.position = position(for: item)
        addChild(item)
        return item
        
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
            if item.name == original.name {
                match(item: item)
            }
        }
    }
    
    private func removeMatches() {
        for item in self.currentMatches {
            item.removeFromParent()
        }
    }
    
}
