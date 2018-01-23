//
//  GameScene.swift
//  Paddle Bounce Ultra
//
//  Created by  on 12/14/17.
//  Copyright © 2017 Hi-Crew. All rights reserved.
//

import SpriteKit
import GameplayKit
import Darwin

enum PhysicsCategory: UInt32 {
    case none = 0
    case playerCore = 1
	case playerPaddle = 3
	case ball = 4
}


class GameScene: SKScene, SKPhysicsContactDelegate {

    var gameBackgroundMusic = SKAudioNode(fileNamed: "xylo2.wav")
    var playerCore = SKShapeNode()
    var playerPaddle = SKShapeNode()
    var projectile = SKShapeNode()
    var balls = [Ball]()
    var sunNode = SKSpriteNode()
    var sunEyes = [SKSpriteNode]()
    var sunMouth = SKSpriteNode()
    var score = 0
    var scoreLabel = SKLabelNode()
    let PLAYER_SPEED: CGFloat = 8
    
    let moveAnalogStick = AnalogJoystick(diameter: 110)
    let rotateAnalogStick = AnalogJoystick(diameter: 110)
    
    override func sceneDidLoad() {
        
        gameBackgroundMusic.isPositional = true
        gameBackgroundMusic.autoplayLooped = true
        addChild(gameBackgroundMusic)
        
    
        gameBackgroundMusic.position = CGPoint(x: 0, y: frame.height / 2)
        let moveForward = SKAction.moveTo(x: frame.width, duration: 2)
        let moveBack = SKAction.moveTo(x: 0, duration: 2)
        let sequence = SKAction.sequence([moveForward, moveBack])
        let repeatForever = SKAction.repeatForever(sequence)
        gameBackgroundMusic.run(repeatForever)
        
        createSun()
        backgroundColor = UIColor.cyan
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.restitution = 1
		physicsBody?.friction = 0
		physicsBody?.linearDamping = 0
		
        createPlayerCore()
		createPlayerPaddle(size: CGSize(width: 10, height: 120))
        createLabels()
        
        
        
        moveAnalogStick.position = CGPoint(x: frame.width * 0.17, y: -(frame.height * 0.8))
        
        rotateAnalogStick.position = CGPoint(x: frame.width * 0.83, y: -(frame.height * 0.8))
        
        
        moveAnalogStick.stick.image = #imageLiteral(resourceName: "JStick")
        rotateAnalogStick.stick.image = #imageLiteral(resourceName: "JStick")
        moveAnalogStick.substrate.image = #imageLiteral(resourceName: "JSub")
        rotateAnalogStick.substrate.image = #imageLiteral(resourceName: "JSub")
        moveAnalogStick.substrate.radius = 75
        moveAnalogStick.stick.radius = 45
        rotateAnalogStick.substrate.radius = 75
        rotateAnalogStick.stick.radius = 45
        moveAnalogStick.substrate.alpha = 0.5
        moveAnalogStick.stick.alpha = 1
        rotateAnalogStick.substrate.alpha = 0.5
        rotateAnalogStick.stick.alpha = 1
        
        self.addChild(moveAnalogStick)
        self.addChild(rotateAnalogStick)
    
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
        // TODO: fix with new ball system
        let spawnBall = SKAction.run {
			var ball: Ball
			switch arc4random_uniform(11)
			{
			case 0: // PosPoints
				ball = Ball(radius: 24, image: #imageLiteral(resourceName: "PosPoints"), mask: PhysicsCategory.ball.rawValue, collision: SKAction.run {
					self.score += 1
					self.scoreLabel.text = String(self.score)
				})
			case 1: // NegPoints
				ball = Ball(radius: 24, image: #imageLiteral(resourceName: "NegPoints"), mask: PhysicsCategory.ball.rawValue, collision: SKAction.run {
					self.score -= 1
					self.scoreLabel.text = String(self.score)
				})
			case 2: // BigPosPoints
				ball = Ball(radius: 48, image: #imageLiteral(resourceName: "BigPosPoints"), mask: PhysicsCategory.ball.rawValue, collision: SKAction.run {
					self.score += 5
					self.scoreLabel.text = String(self.score)
				})
			case 3: // BigNegPoints
				ball = Ball(radius: 48, image: #imageLiteral(resourceName: "BigNegPoints"), mask: PhysicsCategory.ball.rawValue, collision: SKAction.run {
					self.score -= 5
					self.scoreLabel.text = String(self.score)
				})
			case 4: // gravityWell
				ball = Ball(radius: 24, image: #imageLiteral(resourceName: "PosPoints"), mask: PhysicsCategory.ball.rawValue, collision: SKAction.run {
					
				})
			case 5: // BigPaddle
				ball = Ball(radius: 24, image: #imageLiteral(resourceName: "BigPaddle"), mask: PhysicsCategory.ball.rawValue, collision: SKAction.run {
					self.playerPaddle.removeFromParent()
					self.createPlayerPaddle(size: CGSize(width: 10, height: 200))
					self.run(SKAction.sequence([SKAction.wait(forDuration: 30), SKAction.run {
						self.playerPaddle.removeFromParent()
						self.createPlayerPaddle(size: CGSize(width: 10, height: 120))
					}]))
				})
			case 6: // SmallPaddle
				ball = Ball(radius: 24, image: #imageLiteral(resourceName: "PosPoints"), mask: PhysicsCategory.ball.rawValue, collision: SKAction.run {
					self.score += 1
					self.scoreLabel.text = String(self.score)
				})
			case 7: // DoublePaddle
				ball = Ball(radius: 24, image: #imageLiteral(resourceName: "PosPoints"), mask: PhysicsCategory.ball.rawValue, collision: SKAction.run {
					self.score += 1
					self.scoreLabel.text = String(self.score)
				})
			case 8: // Bomb
				ball = Ball(radius: 24, image: #imageLiteral(resourceName: "PosPoints"), mask: PhysicsCategory.ball.rawValue, collision: SKAction.run {
					self.score += 1
					self.scoreLabel.text = String(self.score)
				})
			case 9: // Sheild
				ball = Ball(radius: 24, image: #imageLiteral(resourceName: "PosPoints"), mask: PhysicsCategory.ball.rawValue, collision: SKAction.run {
					self.score += 1
					self.scoreLabel.text = String(self.score)
				})
			case 10: // Confusion
				ball = Ball(radius: 24, image: #imageLiteral(resourceName: "PosPoints"), mask: PhysicsCategory.ball.rawValue, collision: SKAction.run {
					self.score += 1
					self.scoreLabel.text = String(self.score)
				})
			default:
				ball = Ball(radius: 24, image: #imageLiteral(resourceName: "PosPoints"), mask: PhysicsCategory.ball.rawValue, collision: SKAction.run {
					self.score += 1
					self.scoreLabel.text = String(self.score)
				})
			}
			ball.position.x = self.frame.midX
			ball.position.y = self.frame.midY
			self.balls.append(ball)
			self.addChild(self.balls[self.balls.count - 1])
        }
        run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: (TimeInterval(arc4random_uniform(4))) + 1), spawnBall])))
        playerCore = childNode(withName: "playerCore") as! SKShapeNode
        playerCore.physicsBody?.categoryBitMask = PhysicsCategory.playerCore.rawValue
        physicsWorld.contactDelegate = self
        playerCore.physicsBody!.contactTestBitMask = PhysicsCategory.ball.rawValue
    }
    
    // collisions
    // -------------------------------------------------------------------
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == PhysicsCategory.playerCore.rawValue) && (contact.bodyB.categoryBitMask == PhysicsCategory.ball.rawValue) {
            run((contact.bodyB.node as! Ball).collisionHandler)
            contact.bodyB.node?.removeFromParent()
        }
        else if (contact.bodyA.categoryBitMask == PhysicsCategory.ball.rawValue) && (contact.bodyB.categoryBitMask == PhysicsCategory.playerCore.rawValue) {
            run((contact.bodyA.node as! Ball).collisionHandler)
            contact.bodyA.node?.removeFromParent()
        }
        
    }
    // --------------------------------------------------------------------
    
    override func update(_ currentTime: TimeInterval) {
        sunEyes[0].zRotation = angleBetween(points: sunEyes[0].position, playerCore.position)
        sunEyes[1].zRotation = angleBetween(points: sunEyes[1].position, playerCore.position)
        sunMouth.setScale(sin(CGFloat(currentTime) / 16))
        sunMouth.zRotation = CGFloat(currentTime * 50).truncatingRemainder(dividingBy: 2 * CGFloat.pi)
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
        self.addChild(scoreLabel)
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
    
	func createPlayerPaddle(size: CGSize) {
        playerPaddle = SKShapeNode(rectOf: size)
        playerPaddle.name = "playerPaddle"
        playerPaddle.position.x = playerCore.position.x + lengthDir(length: size.height, dir: 0).x
        playerPaddle.position.y = playerCore.position.y + lengthDir(length: size.height, dir: 0).y
        print(playerPaddle.position)
        playerPaddle.fillColor = UIColor.black
        playerPaddle.physicsBody = SKPhysicsBody(rectangleOf: size)
        playerPaddle.physicsBody?.isDynamic = false
        playerPaddle.physicsBody?.affectedByGravity = false
        playerPaddle.physicsBody?.allowsRotation = false
        self.addChild(playerPaddle)
    }
    
//    func createProjectile() {
//        let radius: CGFloat = 24
//        let projectile = SKShapeNode(circleOfRadius: radius)
//        let width = Double(arc4random_uniform(UInt32(frame.width - radius * 2))) + Double(radius)
//        let height = Double(arc4random_uniform(UInt32(frame.height - radius * 2))) + Double(radius)
//        projectile.position = CGPoint(x: width, y: -height)
//        projectile.physicsBody = SKPhysicsBody(circleOfRadius: radius)
//        projectile.physicsBody?.isDynamic = true
//        projectile.physicsBody?.allowsRotation = false
//        projectile.physicsBody?.affectedByGravity = false
//        projectile.physicsBody?.friction = 0
//        projectile.physicsBody?.restitution = 1
//        projectile.physicsBody?.linearDamping = 0
//        projectile.physicsBody?.mass = 50
//        let randX = Int(arc4random_uniform(1200)) - 600
//        let randY = Int(arc4random_uniform(1200)) - 600
//        projectile.physicsBody?.velocity = CGVector(dx: randX, dy: randY)
//        if arc4random_uniform(2) == 0 {
//            projectile.name = "goodBall"
//            projectile.fillColor = UIColor.green
//            projectile.physicsBody?.categoryBitMask = PhysicsCategory.goodBall
//        }
//        else {
//            projectile.name = "badBall"
//            projectile.fillColor = UIColor.red
//            projectile.physicsBody?.categoryBitMask = PhysicsCategory.badBall
//        }
//        self.addChild(projectile)
//        if projectile.name == "goodBall" {
//            goodBalls.append(projectile)
//        }
//        else {
//            badBalls.append(projectile)
//        }
//    }
    
    func createSun() {
        // background
        sunNode = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "sun")))
        sunNode.position = CGPoint(x: frame.width / 2, y: -frame.height / 2)
        let size = frame.height - frame.height / 3
        sunNode.size = CGSize(width: size, height: size)
        sunNode.zPosition = -1336
        self.addChild(sunNode)
        
        // eyes
        for i in 0..<2 {
            let pos = lengthDir(length: (2 * size) / 7, dir: CGFloat(i) * CGFloat.pi/2 + CGFloat.pi / 4)
            sunEyes.append(SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "eye"))))
            sunEyes[i].zPosition = -1335
            sunEyes[i].position.x = sunNode.position.x + pos.x
            sunEyes[i].position.y = -sunNode.position.y - pos.y
            sunEyes[i].scale(to: CGSize(width: sunEyes[i].size.width + CGFloat((Double(i)) * 20), height: sunEyes[i].size.height + CGFloat((Double(i)) * 20)))
        }
        
        for i in sunEyes.indices {
            self.addChild(sunEyes[i])
        }
        
        // mouth
        sunMouth = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "OldMouth")))
        sunMouth.position = CGPoint(x: sunNode.position.x, y: -sunNode.position.y + sunNode.size.height / 5)
        sunMouth.setScale(0.75)
        sunMouth.zPosition = -1335
        addChild(sunMouth)
        
    }

    func lengthDir(length: CGFloat, dir: CGFloat) -> CGPoint {
        return CGPoint(x: length * cos(dir), y: length * sin(dir))
    }
    
    func angleBetween(points p1: CGPoint, _ p2: CGPoint) -> CGFloat {
        let dX: CGFloat = -(p1.y - p2.y)
        let dY: CGFloat = (p2.x - p1.x)
        return atan2(dX, dY)
    }
}
