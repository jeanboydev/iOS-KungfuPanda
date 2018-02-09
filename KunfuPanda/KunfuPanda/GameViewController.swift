//
//  GameViewController.swift
//  KunfuPanda
//
//  Created by jeanboy on 2018/2/9.
//  Copyright © 2018年 jeanboy. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            if view.scene == nil {
                let scene = GameScene(size: view.bounds.size)
                scene.scaleMode = .aspectFill
                
                view.showsFPS = true
                view.showsNodeCount = true
                //                view.showsPhysics = true
                view.ignoresSiblingOrder = true
                view.presentScene(scene)
            }
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
