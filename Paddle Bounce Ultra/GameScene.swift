//
//  GameScene.swift
//  Paddle Bounce Ultra
//
//  Created by  on 12/14/17.
//  Copyright © 2017 Hi-Crew. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var playerCore = SKShapeNode()
    var projectile = SKShapeNode()
    
    let moveAnalogStick = AnalogJoystick(diameter: 110)
    let rotateAnalogStick = AnalogJoystick(diameter: 110)
    
    override func didMove(to view: SKView) {
        
        backgroundColor = UIColor.cyan
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        createPlayerCore()
        createProjectile()
        
        moveAnalogStick.stick.color = UIColor.orange
        
        rotateAnalogStick.stick.color = UIColor.orange
        
        moveAnalogStick.substrate.color = UIColor.purple
        rotateAnalogStick.substrate.color = UIColor.purple
        
        moveAnalogStick.position = CGPoint(x: frame.width * 0.17, y: -(frame.height * 0.8))
        addChild(moveAnalogStick)
        rotateAnalogStick.position = CGPoint(x: frame.width * 0.83, y: -(frame.height * 0.8))
        addChild(rotateAnalogStick)
        
        
        
        moveAnalogStick.trackingHandler = { [unowned self] data in
            
            let pC = self.playerCore
            
            pC.position = CGPoint(x: pC.position.x + (data.velocity.x * 0.12), y: pC.position.y + (data.velocity.y * 0.12))
        }
        
        rotateAnalogStick.trackingHandler = { [unowned self] jData in
            self.playerCore.zRotation = jData.angular
        }
        
    }
    
    func createPlayerCore() {
        playerCore = SKShapeNode(rectOf: CGSize(width: 50, height: 50))
        playerCore.name = "playerCore"
        playerCore.position = CGPoint(x: frame.midX, y: frame.midY)
        playerCore.fillColor = UIColor.blue
        playerCore.physicsBody = SKPhysicsBody(circleOfRadius: 50)
        playerCore.physicsBody?.isDynamic = true
        playerCore.physicsBody?.affectedByGravity = false
        playerCore.physicsBody?.allowsRotation = true
        self.addChild(playerCore)
    }
    
    func createProjectile() {
        let projectile = SKShapeNode(circleOfRadius: 30)
        if arc4random_uniform(2) == 0 {
            projectile.name = "goodBall"
            projectile.fillColor = UIColor.green
        }
        else {
            projectile.name = "badBall"
            projectile.fillColor = UIColor.red
        }
        let width = Double(arc4random_uniform(UInt32(frame.width)))
        let height = Double(arc4random_uniform(UInt32(frame.height)))
        projectile.position = CGPoint(x: width, y: height)
        projectile.physicsBody?.isDynamic = false
        self.addChild(projectile)
    }

    
    
}
