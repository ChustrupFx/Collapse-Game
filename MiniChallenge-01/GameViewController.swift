//
//  GameViewController.swift
//  MiniChallenge-01
//
//  Created by Gabriel Eirado on 12/07/23.
//


import UIKit
import SpriteKit
import GameplayKit


class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = SKView(frame: view.frame)
        view = skView
        
        //teste
        if let view = self.view as! SKView? {
            
            if let scene = SKScene(fileNamed: "MainMenu") {
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
        
            // Set the scale mode to scale to fit the window
           
            view.ignoresSiblingOrder = false
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
