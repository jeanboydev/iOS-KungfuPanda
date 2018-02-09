//
//  Platform.swift
//  GameWord
//
//  Created by jeanboy on 2018/2/8.
//  Copyright © 2018年 jeanboy. All rights reserved.
//

import SpriteKit

class Platform: SKNode {

    var width: CGFloat = 0.0
    var height: CGFloat = 0.0
    var isDown = false
    var isShake = false
    
    func onCreate(spriteArr: [SKSpriteNode]) {
        //拼接平台
        for platform in spriteArr {
            platform.position.x = self.width
            self.addChild(platform)
            self.width += platform.size.width
        }
        
        if spriteArr.count <= 3 {//平台小于3时下落
            isDown = true
        } else {//随机振动
            let random = arc4random() % 100
            if random > 80 {
                isShake = true
            }
        }
        
        self.zPosition = ZPosition.platform
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize.init(width: self.width, height: self.height), center: CGPoint.init(x: self.width / 2, y: self.height / 2))
        self.physicsBody?.categoryBitMask = BitMaskType.platform
        self.physicsBody?.isDynamic = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.restitution = 0
    }
}
