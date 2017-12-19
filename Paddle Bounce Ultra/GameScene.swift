//
//  GameScene.swift
//  Paddle Bounce Ultra
//
//  Created by  on 12/14/17.
//  Copyright © 2017 Hi-Crew. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
	static let none: UInt32 = 0
	static let playerCore: UInt32 = 0b1
	
	static let goodBall: UInt32 = 0b100
	static let badBall: UInt32 = 0b1000
}

class GameScene: SKScene {
    
    var playerCore = SKShapeNode()
    var projectile = SKShapeNode()
	var goodBall = SKShapeNode()
	var badBall = SKShapeNode()

    override func didMove(to view: SKView) {
		physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
		playerCore = childNode(withName: "playerCore") as! SKShapeNode
		goodBall = childNode(withName: "goodBall") as! SKShapeNode
		badBall = childNode(withName: "badBall") as! SKShapeNode
		playerCore.physicsBody?.categoryBitMask = PhysicsCategory.playerCore
		goodBall.physicsBody?.categoryBitMask = PhysicsCategory.goodBall
		badBall.physicsBody?.categoryBitMask = PhysicsCategory.badBall
        createPlayerCore()
        let spawnBall = SKAction.run {
            self.createProjectile()
        }
        run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 3), spawnBall])))
    }
	
//	func didBegin(_ contact: SKPhysicsContact) {
//		
//	}
    
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
        projectile.physicsBody?.isDynamic = true
		projectile.physicsBody?.allowsRotation = false
		projectile.physicsBody?.affectedByGravity = false
		projectile.physicsBody?.friction = 0
		projectile.physicsBody?.restitution = 1
		projectile.physicsBody?.linearDamping = 0
		projectile.physicsBody?.velocity = CGVector(dx: 300, dy: -300)
        self.addChild(projectile)
    }

    
    
}
