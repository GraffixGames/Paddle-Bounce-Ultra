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

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var playerCore = SKShapeNode()
    var projectile = SKShapeNode()
	var goodBalls = [SKShapeNode]()
	var badBalls = [SKShapeNode]()

    override func didMove(to view: SKView) {
		physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
		createPlayerCore()
		let spawnBall = SKAction.run {
			self.createProjectile()
		}
		run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 3), spawnBall])))
		playerCore = childNode(withName: "playerCore") as! SKShapeNode
		playerCore.physicsBody?.categoryBitMask = PhysicsCategory.playerCore
		physicsWorld.contactDelegate = self
		playerCore.physicsBody!.contactTestBitMask = PhysicsCategory.goodBall | PhysicsCategory.badBall
    }
	
	func didBegin(_ contact: SKPhysicsContact) {
		if (contact.bodyA.categoryBitMask == PhysicsCategory.playerCore) || (contact.bodyB.categoryBitMask == PhysicsCategory.playerCore) {
			if (contact.bodyA.categoryBitMask == PhysicsCategory.goodBall) || (contact.bodyB.categoryBitMask == PhysicsCategory.goodBall) {
				print("goodBall")
				if contact.bodyA.categoryBitMask == PhysicsCategory.goodBall {
					contact.bodyA.node?.removeFromParent()
				}
				else {
					contact.bodyB.node?.removeFromParent()
				}
			}
			else if (contact.bodyA.categoryBitMask == PhysicsCategory.badBall) || (contact.bodyB.categoryBitMask == PhysicsCategory.badBall) {
				print("badBall")
				if contact.bodyA.categoryBitMask == PhysicsCategory.badBall {
					contact.bodyA.node?.removeFromParent()
				}
				else {
					contact.bodyB.node?.removeFromParent()
				}
			}
		}
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
		if arc4random_uniform(2) == 0 {
			projectile.name = "goodBall"
			projectile.fillColor = UIColor.green
			projectile.physicsBody?.categoryBitMask = PhysicsCategory.goodBall
		}
		else {
			projectile.name = "badBall"
			projectile.fillColor = UIColor.red
			projectile.physicsBody?.categoryBitMask = PhysicsCategory.badBall
		}
        self.addChild(projectile)
		if projectile.name == "goodBall" {
			goodBalls.append(projectile)
		}
		else {
			badBalls.append(projectile)
		}
    }
	
    
}
