//
//  SwinPhase.swift
//  MiniChallenge
//
//  Created by Leonardo Mesquita Alves on 24/07/23.
//

import SpriteKit

class SwinPhase: BaseLevelScene{
    var swinButton: SKSpriteNode!
    var isTouched = false
    var canBlind = false
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        // Criação do brilho para o botão de nadar
        shine = SKShapeNode(ellipseOf: CGSize(width: (virtualController.jumpButton?.size.width)! + 10 , height: (virtualController.jumpButton?.size.height)! + 10))
        shine.lineWidth = 25
        shine.strokeColor = .yellow
        shine.position = (virtualController.jumpButton?.position)!
        shine.zPosition = virtualController.jumpButton!.zPosition - 1
        //
        
        // Adiciona a câmera na cena
        camera2.addChild(shine)
        
        // Faz o shine piscar
        blinkMode(shapeNode: shine)
        
        // Altera a altura da câmera
        cameraController.configHeight = 100
        
        // Criação e adição do botão de nado na cena
        swinButton = SKSpriteNode(imageNamed: "jump")
        swinButton.position = (virtualController.jumpButton?.position)!
        swinButton.zPosition = (virtualController.jumpButton?.zPosition)!
        swinButton.alpha = 0.9
        camera2.addChild(swinButton)
        //
        
        // Tirando o botões de pulo e dash da cena pela opacidade
        virtualController.jumpButton?.alpha = 0
        virtualController.dashButton?.alpha = 0
        
        
        player.node.physicsBody?.linearDamping = 1
        
        // Adiciona o parallax na cena
//        parallax = Parallax(scene: self, items: [
//            .init(fileName: "New Planet", velocityFactor: 0, zIndex: -5, offset: CGVector(dx: 0, dy: 450)),
//            .init(fileName: "New planet 2", velocityFactor: -0.02, zIndex: -4, offset: CGVector(dx: 150, dy: 200)),
//            .init(fileName: "New Planet 3", velocityFactor: 0.06, zIndex: -3, offset: CGVector(dx: -140, dy: 200)),
//        ])
        //
        
        // Cria as animações para a água
        for node in self.children{
            if (node.name == "WaterFake"){
                if let someTileMap:SKTileMapNode = node as? SKTileMapNode{
                    giveTileMapPhysicsBodyWater(map: someTileMap, textureWidth: 64, tileMapProportion: 64)
                    someTileMap.removeFromParent()
                }
            }
        }
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        super.update(currentTime)
        
        // Cria a lógica de nado
        if player.node.position.y < (childNode(withName: "Limiting gravity")?.position.y)! && isTouched{
            self.physicsWorld.gravity = CGVector(dx: 0, dy: 5)
        } else if  player.node.position.y > (childNode(withName: "Limiting gravity")?.position.y)!{
            self.physicsWorld.gravity = CGVector(dx: 0, dy: -4)
            
        } else if player.node.position.y < ((childNode(withName: "Limiting gravity")?.position.y)!) + 10{
            player.node.physicsBody?.applyForce(CGVector(dx: 0, dy: 144))
        }
        //
        
        // Trigger para aparece a label "Não desista"
        if (childNode(withName: "LabelTrigger")?.position.x)! > player.node.position.x{
            childNode(withName: "Label1")?.alpha = 1
        }
        
        // Trigger para aparece a próxima cena
        if (childNode(withName: "TriggerBlind")?.position.x)! > player.node.position.x{
            if let scene = SKScene(fileNamed: "FinalScene") {
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 4))
            }
        }
        
        // Atualizar o parallax
//        parallax.update()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: camera2)
            
        // Lógica de ativação do botão
        if swinButton.contains(touchLocation){
            swinButton.alpha = 0.6
            isTouched = true
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        // Volta o botão ao estado original
        swinButton.alpha = 0.9
        isTouched = false

    }
    

}
