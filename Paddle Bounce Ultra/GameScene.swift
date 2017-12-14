//
//  GameScene.swift
//  Paddle Bounce Ultra
//
//  Created by  on 12/14/17.
//  Copyright © 2017 Hi-Crew. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        
    }
    
    func oneLittleCircle(){
        var Circle = SKShapeNode(circleOfRadius: 100 )
        Circle.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        Circle.strokeColor = SKColor.black
        Circle.glowWidth = 1.0
        Circle.fillColor = SKColor.orange
        self.addChild(Circle)
    }
}
