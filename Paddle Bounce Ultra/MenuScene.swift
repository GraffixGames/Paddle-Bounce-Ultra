//
//  MenuScene.swift
//  Paddle Bounce Ultra
//
//  Created by  on 1/22/18.
//  Copyright © 2018 Hi-Crew. All rights reserved.
//

import Foundation

import UIKit
import SpriteKit

class MenuScene: SKScene {
	
	var playButton = SKLabelNode()
    
    var menuBall =
    var menuBallTwo = SKSpriteNode()
    var menuBallTex = SKTexture(imageNamed: "PosPoints")
    var menuBallTexTwo = SKTexture(imageNamed: "NegPoints")
    

	
	override func didMove(to view: SKView) {
		
        backgroundColor = UIColor.cyan
        
		playButton.text = "Play"
        playButton.fontColor = UIColor.black
        playButton.fontSize = 100
		playButton.position = CGPoint(x: frame.midX, y: frame.midY)
		self.addChild(playButton)
        print(playButton.position)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.restitution = 1
        
        menuBall.texture = menuBallTex
        menuBall.position = CGPoint(x: frame.width * 0.3, y: -frame.height * 0.2)
        menuBall.physicsBody?.affectedByGravity = false
        menuBall.physicsBody?.allowsRotation = false
        menuBall.physicsBody?.isDynamic = true
        menuBall.physicsBody?.restitution = 1
        menuBall.physicsBody?.mass = 128
        menuBall.physicsBody?.velocity = CGVector(dx: 500, dy: 350)
        self.addChild(menuBall)
        print(menuBall.position)
        
        menuBallTwo.texture = menuBallTexTwo
        menuBallTwo.position = CGPoint(x: frame.width * 0.5, y: -frame.height * 0.85)
        menuBallTwo.physicsBody?.affectedByGravity = false
        menuBallTwo.physicsBody?.allowsRotation = false
        menuBallTwo.physicsBody?.isDynamic = true
        menuBallTwo.physicsBody?.restitution = 1
        menuBallTwo.physicsBody?.mass = 128
        menuBallTwo.physicsBody?.velocity = CGVector(dx: -670, dy: 150)
        self.addChild(menuBallTwo)
        print(menuBallTwo.position)
        
        
		
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		if let touch = touches.first {
			let pos = touch.location(in: self)
			let node = self.atPoint(pos)
			
			if node == playButton {
				if view != nil {
					let transition = SKTransition.crossFade(withDuration: 1)
					let scene:SKScene = GameScene(size: self.size)
					view?.presentScene(scene, transition: transition)
				}
			}
		}
	}
	
	
	
	
	
	
	
	
}
