//
//  Background.swift
//  GameWord
//
//  Created by jeanboy on 2018/2/8.
//  Copyright © 2018年 jeanboy. All rights reserved.
//

import SpriteKit

class Background: SKNode {

    var frontBgArr = [SKSpriteNode]()//近处背景
    var backBgArr = [SKSpriteNode]()//远处背景
    
    override init() {
        super.init()
        
        let textureFront = SKTexture(imageNamed: "background_f0")
        let spriteFront = SKSpriteNode(texture: textureFront)
        spriteFront.position.y = 70
        spriteFront.zPosition = ZPosition.backBg
        spriteFront.anchorPoint = CGPoint.init(x: 0, y: 0)
        
        let spriteFront1 = SKSpriteNode(texture: textureFront)
        spriteFront1.position.y = 70
        spriteFront1.zPosition = ZPosition.backBg
        spriteFront1.anchorPoint = CGPoint.init(x: 0, y: 0)
        
        self.addChild(spriteFront)
        self.addChild(spriteFront1)
        frontBgArr.append(spriteFront)
        frontBgArr.append(spriteFront1)
        
        let textureBack = SKTexture(imageNamed: "background_f1")
        let spriteBack = SKSpriteNode(texture: textureBack)
        spriteBack.position.y = 150
        spriteBack.zPosition = ZPosition.frontBg
        spriteBack.anchorPoint = CGPoint.init(x: 0, y: 0)
        
        let spriteBack1 = SKSpriteNode(texture: textureBack)
        spriteBack1.position.y = 150
        spriteBack1.zPosition = ZPosition.frontBg
        spriteBack1.anchorPoint = CGPoint.init(x: 0, y: 0)
        
        let spriteBack2 = SKSpriteNode(texture: textureBack)
        spriteBack2.position.y = 150
        spriteBack2.zPosition = ZPosition.frontBg
        spriteBack2.anchorPoint = CGPoint.init(x: 0, y: 0)
        
        self.addChild(spriteBack)
        self.addChild(spriteBack1)
        self.addChild(spriteBack2)
        backBgArr.append(spriteBack)
        backBgArr.append(spriteBack1)
        backBgArr.append(spriteBack2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func move(speed: CGFloat){
        for front in frontBgArr {
            front.position.x -= speed
        }
        
        if frontBgArr[0].position.x + frontBgArr[0].frame.width < speed {
            frontBgArr[0].position.x = 0
            frontBgArr[1].position.x = frontBgArr[0].frame.width
        }
        
        
        for back in backBgArr {
            back.position.x -= speed / 4
        }
        
        if backBgArr[0].position.x + backBgArr[0].frame.width < speed {
            backBgArr[0].position.x = 0
            backBgArr[1].position.x = backBgArr[0].frame.width
            backBgArr[2].position.x = backBgArr[0].frame.width * 2
        }
    }
}
