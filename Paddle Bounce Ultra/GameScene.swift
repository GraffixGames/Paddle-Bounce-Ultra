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
        let spawnBall = SKAction.run {
            self.createProjectile()
        }
        run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 3), spawnBall])))
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
		let radius: CGFloat = 24
        let projectile = SKShapeNode(circleOfRadius: radius)
        if arc4random_uniform(2) == 0 {
            projectile.name = "goodBall"
            projectile.fillColor = UIColor.green
        }
        else {
            projectile.name = "badBall"
            projectile.fillColor = UIColor.red
		}
        let width = Double(arc4random_uniform(UInt32(frame.width - radius * 2))) + Double(radius)
        let height = Double(arc4random_uniform(UInt32(frame.height - radius * 2))) + Double(radius)
        projectile.position = CGPoint(x: width, y: -height)
		projectile.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        projectile.physicsBody?.isDynamic = false
        self.addChild(projectile)
    }

    
    
}
