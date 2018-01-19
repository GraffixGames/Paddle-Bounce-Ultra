//
//  GameScene.swift
//  Paddle Bounce Ultra
//
//  Created by  on 12/14/17.
//  Copyright © 2017 Hi-Crew. All rights reserved.
//

import SpriteKit
import GameplayKit

var score = 0

enum PhysicsCategory: UInt32 {
    case none = 0
    case playerCore = 1
	case playerUpgradedCore = 2
	case playerPaddle = 3
    case posPoints = 4
	case negPoints = 5
	case bigPosPoints = 6
	case bigNegPoints = 7
	case juggernaut = 8
	case gravityWell = 9
	case bigPaddle = 10
	case smallPaddle = 11
	case doublePaddle = 12
	case bomb = 13
	case sheild = 14
	case confusion = 15
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
    var scoreLabel = SKLabelNode()
    let PLAYER_SPEED: CGFloat = 8
    
    let moveAnalogStick = AnalogJoystick(diameter: 110)
    let rotateAnalogStick = AnalogJoystick(diameter: 110)
    
    override func didMove(to view: SKView) {
        gameBackgroundMusic.isPositional = false
        gameBackgroundMusic.autoplayLooped = true
        addChild(gameBackgroundMusic)
        
        createSun()
        backgroundColor = UIColor.cyan
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.restitution = 1
        
        createPlayerCore()
        createPlayerPaddle()
        createLabels()
        
        moveAnalogStick.position = CGPoint(x: frame.width * 0.17, y: -(frame.height * 0.8))
        addChild(moveAnalogStick)
        rotateAnalogStick.position = CGPoint(x: frame.width * 0.83, y: -(frame.height * 0.8))
        addChild(rotateAnalogStick)
        
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
			switch arc4random_uniform(12)
			{
			case 0:
				ball = PosPoints()
			case 1:
				ball = NegPoints()
			case 2:
				ball = BigPosPoints()
			case 3:
				ball = BigNegPoints()
			case 4:
				ball = Juggernaut()
			case 5:
				ball = GravityWell()
			case 6:
				ball = BigPaddle()
			case 7:
				ball = SmallPaddle()
			case 8:
				ball = DoublePaddle()
			case 9:
				ball = Bomb()
			case 10:
				ball = Shield()
			case 11:
				ball = Confusion()
			default:
				ball = PosPoints()
				break
				// nothing
			}
			ball.node.position.x = CGFloat(arc4random_uniform(UInt32(self.frame.size.width - 96))) + 48
			ball.node.position.y = -CGFloat(arc4random_uniform(UInt32(self.frame.size.height - 96))) + 48
			self.addChild(ball.node)
			self.balls.append(ball)
        }
        run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: (TimeInterval(arc4random_uniform(4))) + 1), spawnBall])))
        playerCore = childNode(withName: "playerCore") as! SKShapeNode
        playerCore.physicsBody?.categoryBitMask = PhysicsCategory.playerCore.rawValue
        physicsWorld.contactDelegate = self
        playerCore.physicsBody!.contactTestBitMask = PhysicsCategory.confusion.rawValue
    }
	
	// collisions
	// -------------------------------------------------------------------
	func didBegin(_ contact: SKPhysicsContact) {
		var body: UInt32
		if (contact.bodyA.categoryBitMask == PhysicsCategory.playerCore.rawValue) || (contact.bodyB.categoryBitMask == PhysicsCategory.confusion.rawValue) {
			body = bodyB.categoryBitMask
		}
		else if (contact.bodyA.categoryBitMask == PhysicsCategory.confusion.rawValue) || (contact.bodyB.categoryBitMask == PhysicsCategory.playerCore.rawValue) {
			body = bodyA.categoryBitMask
		}
		switch bodyB.categoryBitMask {
			
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
            sunEyes[i].position.y = sunNode.position.y + pos.y
            sunEyes[i].scale(to: CGSize(width: sunEyes[i].size.width + CGFloat((Double(i)) * 20), height: sunEyes[i].size.height + CGFloat((Double(i)) * 20)))
        }
        
        for i in sunEyes.indices {
            self.addChild(sunEyes[i])
        }
        
        // mouth
        sunMouth = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "OldMouth")))
        sunMouth.position = CGPoint(x: sunNode.position.x, y: sunNode.position.y - sunNode.size.height / 5)
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
