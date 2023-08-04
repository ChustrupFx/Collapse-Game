//
//  lvForDash.swift
//  MiniChallenge
//
//  Created by Gabriel Eirado on 01/08/23.
//

import Foundation
import SpriteKit
import GameplayKit

class LvForDash: BaseLevelScene{
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        // Adicionando o parallax na cena
        parallax = Parallax(scene: self, items: [
            .init(fileName: "New Planet", velocityFactor: 0, zIndex: -5, offset: CGVector(dx: 100, dy: 100)),
            .init(fileName: "New Planet", velocityFactor: 0, zIndex: -5, offset: CGVector(dx: -1000, dy: 1400)),
            .init(fileName: "New Planet", velocityFactor: 0, zIndex: -5, offset: CGVector(dx: 500, dy: 2400)),
            .init(fileName: "New planet 2", velocityFactor: 0.012, zIndex: -4, offset: CGVector(dx: 0, dy: 350)),
            .init(fileName: "New Planet 3", velocityFactor: 0.10, zIndex: -3, offset: CGVector(dx: -140, dy: 350)),
        ])
        //
    }
}
