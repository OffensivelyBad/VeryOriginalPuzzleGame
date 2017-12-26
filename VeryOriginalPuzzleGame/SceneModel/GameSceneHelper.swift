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
    var itemsPerRow: Int { get }
    var itemsPerColumn: Int { get }
    var itemSize: CGFloat { get }
    var halfWidth: CGFloat { get }
    var halfHeight: CGFloat { get }
    var xOffset: CGFloat { get }
    var yOffset: CGFloat { get }
    var columns: [[Item]] { get set }
}

extension GameSceneHelper {
    var itemsPerRow: Int {
        get {
            if UI_USER_INTERFACE_IDIOM() == .pad {
                return 12
            }
            if UI_USER_INTERFACE_IDIOM() == .phone {
                return 12
            }
            return 12
        }
    }
    var itemsPerColumn: Int {
        get {
            if UI_USER_INTERFACE_IDIOM() == .pad {
                return 18
            }
            if UI_USER_INTERFACE_IDIOM() == .phone {
                return 8
            }
            return 18
        }
    }
    var itemSize: CGFloat {
        get { return min(self.size.width / CGFloat(self.itemsPerColumn), self.size.height / CGFloat(self.itemsPerRow)) }
    }
    var halfWidth: CGFloat {
        get { return self.size.width / 2 }
    }
    var halfHeight: CGFloat {
        get { return self.size.height / 2 }
    }
    var xOffset: CGFloat {
        get {
            let totalItemSize = self.itemSize * CGFloat(self.itemsPerColumn)
            return ((self.size.width - totalItemSize) / 2) - (self.halfWidth - self.itemSize / 2)
        }
    }
    var yOffset: CGFloat {
        get {
            let totalItemSize = self.itemSize * CGFloat(self.itemsPerRow)
            return ((self.size.height - totalItemSize) / 2) - (self.halfHeight - self.itemSize / 2)
        }
    }
    var itemScale: CGFloat {
        get {
            let item = Item(imageNamed: FileNames.itemOne)
            let width = item.size.width * CGFloat(self.itemsPerColumn)
            let widthScale = self.size.width / width
            let height = item.size.height * CGFloat(self.itemsPerRow)
            let heightScale = self.size.height / height
            return min(widthScale, heightScale)
        }
    }
    
}
