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
            self.playerPaddle.zRotation = jData.angular + CGFloat.pi / 2
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        playerPaddle.position.x = playerCore.position.x + lengthDir(length: 125, dir: playerPaddle.zRotation).x
        playerPaddle.position.y = playerCore.position.y + lengthDir(length: 125, dir: playerPaddle.zRotation).y
    }
    
    func createPlayerCore() {
        playerCore = SKShapeNode(circleOfRadius: 75)
        playerCore.name = "playerCore"
        playerCore.position = CGPoint(x: frame.midX, y: frame.midY)
        playerCore.fillColor = UIColor.blue
        playerCore.physicsBody = SKPhysicsBody(circleOfRadius: 75)
        playerCore.physicsBody?.isDynamic = true
        playerCore.physicsBody?.affectedByGravity = false
        playerCore.physicsBody?.allowsRotation = false
        self.addChild(playerCore)
    }
    
    func createPlayerPaddle() {
        playerPaddle = SKShapeNode(rectOf: CGSize(width: 10, height: 125))
        playerPaddle.name = "playerPaddle"
        playerPaddle.position.x = playerCore.position.x + lengthDir(length: 125, dir: 0).x
        playerPaddle.position.y = playerCore.position.y + lengthDir(length: 125, dir: 0).y
        print(playerPaddle.position)
        playerPaddle.fillColor = UIColor.black
        playerPaddle.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 125))
        playerPaddle.physicsBody?.isDynamic = true
        playerPaddle.physicsBody?.affectedByGravity = false
        playerPaddle.physicsBody?.allowsRotation = false
        self.addChild(playerPaddle)
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

    func lengthDir(length: CGFloat, dir: CGFloat) -> CGPoint {
        return CGPoint(x: length * cos(dir), y: length * sin(dir))
    }
    
}
