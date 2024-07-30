//
//  Phase1.swift
//  MiniChallenge
//
//  Created by Leonardo Mesquita Alves on 17/07/23.
//

import Foundation
import SpriteKit
import GameplayKit

class Phase1: BaseLevelScene{
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        // Pegando a posição e o size do botão de dash
        let controllerSize = virtualController.dashButton?.size
        let controllerPosition = virtualController.dashButton?.position
        //
        
        // Criando o brilho para o botão de dash
        shine = SKShapeNode(ellipseOf: CGSize(width: (controllerSize?.width ?? 60) + 10 , height: (controllerSize?.height ?? 60) + 10))
        shine.lineWidth = 18
        shine.strokeColor = .blue
        shine.position = controllerPosition!
        shine.zPosition = virtualController.dashButton!.zPosition - 1
        //
        
        //Adicionar o brilho alinhado a câmera
        camera2.addChild(shine)
        //
        
        // Piscar o shine
        blinkMode(shapeNode: shine)
        //
        
        // Remover a frase inicial depois de um tempo determinado
        for node in self.children {
            if (node.name == "InvisibleLabel") || (node.name == "SuportNode"){
                let action = SKAction.run {
                    node.removeFromParent()
                }
                let sequence = SKAction.sequence([SKAction.wait(forDuration: 5), action])
                run(sequence)
            }
        }
        //
        
        // Adicionando o parallax na cena
//        parallax = Parallax(scene: self, items: [
//            .init(fileName: "New Planet", velocityFactor: 0, zIndex: -5, offset: CGVector(dx: 0, dy: 150)),
//            .init(fileName: "New planet 2", velocityFactor: 0.012, zIndex: -4, offset: CGVector(dx: 0, dy: -190)),
//            .init(fileName: "New Planet 3", velocityFactor: 0.10, zIndex: -3, offset: CGVector(dx: -140, dy: -190)),
//        ])
        //
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        // Atualizando o parallax
//        parallax.update()
    }
    
}
    
