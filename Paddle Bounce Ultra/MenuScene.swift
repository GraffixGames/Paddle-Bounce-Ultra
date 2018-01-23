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
    var playButtonTex = SKTexture(imageNamed: "nudes")

    var menuBall = Ball(radius: 24, image: #imageLiteral(resourceName: "PosPoints"), mask: PhysicsCategory.ball.rawValue, collision: SKAction.run{})
    var menuBallTwo = Ball(radius: 24, image: #imageLiteral(resourceName: "NegPoints"), mask: PhysicsCategory.ball.rawValue, collision: SKAction.run{})
	
	override func didMove(to view: SKView) {
		
        backgroundColor = UIColor.cyan
        
        playButton.fontName = "Helvetica"
		playButton.text = "Play"
		playButton.fontSize = 72
		playButton.fontColor = UIColor.white
		playButton.position = CGPoint(x: frame.midX, y: frame.midY)
		self.addChild(playButton)
        print(playButton.position)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.restitution = 1
        
        menuBall.position = CGPoint(x: frame.width * 0.3, y: -frame.height * 0.2)
        self.addChild(menuBall)
        print(menuBall.position)
        
        
        menuBallTwo.position = CGPoint(x: frame.width * 0.5, y: -frame.height * 0.85)
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
