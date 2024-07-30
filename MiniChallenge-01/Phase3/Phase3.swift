//
//  Phase3.swift
//  MiniChallenge
//
//  Created by Leonardo Mesquita Alves on 17/07/23.
//

import Foundation
import SpriteKit
import GameplayKit

class Phase3: BaseLevelScene{
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        // Adicionando o parallax na cena
//        parallax = Parallax(scene: self, items: [
//            .init(fileName: "New Planet", velocityFactor: 0, zIndex: -5, offset: CGVector(dx: 0, dy: 450)),
//            .init(fileName: "New Planet", velocityFactor: 0, zIndex: -5, offset: CGVector(dx: 0, dy: 650)),
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
