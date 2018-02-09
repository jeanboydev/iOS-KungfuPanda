//
//  SoundManager.swift
//  GameWord
//
//  Created by jeanboy on 2018/2/9.
//  Copyright © 2018年 jeanboy. All rights reserved.
//

import SpriteKit
import AVFoundation

class SoundManager: SKNode {
    
    var audioPlayer = AVAudioPlayer()
    let gameOver = SKAction.playSoundFileNamed("lose.mp3", waitForCompletion: false)
    let jump = SKAction.playSoundFileNamed("jump_from_platform.mp3", waitForCompletion: false)
    let roll = SKAction.playSoundFileNamed("hit_platform.mp3", waitForCompletion: false)
    let eat = SKAction.playSoundFileNamed("hit.mp3", waitForCompletion: false)
    
    func playBackgroundMusic() {
        let bgMusicUrl: URL = Bundle.main.url(forResource: "apple", withExtension: "mp3")!
        audioPlayer = try! AVAudioPlayer.init(contentsOf: bgMusicUrl)
        audioPlayer.numberOfLoops = -1
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    func stopBackgroundMusic() {
        if audioPlayer.isPlaying {
            audioPlayer.stop()
        }
    }
    
    func playGameOver() {
        self.run(gameOver)
    }
    
    func playJump() {
        self.run(jump)
    }
    
    func playRoll() {
        self.run(roll)
    }
    
    func playEat() {
        self.run(eat)
    }
}
