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

class Ball {
	var node: SKSpriteNode
	init(radius: CGFloat, image: UIImage) {
		node = SKSpriteNode(texture: SKTexture(image: image))
		node.physicsBody = SKPhysicsBody(circleOfRadius: radius)
		node.physicsBody?.isDynamic = true
		node.physicsBody?.allowsRotation = false
		node.physicsBody?.affectedByGravity = false
		node.physicsBody?.linearDamping = 0
		node.physicsBody?.angularDamping = 0
		node.physicsBody?.friction = 0
	}
	
	private func collisionHandler() {
		
	}
}
