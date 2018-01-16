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
	override init() {
		super.init(radius: 24, image: #imageLiteral(resourceName: "PosPoints"))
		points = 1
	}
}
