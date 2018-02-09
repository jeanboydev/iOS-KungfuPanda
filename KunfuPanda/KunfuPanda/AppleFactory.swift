//
//  AppleFactory.swift
//  GameWord
//
//  Created by jeanboy on 2018/2/9.
//  Copyright © 2018年 jeanboy. All rights reserved.
//

import SpriteKit

class AppleFactory: SKNode {

    let appleTexture = SKTexture(imageNamed: "apple")
    var sceneWidth: CGFloat = 0.0
    var appleArr = [SKSpriteNode]()
    var timer = Timer()
    var theY: CGFloat = 0.0
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func create(width: CGFloat, y: CGFloat){
        self.sceneWidth = width
        self.theY = y
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(createApple), userInfo: nil, repeats: true)
    }
    
    @objc func createApple() {
        let random = arc4random() % 10
        if random > 8 {
            let apple = SKSpriteNode(texture: appleTexture)
            apple.setScale(Config.scale)
            apple.physicsBody = SKPhysicsBody(rectangleOf: apple.size, center: CGPoint.init(x: apple.size.width / 2, y: apple.size.height / 2))
            apple.physicsBody?.restitution = 0
            apple.physicsBody?.categoryBitMask = BitMaskType.apple
            apple.physicsBody?.isDynamic = false
            apple.anchorPoint = CGPoint.zero
            apple.zPosition = ZPosition.apple
            apple.position = CGPoint.init(x: sceneWidth + apple.frame.width, y: theY + 160)
            appleArr.append(apple)
            self.addChild(apple)
        }
    }
    
    func move(speed: CGFloat) {
        for apple in appleArr {
             apple.position.x -= speed
        }
        
        if appleArr.count > 0 && appleArr[0].position.x < -20{
            appleArr[0].removeFromParent()
            appleArr.remove(at: 0)
        }
    }
    
    func reset(){
        self.removeAllChildren()
        appleArr.removeAll(keepingCapacity: false)
        timer.invalidate()
    }
    
}
