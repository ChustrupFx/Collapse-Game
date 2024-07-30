//
//  Phase2.swift
//  MiniChallenge
//
//  Created by Leonardo Mesquita Alves on 17/07/23.
//

import Foundation
import SpriteKit
import GameplayKit


class Phase2: BaseLevelScene {
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        // Adicionando o parallax na cena
//        parallax = Parallax(scene: self, items: [
//            .init(fileName: "New Planet", velocityFactor: 0, zIndex: -5, offset: CGVector(dx: 0, dy: -250)),
//            .init(fileName: "New planet 2", velocityFactor: 0.012, zIndex: -4, offset: CGVector(dx: 0, dy: -550)),
//            .init(fileName: "New Planet 3", velocityFactor: 0.10, zIndex: -3, offset: CGVector(dx: -140, dy: -550)),
//        ])
        //
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        // Atualizando o parallax
//        parallax.update()
        //
    }
    
}
