//
//  PlatformFactory.swift
//  GameWord
//
//  Created by jeanboy on 2018/2/8.
//  Copyright © 2018年 jeanboy. All rights reserved.
//

import SpriteKit

class PlatformFactory: SKNode {

    let textureLeft = SKTexture(imageNamed: "platform_l")
    let textureMiddle = SKTexture(imageNamed: "platform_m")
    let textureRight = SKTexture(imageNamed: "platform_r")
    
    var platforms = [Platform]()
    var sceneWidth: CGFloat = 0.0
    
    var delegate: MainSceneDeletage?
    
    func createPlatform() {
        let middleNum = arc4random() % 4 + 1//中间块数量
        let gap: CGFloat = CGFloat(arc4random() % 8 + 1)//间隔宽度
        let x = self.sceneWidth + CGFloat(middleNum * 50) + gap + 100
        let y = CGFloat(arc4random() % 200 + 200)
        
        createMiddle(num: middleNum, x: x, y: y)
    }
    
    func createMiddle(num: UInt32, x: CGFloat, y: CGFloat) {
        let platform = Platform()
        
        let blockLeft = SKSpriteNode(texture: textureLeft)//左边
        blockLeft.setScale(Config.scale)
        blockLeft.anchorPoint = CGPoint.init(x: 0, y: 0)//中心点
        
        let blockRight = SKSpriteNode(texture: textureRight)//右边
        blockRight.setScale(Config.scale)
        blockRight.anchorPoint = CGPoint.init(x: 0, y: 0)
        
        var blockArr = [SKSpriteNode]()
        blockArr.append(blockLeft)
        
        for _ in 1...num {//中间
            let blockMiddle = SKSpriteNode(texture: textureMiddle)
            blockMiddle.setScale(Config.scale)
            blockMiddle.anchorPoint = CGPoint.init(x: 0, y: 0)
            blockArr.append(blockMiddle)
        }
        
        blockArr.append(blockRight)
        platform.height = blockLeft.frame.height
        platform.onCreate(spriteArr: blockArr)
        platform.name = "platform"
        platform.position = CGPoint.init(x: x, y: y)
        self.addChild(platform)
        self.platforms.append(platform)
        
        self.delegate?.onGetData(distance: platform.width + x - sceneWidth, theY: y)
    }
    
    func move(speed: CGFloat) {
        for plat in platforms {
            let position = plat.position
            plat.position = CGPoint.init(x: position.x - speed, y: position.y)
        }
        
        //移除屏幕外的平台
        if platforms[0].position.x < -platforms[0].width {
            platforms[0].removeFromParent()
            platforms.remove(at: 0)
        }
    }
    
    func reset() {
        self.removeAllChildren()
        platforms.removeAll(keepingCapacity: false)
    }
}
