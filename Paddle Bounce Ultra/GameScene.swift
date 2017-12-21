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
    var playerPaddle = SKShapeNode()
    var projectile = SKShapeNode()
    
    let moveAnalogStick = AnalogJoystick(diameter: 110)
    let rotateAnalogStick = AnalogJoystick(diameter: 110)
    
    override func didMove(to view: SKView) {
        
        backgroundColor = UIColor.cyan
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        createPlayerCore()
        createPlayerPaddle()
        createProjectile()
        
        moveAnalogStick.position = CGPoint(x: frame.width * 0.17, y: -(frame.height * 0.8))
        addChild(moveAnalogStick)
        rotateAnalogStick.position = CGPoint(x: frame.width * 0.83, y: -(frame.height * 0.8))
        addChild(rotateAnalogStick)
        
        moveAnalogStick.stick.image = #imageLiteral(resourceName: "nudes")
        rotateAnalogStick.stick.image = #imageLiteral(resourceName: "nudes")
        moveAnalogStick.substrate.image = #imageLiteral(resourceName: "nudes")
        rotateAnalogStick.substrate.image = #imageLiteral(resourceName: "nudes")
        moveAnalogStick.substrate.radius = 75
        moveAnalogStick.stick.radius = 45
        rotateAnalogStick.substrate.radius = 75
        rotateAnalogStick.stick.radius = 45
        
        
        
        moveAnalogStick.trackingHandler = { [unowned self] data in
            self.playerCore.position = CGPoint(x: self.playerCore.position.x + (data.velocity.x * 0.12), y: self.playerCore.position.y + (data.velocity.y * 0.12))
        }
        
        rotateAnalogStick.trackingHandler = { [unowned self] jData in
            if abs(jData.velocity.x) > 4 || abs(jData.velocity.y) > 4 {
                self.playerPaddle.zRotation = jData.angular + CGFloat.pi / 2
            }
        }
        
    }
    
    override func didFinishUpdate() {
        playerPaddle.position.x = playerCore.position.x + lengthDir(length: 120, dir: playerPaddle.zRotation).x
        playerPaddle.position.y = playerCore.position.y + lengthDir(length: 120, dir: playerPaddle.zRotation).y
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
		let size: CGFloat = 64
        playerCore = SKShapeNode(circleOfRadius: size)
        playerCore.name = "playerCore"
        playerCore.position = CGPoint(x: frame.midX, y: frame.midY)
        playerCore.fillColor = UIColor.blue
        playerCore.physicsBody = SKPhysicsBody(circleOfRadius: size)
        playerCore.physicsBody?.isDynamic = true
        playerCore.physicsBody?.affectedByGravity = false
        playerCore.physicsBody?.allowsRotation = false
        self.addChild(playerCore)
    }
    
    func createPlayerPaddle() {
        playerPaddle = SKShapeNode(rectOf: CGSize(width: 10, height: 100))
        playerPaddle.name = "playerPaddle"
        playerPaddle.position.x = playerCore.position.x + lengthDir(length: 120, dir: 0).x
        playerPaddle.position.y = playerCore.position.y + lengthDir(length: 120, dir: 0).y
        print(playerPaddle.position)
        playerPaddle.fillColor = UIColor.black
        playerPaddle.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 100))
        playerPaddle.physicsBody?.isDynamic = true
        playerPaddle.physicsBody?.affectedByGravity = false
        playerPaddle.physicsBody?.allowsRotation = false
        self.addChild(playerPaddle)
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

    func lengthDir(length: CGFloat, dir: CGFloat) -> CGPoint {
        return CGPoint(x: length * cos(dir), y: length * sin(dir))
    }
    
}
