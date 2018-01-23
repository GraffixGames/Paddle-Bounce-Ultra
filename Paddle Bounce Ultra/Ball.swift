//
//  Ball.swift
//  Paddle Bounce Ultra
//
//  Created by  on 1/10/18.
//  Copyright © 2018 Hi-Crew. All rights reserved.
//
//	Ball Types:
//	posPoints
//	negPoints
//	bigPosPoints
//	bigNegPoints
//	juggernaut
//	gravityWell
//	bigPaddle
//	smallPaddle
//	doublePaddle
//	bomb
//	shield
//	confusion

import Foundation
import SpriteKit

class Ball: SKSpriteNode {
	var collisionHandler: SKAction
	init(radius: CGFloat, image: UIImage, mask: PhysicsCategory.RawValue, collision: SKAction) {
		let sprite = SKTexture(image: image)
		collisionHandler = collision
		super.init(texture: sprite, color: UIColor.white, size: sprite.size())
		physicsBody = SKPhysicsBody(circleOfRadius: radius)
		physicsBody?.categoryBitMask = mask
		physicsBody?.isDynamic = true
		physicsBody?.allowsRotation = false
		physicsBody?.affectedByGravity = false
		physicsBody?.angularDamping = 0
		physicsBody?.linearDamping = 0
		physicsBody?.restitution = 1
		physicsBody?.friction = 0
		zPosition = -1335
		let vel = lengthDir(length: CGFloat(arc4random_uniform(250))+250.0, dir: (CGFloat(arc4random()) / CGFloat(UInt32.max)) * (2 * CGFloat.pi))
		physicsBody?.velocity = CGVector(dx: vel.x, dy: vel.y)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
