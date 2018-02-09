//
//  GameScene.swift
//  GameWord
//
//  Created by jeanboy on 2018/2/8.
//  Copyright © 2018年 jeanboy. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol MainSceneDeletage {
    func onGetData(distance: CGFloat, theY: CGFloat)
}

class GameScene: SKScene, SKPhysicsContactDelegate, MainSceneDeletage {
   
    
    let panda = Panda()
    let platformFactory = PlatformFactory()
    let background = Background()
    let appleFactory = AppleFactory()
    let soundManager = SoundManager()
    let scoreLabel = SKLabelNode()
    let appleLabel = SKLabelNode()
    let tipsLabel = SKLabelNode()
    
    var theY: CGFloat = 0.0
    var moveSpeed: CGFloat = 1//当前速度
    var maxSpeed: CGFloat = 50//最大速度
    var lastDistance: CGFloat = 0.0
    var distance: CGFloat = 0.0
    var appleCount = 0//吃掉的苹果
    var isGameOver = false
    
    override func didMove(to view: SKView) {
        let skyColor = SKColor(red: 113.0 / 255.0, green: 197.0 / 255.0, blue: 207.0 / 255.0, alpha: 1.0)
        self.backgroundColor = skyColor
        
        scoreLabel.fontSize = 20
        scoreLabel.fontColor = UIColor.yellow
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint.init(x: 10, y: self.frame.size.height - 30)
        self.addChild(scoreLabel)
        
        appleLabel.fontSize = 20
        appleLabel.fontColor = UIColor.yellow
        appleLabel.horizontalAlignmentMode = .left
        appleLabel.position = CGPoint.init(x: 10, y: self.frame.size.height - 50)
        self.addChild(appleLabel)
        
        tipsLabel.fontSize = 65
        tipsLabel.zPosition = 100
        tipsLabel.position = CGPoint.init(x: self.frame.midX, y: self.frame.midY)
        self.addChild(tipsLabel)
        
        self.addChild(panda)
        
        platformFactory.delegate = self
        platformFactory.sceneWidth = self.frame.width
        self.addChild(platformFactory)
        
        self.addChild(background)
        
        self.addChild(soundManager)
        
        self.addChild(appleFactory)
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector.init(dx: 0, dy: -5)//默认重力加速度
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = BitMaskType.scene
        self.physicsBody?.isDynamic = false//碰撞无反弹
        
        resetGame()
        startGame()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        //与苹果碰撞
        if (contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (BitMaskType.apple | BitMaskType.panda) {
            soundManager.playEat()
            self.appleCount += 1
            if contact.bodyA.categoryBitMask == BitMaskType.apple {
                contact.bodyA.node?.isHidden = true
            } else {
                contact.bodyB.node?.isHidden = true
            }
        }
        
        //熊猫与台子碰撞
        if (contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (BitMaskType.platform | BitMaskType.panda) {
            var isDown = false
            var canRun = false
            if contact.bodyA.categoryBitMask == BitMaskType.platform {
                if (contact.bodyA.node as! Platform).isDown {
                    isDown = true
                    contact.bodyA.node?.physicsBody?.isDynamic = true//打开反弹相效果
                    contact.bodyA.node?.physicsBody?.collisionBitMask = 0
                } else if (contact.bodyA.node as! Platform).isShake {
                    (contact.bodyA.node as! Platform).isShake = false
                    platformShake(node: contact.bodyA.node!, down: -15, downTime: 0.2, up: 30, upTime: 0.5, isRepeat: true)
                }
                if contact.bodyB.node!.position.y > contact.bodyA.node!.position.y {
                    canRun = true
                }
            } else if contact.bodyB.categoryBitMask == BitMaskType.platform  {
                if (contact.bodyB.node as! Platform).isDown {
                    isDown = true
                    contact.bodyB.node?.physicsBody?.isDynamic = true//打开反弹相效果
                    contact.bodyB.node?.physicsBody?.collisionBitMask = 0
                } else if (contact.bodyB.node as! Platform).isShake {
                    (contact.bodyB.node as! Platform).isShake = false
                    platformShake(node: contact.bodyB.node!, down: -15, downTime: 0.2, up: 30, upTime: 0.5, isRepeat: true)
                }
                if contact.bodyA.node!.position.y > contact.bodyB.node!.position.y {
                    canRun = true
                }
            }
            
            panda.jumpStart = panda.position.y
            if panda.jumpEnd - panda.jumpStart <= -70 {
                panda.roll()
                soundManager.playRoll()
                if !isDown {
                    platformShake(node: contact.bodyA.node!)
                    platformShake(node: contact.bodyB.node!)
                }
            } else {
                if canRun {
                    panda.run()
                }
            }

        }
        
        if (contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (BitMaskType.scene | BitMaskType.panda) {
            tipsLabel.text = "Game Over!"
            soundManager.playGameOver()
            soundManager.stopBackgroundMusic()
            isGameOver = true
        }
        
        panda.jumpStart = panda.position.y
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        panda.jumpStart = panda.position.y
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGameOver {
            startGame()
        } else {
            if panda.status != Status.jump2 {
                soundManager.playJump()
            }
            panda.jump()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if isGameOver {
            resetGame()
        } else {
            if panda.position.x < 200 {
                let x = panda.position.x + 1
                panda.position = CGPoint.init(x: x, y: panda.position.y)
            }
            self.distance += moveSpeed
            self.lastDistance -= moveSpeed
            
            var tempSpeed = CGFloat(5 + Int(distance/5000))
            if tempSpeed > maxSpeed {
                tempSpeed = maxSpeed
            }
            
            if moveSpeed < tempSpeed {
                moveSpeed = tempSpeed
            }
            
            if self.lastDistance < 0 {
                platformFactory.createPlatform()
            }
            
            self.distance += moveSpeed
            
            scoreLabel.text = "run: \(Int(distance / 1000 * 10) / 10) km"
            appleLabel.text = "eat: \(appleCount) apples"
            
            platformFactory.move(speed: moveSpeed)
            background.move(speed: moveSpeed / 5)
            appleFactory.move(speed: moveSpeed)
        }
    }
    
    
    func platformShake(node: SKNode, down: CGFloat = -10, downTime: CGFloat = 0.05,
                   up: CGFloat = 20, upTime: CGFloat = 0.1, isRepeat: Bool = false) {
        let downAct = SKAction.moveBy(x: 0, y: down, duration: Double(downTime))
        let upAct = SKAction.moveBy(x: 0, y: up, duration: Double(upTime))
        let downUpAct = SKAction.sequence([downAct,upAct])
        if isRepeat {
            node.run(SKAction.repeatForever(downUpAct))
        } else {
            node.run(downUpAct)
        }
    }
    
    func resetGame() {
        platformFactory.reset()
        appleFactory.reset()
    }
    
    func startGame() {
        isGameOver = false
        distance =  0.0
        lastDistance = 0.0
        appleCount = 0
        moveSpeed = 5
        scoreLabel.text = "run: 0 km"
        appleLabel.text = "eat: 0 apples"
        tipsLabel.text = ""
        panda.position = CGPoint.init(x: 200, y: 400)
        appleFactory.create(width: self.frame.width, y: theY)
        platformFactory.createMiddle(num: 3, x: 0, y: 200)
        soundManager.playBackgroundMusic()
    }
    
    func onGetData(distance: CGFloat, theY: CGFloat) {
        self.lastDistance = distance
        self.theY = theY
        appleFactory.theY = theY
    }
    
}
