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
        get { return 12 }
    }
    var itemsPerColumn: Int {
        get { return 18 }
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
        get { return -(self.size.width - (self.itemSize * CGFloat(self.itemsPerColumn))) }
    }
    var yOffset: CGFloat {
        get { return -(self.size.height - (self.itemSize * CGFloat(self.itemsPerRow))) / 2 }
    }
    
}
