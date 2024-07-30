//
//  Prologue.swift
//  MiniChallenge
//
//  Created by Leonardo Mesquita Alves on 21/07/23.
//

import SpriteKit

class Prologue: BaseLevelScene{
    var startJumpText = false
    var finishJumpText = false
    var startAnimation: Bool = false {
        didSet {
            if (self.startAnimation) {
                audioPlayer.setVolume(volume: 0, interval: 1)
            }
        }
    }
    var finishAnimation: Bool = false
    
    
    var scriptMove: SKSpriteNode!
    var pier: SKSpriteNode!
    var pierPhysicsBody: SKSpriteNode!
    
    var audioPlayer = AudioManager(fileName: "calma-triste")
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        // Relacionando node do editor a variáveis
        scriptMove = childNode(withName: "ScriptMove")! as? SKSpriteNode
        pier = childNode(withName: "Pier")! as? SKSpriteNode
        pierPhysicsBody = childNode(withName: "PierPhysicsBody")! as? SKSpriteNode
        //
        
        addVisualBug(nameOfTheAsset: "Bug")
        
        // Pegando o tamanho do botão de jump
        let controllerSize = virtualController.jumpButton?.size
        //
        
        // Criando brilho para o botão de pulo
        shine = SKShapeNode(ellipseOf: CGSize(width: (controllerSize?.width ?? 60) + 10 , height: (controllerSize?.height ?? 60) + 10))
        shine.lineWidth = 25
        //
        
        // Alterando a altura da câmera
        cameraController.configHeight = 130
        //
        
        // Tirando o botão de dash da cena alterando o zPosition e o alpha
        virtualController.dashButton?.zPosition = -10
        virtualController.dashButton?.alpha = 0
        //
        
        virtualController.jumpButton?.alpha = 0
        
        // Adicionar o parallax
//        parallax = Parallax(scene: self, items: [
//            .init(fileName: "Nuvens", velocityFactor: 0.06, zIndex: -1, offset: CGVector(dx: 0, dy: 150)),
//            .init(fileName: "Nuvens2", velocityFactor: 0.08, zIndex: -2, offset: CGVector(dx: 0, dy: 60)),
//            .init(fileName: "Noite Estrelada", velocityFactor: 0.005, zIndex: -4, type: .Background)
//        ])
        //
        
        audioPlayer.setVolume(volume: 1, interval: 3).setLoops(loops: -1).play()
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        // Início da animação do prólogo
        if startAnimation && !finishAnimation{
            camera2.zPosition = -10
            camera2.alpha = 0
            self.isUserInteractionEnabled = false
            virtualController.movementReset(size: scene!.size)
            finishAnimation = true
            cameraController.configWidth = 400

            let wait = SKAction.wait(forDuration: 3)
            
            run(SKAction.sequence([wait, SKAction.run {
                self.addVisualBug(nameOfTheAsset: "Bug 1")
                self.run(SKAction.playSoundFileNamed("BUG1.mp3", waitForCompletion: false))
            }, wait, SKAction.run {
                self.addVisualBug(nameOfTheAsset: "Bug 2")
                self.run(SKAction.playSoundFileNamed("BUG1.mp3", waitForCompletion: false))
            }, wait, SKAction.run {
                self.addVisualBug(nameOfTheAsset: "Bug 3")
                self.pier.removeFromParent()
                self.pierPhysicsBody.removeFromParent()
                self.run(SKAction.playSoundFileNamed("BUG1.mp3", waitForCompletion: false))
            }, SKAction.wait(forDuration: 0.3), SKAction.run {
                self.run(SKAction.playSoundFileNamed("BUG1.mp3", waitForCompletion: false))
                self.run(SKAction.playSoundFileNamed("BUG2.mp3", waitForCompletion: false))
                self.addBigVisualBug(nameOfTheAsset: "BigVisualBug")
            }, SKAction.wait(forDuration: 1), SKAction.run {
                if let scene = SKScene(fileNamed: "ExplainScene2") {
                    scene.scaleMode = .aspectFill
                    self.view?.presentScene(scene, transition: SKTransition.fade(with: .white, duration: 4))
                }
            }]))
            
        } else if !startAnimation && player.node.position.x > (childNode(withName: "InvisibleNode2")?.position.x ?? 500){
            startAnimation = true
        } else if finishAnimation{
            self.scene?.isPaused = false
        }
        
        
        
        
        if startJumpText && !finishJumpText{
            changeNodeAlpha(name: "LabelInvisible", alpha: 1)
            
            let controllerPosition = virtualController.jumpButton?.position
            shine.strokeColor = .systemPink
            shine.position = controllerPosition!
            shine.zPosition = virtualController.jumpButton!.zPosition - 1
            camera2.addChild(shine)
            virtualController.jumpButton?.alpha = 0.9
            
            blinkMode(shapeNode: shine)
            
            finishJumpText = true
            
        } else if !startJumpText && player.node.position.x > (childNode(withName: "InvisibleNode")?.position.x ?? 500){
            startJumpText = true
        }
        
        // Atualizar o parallax
//        parallax.update()
        //
    }
    
    // Mudar o alpha de um node
    func changeNodeAlpha(name: String, alpha: Double){
        for node in self.children{
            if node.name == name{
                node.alpha = alpha
            }
        }
    }
}

extension SKScene{
    // Fazer um node piscar algumas vezes
    func blinkMode(shapeNode: SKShapeNode){
        let fadeInAction = SKAction.fadeAlpha(to: 0.1, duration: 0.5)
                let fadeOutAction = SKAction.fadeAlpha(to: 1.0, duration: 0.2)

                let blinkSequence = SKAction.sequence([fadeInAction, fadeOutAction])
                let blinkForever = SKAction.repeat(blinkSequence, count: 7)

        shapeNode.run(SKAction.sequence([blinkForever, SKAction.run {
            shapeNode.removeFromParent()
        }]) )
                
    }
    //
    
}
