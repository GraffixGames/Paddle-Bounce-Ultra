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
    
    var playerCore = SKShapeNode()
    
    override func didMove(to view: SKView) {
        createPlayerCore()
    }
    
    func createPlayerCore() {
        let playerCore = SKShapeNode(circleOfRadius: 100 )
        playerCore.name = "playerCore"
        playerCore.position = CGPoint(x: frame.width/2, y: -frame.height/2)
        playerCore.fillColor = UIColor.blue
        playerCore.physicsBody = SKPhysicsBody(circleOfRadius: 100)
        playerCore.physicsBody?.affectedByGravity = false
        playerCore.physicsBody?.friction = 0
        playerCore.physicsBody?.isDynamic = false
        self.addChild(playerCore)
    }
    
}
