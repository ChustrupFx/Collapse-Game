//
//  FinalScene.swift
//  MiniChallenge
//
//  Created by Leonardo Mesquita Alves on 24/07/23.
//

import SpriteKit

class FinalScene: BaseLevelScene{
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        //Configurar a altura da câmera
        cameraController.configHeight = 130
        
        
        // Colocar o parallax na cena
//        parallax = Parallax(scene: self, items: [
//            .init(fileName: "Nuvens", velocityFactor: 0.06, zIndex: -1, offset: CGVector(dx: 0, dy: 150)),
//            .init(fileName: "Nuvens2", velocityFactor: 0.08, zIndex: -2, offset: CGVector(dx: 0, dy: 60)),
//            .init(fileName: "Noite Estrelada", velocityFactor: 0.005, zIndex: -4, type: .Background)
//        ])
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        // Trigger para a próxima cena
        if (childNode(withName: "FinalTrigger")?.position.x)! > player.node.position.x{
            if let scene = SKScene(fileNamed: "ExplainScene3") {
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition: SKTransition.push(with: SKTransitionDirection.down, duration: 3))
            }
        }
        
        // Atualizar o parallax
//        parallax.update()
    }
}
