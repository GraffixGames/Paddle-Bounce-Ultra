//
//  PosPoints.swift
//  Paddle Bounce Ultra
//
//  Created by  on 1/16/18.
//  Copyright © 2018 Hi-Crew. All rights reserved.
//

import Foundation
import SpriteKit

class PosPoints: Ball {
	var points: Int
	init() {
		points = 10
		super.init(radius: 24, image: #imageLiteral(resourceName: "PosPoints"), bitMask: PhysicsCategory.posPoints.rawValue)
		node.physicsBody?.mass = 50
	}
	override func collisionHandler() {
		score += points
	}
}
