//
//  GameScene.swift
//  Paddle Bounce Ultra
//
//  Created by  on 12/14/17.
//  Copyright © 2017 Hi-Crew. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let none: UInt32 = 0
    static let playerCore: UInt32 = 0b1
    static let playerPaddle: UInt32 = 0b10
    static let goodBall: UInt32 = 0b100
    static let badBall: UInt32 = 0b1000
    static let bigGoodBall: UInt32 = 0b10000
    static let bigBadBall: UInt32 = 0b100000
	static let grayBall: UInt32 = 0b1000000
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var playerCore = SKShapeNode()
    var playerPaddle = SKShapeNode()
    var projectile = SKShapeNode()
    var goodBalls = [SKShapeNode]()
    var badBalls = [SKShapeNode]()
    var bigGoodBalls = [SKShapeNode]()
    var bigBadBalls = [SKShapeNode]()
	var grayBalls = [SKShapeNode]()
    var scoreLabel = SKLabelNode()
    var score = 0

    let PLAYER_SPEED: CGFloat = 8
    
    let moveAnalogStick = AnalogJoystick(diameter: 110)
    let rotateAnalogStick = AnalogJoystick(diameter: 110)
    
    override func didMove(to view: SKView) {
        
        backgroundColor = UIColor.cyan
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        createPlayerCore()
        createPlayerPaddle()
        createProjectile()
        createLabels()
        
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
        moveAnalogStick.substrate.alpha = 0.5
        moveAnalogStick.stick.alpha = 0.5
        rotateAnalogStick.substrate.alpha = 0.5
        rotateAnalogStick.stick.alpha = 0.5
    
        moveAnalogStick.trackingHandler = { [unowned self] data in
            self.playerCore.physicsBody?.velocity = CGVector(dx: data.velocity.x * self.PLAYER_SPEED, dy: data.velocity.y * self.PLAYER_SPEED)
        }
        
        moveAnalogStick.stopHandler = { [unowned self] in
            self.playerCore.physicsBody?.velocity = CGVector()
        }
        
        rotateAnalogStick.trackingHandler = { [unowned self] jData in
            if abs(jData.velocity.x) > 4 || abs(jData.velocity.y) > 4 {
                self.playerPaddle.zRotation = jData.angular + CGFloat.pi / 2
            }
        }
        
        let spawnBall = SKAction.run {
			let ballTypeVariable = arc4random_uniform(101)
            if ballTypeVariable <= 90 {
                self.createProjectile()
            }
            else if ballTypeVariable >= 91 && ballTypeVariable < 99 {
                self.createBigProjectile()
            }
			else {
				self.createGrayProjectile()
			}
        }
        run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: (TimeInterval(arc4random_uniform(4))) + 1), spawnBall])))
        playerCore = childNode(withName: "playerCore") as! SKShapeNode
        playerCore.physicsBody?.categoryBitMask = PhysicsCategory.playerCore
        physicsWorld.contactDelegate = self
        playerCore.physicsBody!.contactTestBitMask = PhysicsCategory.goodBall | PhysicsCategory.badBall
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == PhysicsCategory.playerCore) || (contact.bodyB.categoryBitMask == PhysicsCategory.playerCore) {
            if (contact.bodyA.categoryBitMask == PhysicsCategory.goodBall) || (contact.bodyB.categoryBitMask == PhysicsCategory.goodBall) {
                score += 10
                scoreLabel.text = String(score)
                if contact.bodyA.categoryBitMask == PhysicsCategory.goodBall {
                    contact.bodyA.node?.removeFromParent()
                }
                else {
                    contact.bodyB.node?.removeFromParent()
                }
            }
            else if (contact.bodyA.categoryBitMask == PhysicsCategory.badBall) || (contact.bodyB.categoryBitMask == PhysicsCategory.badBall) {
                score -= 10
                scoreLabel.text = String(score)
                if contact.bodyA.categoryBitMask == PhysicsCategory.badBall {
                    contact.bodyA.node?.removeFromParent()
                }
                else {
                    contact.bodyB.node?.removeFromParent()
                }
            }
            else if (contact.bodyA.categoryBitMask == PhysicsCategory.bigBadBall) || (contact.bodyB.categoryBitMask == PhysicsCategory.bigBadBall) {
                score -= 50
                scoreLabel.text = String(score)
                if contact.bodyA.categoryBitMask == PhysicsCategory.bigBadBall {
                    contact.bodyA.node?.removeFromParent()
                }
                else {
                    contact.bodyB.node?.removeFromParent()
                }
            }
            else if (contact.bodyA.categoryBitMask == PhysicsCategory.bigGoodBall) || (contact.bodyB.categoryBitMask == PhysicsCategory.bigGoodBall) {
                score += 50
                scoreLabel.text = String(score)
                if contact.bodyA.categoryBitMask == PhysicsCategory.bigGoodBall {
                    contact.bodyA.node?.removeFromParent()
                }
                else {
                    contact.bodyB.node?.removeFromParent()
                }
            }
        }
    }
    
    override func didFinishUpdate() {
        playerPaddle.position.x = playerCore.position.x + lengthDir(length: 120, dir: playerPaddle.zRotation).x
        playerPaddle.position.y = playerCore.position.y + lengthDir(length: 120, dir: playerPaddle.zRotation).y
    }
    
    func createLabels() {
        scoreLabel = SKLabelNode(fontNamed: "Arial")
        scoreLabel.text = "0"
        scoreLabel.fontSize = 75
        scoreLabel.position = CGPoint(x: frame.width * 0.5, y: -(frame.height * 0.1))
        scoreLabel.fontColor = UIColor.black
        addChild(scoreLabel)
    }
    
    func createPlayerCore() {
        let size: CGFloat = 64
        playerCore = SKShapeNode(circleOfRadius: size)
        playerCore.name = "playerCore"
        playerCore.position = CGPoint(x: frame.midX, y: frame.midY)
        playerCore.fillColor = UIColor.blue
        playerCore.physicsBody = SKPhysicsBody(circleOfRadius: size)
        playerCore.physicsBody?.isDynamic = true
        playerCore.physicsBody?.affectedByGravity = false
        playerCore.physicsBody?.allowsRotation = false
        playerCore.physicsBody?.mass = 1337666.42
        self.addChild(playerCore)
    }
    
    func createPlayerPaddle() {
        playerPaddle = SKShapeNode(rectOf: CGSize(width: 10, height: 100))
        playerPaddle.name = "playerPaddle"
        playerPaddle.position.x = playerCore.position.x + lengthDir(length: 120, dir: 0).x
        playerPaddle.position.y = playerCore.position.y + lengthDir(length: 120, dir: 0).y
        print(playerPaddle.position)
        playerPaddle.fillColor = UIColor.black
        playerPaddle.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 100))
        playerPaddle.physicsBody?.isDynamic = false
        playerPaddle.physicsBody?.affectedByGravity = false
        playerPaddle.physicsBody?.allowsRotation = false
        self.addChild(playerPaddle)
    }
    
    func createProjectile() {
        let radius: CGFloat = 24
        let projectile = SKShapeNode(circleOfRadius: radius)
        let width = Double(arc4random_uniform(UInt32(frame.width - radius * 2))) + Double(radius)
        let height = Double(arc4random_uniform(UInt32(frame.height - radius * 2))) + Double(radius)
        projectile.position = CGPoint(x: width, y: -height)
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.allowsRotation = false
        projectile.physicsBody?.affectedByGravity = false
        projectile.physicsBody?.friction = 0
        projectile.physicsBody?.restitution = 1
        projectile.physicsBody?.linearDamping = 0
		projectile.physicsBody?.mass = 50
        let randX = Int(arc4random_uniform(1200)) - 600
        let randY = Int(arc4random_uniform(1200)) - 600
        projectile.physicsBody?.velocity = CGVector(dx: randX, dy: randY)
        if arc4random_uniform(2) == 0 {
            projectile.name = "goodBall"
            projectile.fillColor = UIColor.green
            projectile.physicsBody?.categoryBitMask = PhysicsCategory.goodBall
        }
        else {
            projectile.name = "badBall"
            projectile.fillColor = UIColor.red
            projectile.physicsBody?.categoryBitMask = PhysicsCategory.badBall
        }
        self.addChild(projectile)
        if projectile.name == "goodBall" {
            goodBalls.append(projectile)
        }
        else {
            badBalls.append(projectile)
        }
    }
    
    func createBigProjectile() {
        let radius: CGFloat = 36
        let projectile = SKShapeNode(circleOfRadius: radius)
        let width = Double(arc4random_uniform(UInt32(frame.width - radius * 2))) + Double(radius)
        let height = Double(arc4random_uniform(UInt32(frame.height - radius * 2))) + Double(radius)
        projectile.position = CGPoint(x: width, y: -height)
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.allowsRotation = false
        projectile.physicsBody?.affectedByGravity = false
        projectile.physicsBody?.friction = 0
        projectile.physicsBody?.restitution = 1
        projectile.physicsBody?.linearDamping = 0
		projectile.physicsBody?.mass = 50
		let randX = Int(arc4random_uniform(1200)) - 600
		let randY = Int(arc4random_uniform(1200)) - 600
		projectile.physicsBody?.velocity = CGVector(dx: randX, dy: randY)
        if arc4random_uniform(2) == 0 {
            projectile.name = "bigGoodBall"
            projectile.fillColor = UIColor.green
            projectile.physicsBody?.categoryBitMask = PhysicsCategory.goodBall
        }
        else {
            projectile.name = "bigBadBall"
            projectile.fillColor = UIColor.red
            projectile.physicsBody?.categoryBitMask = PhysicsCategory.badBall
        }
        self.addChild(projectile)
        if projectile.name == "bigGoodBall" {
            bigGoodBalls.append(projectile)
        }
        else {
            bigBadBalls.append(projectile)
        }
    }
	
	func createGrayProjectile() {
		let radius: CGFloat = 24
		let projectile = SKShapeNode(circleOfRadius: radius)
		let width = Double(arc4random_uniform(UInt32(frame.width - radius * 2))) + Double(radius)
		let height = Double(arc4random_uniform(UInt32(frame.height - radius * 2))) + Double(radius)
		projectile.position = CGPoint(x: width, y: -height)
		projectile.physicsBody = SKPhysicsBody(circleOfRadius: radius)
		projectile.physicsBody?.isDynamic = true
		projectile.physicsBody?.allowsRotation = false
		projectile.physicsBody?.affectedByGravity = false
		projectile.physicsBody?.friction = 0
		projectile.physicsBody?.restitution = 2
		projectile.physicsBody?.linearDamping = 0
		projectile.physicsBody?.mass = CGFloat(Int.max)
		let randX = Int(arc4random_uniform(120)) - 20
		let randY = Int(arc4random_uniform(120)) - 20
		projectile.physicsBody?.velocity = CGVector(dx: randX, dy: randY)
		projectile.name = "grayBall"
		projectile.fillColor = UIColor.gray
		self.addChild(projectile)
		grayBalls.append(projectile)
	}

    func lengthDir(length: CGFloat, dir: CGFloat) -> CGPoint {
        return CGPoint(x: length * cos(dir), y: length * sin(dir))
    }
    
}
