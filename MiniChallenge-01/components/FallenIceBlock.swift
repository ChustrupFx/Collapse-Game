//
//  FallenBlocks.swift
//  MiniChallenge
//
//  Created by Leonardo Mesquita Alves on 18/07/23.
//

import SpriteKit

extension BaseLevelScene{
    
    // Sumonar os blocos de água que caem
    func createFallenWater(){
        for node in self.children {
            if (node.name == "FallenCreating"){
                
                let creating = SKAction.run {
                    if let someTileMap: SKTileMapNode = node as? SKTileMapNode {
                        self.giveTileMapPhysicsBodyFallenBlocks(map: someTileMap, textureWidth: 50, tileMapProportion: 64)
                    }
                }
                
                let waiting = SKAction.wait(forDuration: 0.08)
                let waiting2 = SKAction.wait(forDuration: 0.15)
                let waiting3 = SKAction.wait(forDuration: 0.15 * 5.5)
                let sequence1 = SKAction.sequence([creating, waiting2])
                
                let makeItHappend = SKAction.sequence([waiting, creating, sequence1, sequence1, sequence1, sequence1, waiting3])
                run(SKAction.repeatForever(makeItHappend))
            }
        }
    }
    //
    
    // Criando o corpo físico da água que caem
    func giveTileMapPhysicsBodyFallenBlocks(map: SKTileMapNode, textureWidth: Double, tileMapProportion: Double){
        
        let proportion = (textureWidth / tileMapProportion)
        
        //Basico do collision do tilemap
        let tileMap = map
        let startingLocation:CGPoint = tileMap.position
        let tileSize = tileMap.tileSize
        let halfWidth = CGFloat (tileMap.numberOfColumns) / 2.0 * tileSize.width
        let halfHeight = CGFloat(tileMap.numberOfRows) / 2.0 * tileSize.height
        
        for col in 0..<tileMap.numberOfColumns {
            
            for row in 0..<tileMap.numberOfRows {
                
                if let tileDefinition = tileMap.tileDefinition(atColumn: col, row: row){
                    let tileArray = tileDefinition.textures
                    let tileTexture = tileArray[0]
                    
                    let x = CGFloat(col) * tileSize.width - halfWidth + (tileSize.width / 2)
                    let y = CGFloat(row) * tileSize.height - halfHeight + (tileSize.height / 2)
                    
                    //Criação da textura
                    let tileNode = SKSpriteNode(texture: tileTexture)
                    tileNode.scale(to: CGSize(width: tileTexture.size().width/proportion, height: tileTexture.size().height/proportion))
                    tileNode.position = CGPoint(x: x, y: y)
                    tileNode.zPosition = 0
                    
                    tileNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: (tileTexture.size().width/proportion) - 5 , height: (tileTexture.size().height/proportion) - 10))
                    tileNode.physicsBody?.mass = 1000
                    tileNode.physicsBody?.affectedByGravity = true
                    tileNode.physicsBody?.allowsRotation = false
                    tileNode.physicsBody?.isDynamic = true
                    tileNode.physicsBody?.linearDamping = 15
                    tileNode.physicsBody?.categoryBitMask =  PhysicsCategory.water.rawValue
                    tileNode.physicsBody?.collisionBitMask = PhysicsCategory.limit.rawValue
                    tileNode.physicsBody?.contactTestBitMask = PhysicsCategory.player.rawValue | PhysicsCategory.limit.rawValue
                    tileNode.name = "FallWater"
                    
                    tileNode.position = CGPoint(x: (tileNode.position.x + startingLocation.x) , y: tileNode.position.y + startingLocation.y)
                    
                    tileNode.run(
                        .repeatForever(
                            .repeatForever(
                                .animate(
                                    with: .init(
                                        format: "fallWater %@",
                                        frameCount: 1...3
                                    ),
                                    timePerFrame: 0.25
                                )
                            )
                        )
                    )
                    
                    let action = SKAction.wait(forDuration: 4.8)
                    self.addChild(tileNode)
                    let removeAction = SKAction.run {
                        tileNode.removeFromParent()
                    }
                    let action2 = SKAction.sequence([action, removeAction])
                    run(action2)
                    
                    let waterEntity = WaterEntity(node: tileNode)


                    tileNode.entity = waterEntity


                    self.triggersManager.addComponent(foundIn: waterEntity)
                    self.entities.append(waterEntity)
                }
            }
        }
        
        
    }
    
    
    // Criando uma solução para fazer a água que cae desaparecer da cena
    func creatingLimitesForTheScene(){
        for node in self.children{
            if node.name == "FallWater"{
                for node2 in self.children{
                    if node2.name == "Limit"{
                        if isNodeCloseOnY(node, closeTo: node2, distanceThreshold: 20) && isNodeCloseOnX(node, closeTo: node2, distanceThreshold: 300) || !isNodeCloseOnX(node, closeTo: player.node, distanceThreshold: 777){
                            node.removeFromParent()
                        }
                    }
                }
                
                
            }
        }
    }
    
    // Aplicando uma força para a águ cair mais rápido
    func applyingForceToFallWater(){
        for node in self.children{
            if node.name == "FallWater"{
                node.physicsBody?.applyForce(CGVector(dx: 0, dy: -3000000))
            }
        }
    }
    
    
}
