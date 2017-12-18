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
    var projectile = SKShapeNode()
    
    override func didMove(to view: SKView) {
        createPlayerCore()
        createProjectile()
    }
    
    func createPlayerCore() {
        playerCore = SKShapeNode(circleOfRadius: 75 )
        playerCore.name = "playerCore"
        playerCore.position = CGPoint(x: frame.midX, y: frame.midY)
        playerCore.fillColor = UIColor.blue
        playerCore.physicsBody = SKPhysicsBody(circleOfRadius: 75)
        playerCore.physicsBody?.isDynamic = false
        self.addChild(playerCore)
    }
    
    func createProjectile() {
        let projectile = SKShapeNode(circleOfRadius: 30)
        if arc4random_uniform(2) == 0 {
            projectile.name = "goodBall"
            projectile.fillColor = UIColor.green
        }
        else {
            projectile.name = "badBall"
            projectile.fillColor = UIColor.red
        }
        let width = Double(arc4random_uniform(UInt32(frame.width)))
        let height = Double(arc4random_uniform(UInt32(frame.height)))
        projectile.position = CGPoint(x: width, y: height)
        projectile.physicsBody?.isDynamic = false
        self.addChild(projectile)
    }

    
    
}
