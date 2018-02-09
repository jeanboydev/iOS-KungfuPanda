//
//  Panda.swift
//  GameWord
//
//  Created by jeanboy on 2018/2/8.
//  Copyright © 2018年 jeanboy. All rights reserved.
//

import SpriteKit

public enum Status: Int {
    case run, jump, jump2, roll
}

class Panda: SKSpriteNode {

    let runAtlas = SKTextureAtlas(named: "run.altas")
    var runFrames = [SKTexture]()
    
    let jumpAtlas = SKTextureAtlas(named: "jump.atlas")
    var jumpFrames = [SKTexture]()
    
    let rollAtlas = SKTextureAtlas(named: "roll.atlas")
    var rollFrames = [SKTexture]()
    
    let jumpEffectAtlas = SKTextureAtlas(named: "jump_effect.atlas")
    var jumpEffectFrames = [SKTexture]()
    var jumpEffect = SKSpriteNode()
    
    var status = Status.run
    var jumpStart: CGFloat = 0.0
    var jumpEnd: CGFloat = 0.0
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        //设置默认显示第一帧
        let texture = runAtlas.textureNamed("panda_run_01")
        let panda = SKSpriteNode(texture: texture)
        panda.setScale(Config.scale)
        let size = panda.size
        super.init(texture: texture, color: SKColor.white, size: size)
        
        //跑
        createFrames(atlas: runAtlas, format: "panda_run_%.2d") { (texture) in
            runFrames.append(texture)
        }
        //跳
        createFrames(atlas: jumpAtlas, format: "panda_jump_%.2d") { (texture) in
            jumpFrames.append(texture)
        }
        //滚
        createFrames(atlas: rollAtlas, format: "panda_roll_%.2d") { (texture) in
            rollFrames.append(texture)
        }
        
        //跳时点缀效果
        createFrames(atlas: jumpEffectAtlas, format: "jump_effect_%.2d") { (texture) in
            jumpEffectFrames.append(texture)
        }
        //添加跳时效果
        jumpEffect = SKSpriteNode(texture: jumpFrames[0])
        jumpEffect.position = CGPoint.init(x: -80, y: -30)
        jumpEffect.isHidden = true
        jumpEffect.size = CGSize.init(width: 93, height: 24)
        self.addChild(jumpEffect)
        
        self.zPosition = ZPosition.panda
        self.physicsBody = SKPhysicsBody(rectangleOf: size)//设置panda物理body
        self.physicsBody?.isDynamic = true//碰撞无反弹
        self.physicsBody?.allowsRotation = false//碰撞后角度无变化
        self.physicsBody?.restitution = 0.1//摩擦力
        self.physicsBody?.categoryBitMask = BitMaskType.panda//标识
        self.physicsBody?.contactTestBitMask = BitMaskType.scene | BitMaskType.platform | BitMaskType.apple//可以碰撞的物体
        self.physicsBody?.collisionBitMask = BitMaskType.platform//产生作用
        
        run()
        
    }
    
    private func createFrames(atlas: SKTextureAtlas, format: String, onAppend: (_ texture: SKTexture) -> ()){
        for i in 1...atlas.textureNames.count {
            let tempName = String.init(format: format, i)
            let texture = atlas.textureNamed(tempName)
            onAppend(texture)
        }
    }
    
    public func run() {
        self.removeAllActions()
        self.status = .run
        self.run(SKAction.repeatForever(SKAction.animate(with: runFrames, timePerFrame: 0.05)))
    }
    
    public func jump() {
        self.removeAllActions()
        if self.status != .jump2 {
            self.run(SKAction.animate(with: jumpFrames, timePerFrame: 0.05), withKey: "jump")
            
            self.physicsBody?.velocity = CGVector.init(dx: 0, dy: 450)//给一个向上的加速度使其能跳起来
            if self.status == .jump {
                self.run(SKAction.animate(with: rollFrames, timePerFrame: 0.05))
                self.status = .jump2
                self.jumpStart = self.position.y
            } else {
                showJumpEffect()
                self.status = .jump
            }
        }
    }
    
    public func roll() {
        self.removeAllActions()
        self.status = .roll
        self.run(SKAction.animate(with: rollFrames, timePerFrame: 0.05)) {
            self.run()
        }
    }
    
    private func showJumpEffect() {
        jumpEffect.isHidden = false
        let effectAction = SKAction.animate(with: jumpEffectFrames, timePerFrame: 0.05)
        let removeAction = SKAction.run {
            self.jumpEffect.isHidden = true
        }
        //先显示后隐藏
        jumpEffect.run(SKAction.sequence([effectAction, removeAction]))
    }
}
