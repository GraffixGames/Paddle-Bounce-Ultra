//
//  MenuScene.swift
//  Paddle Bounce Ultra
//
//  Created by  on 1/19/18.
//  Copyright © 2018 Hi-Crew. All rights reserved.
//

import UIKit
import SpriteKit

class MenuScene: SKScene {
    
    var playButton = SKSpriteNode()
    var playButtonTex = SKTexture(imageNamed: "nudes")
    
    override func didMove(to view: SKView) {
        
        playButton = SKSpriteNode(texture: playButtonTex)
        playButton.position = CGPoint(x: frame.midX, y: frame.midY)
        self.addChild(playButton)
    
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
