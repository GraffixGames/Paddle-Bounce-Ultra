//
//  BigNegPoints.swift
//  Paddle Bounce Ultra
//
//  Created by  on 1/16/18.
//  Copyright © 2018 Hi-Crew. All rights reserved.
//

import Foundation
import SpriteKit

class BigNegPoints: Ball {
	var points: Int
	init() {
		points = -5
		super.init(radius: 48, image: #imageLiteral(resourceName: "PosPoints"), bitMask: PhysicsCategory.bigNegPoints.rawValue)
		node.physicsBody?.mass = 50
	}
}
