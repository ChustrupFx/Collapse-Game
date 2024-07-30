import SpriteKit
import GameplayKit

enum ParallaxType {
    case Default, Background, Fixed
}

// Classe de uma camada do Parallax
class ParallaxItem {
    var velocityFactor: CGFloat
    var parallaxNodes: [SKSpriteNode] = []
    var type: ParallaxType
    var offset: CGVector
    
    init(fileName: String, velocityFactor: CGFloat, zIndex: CGFloat, type: ParallaxType = .Default, offset: CGVector = .init(dx: 0, dy: 0)) {
        self.velocityFactor = velocityFactor
        self.type = type
        self.offset = offset
        
        let texture = SKTexture(imageNamed: fileName)
        let node = SKSpriteNode(texture: texture)
        
        node.zPosition = CGFloat(zIndex)
        node.physicsBody = SKPhysicsBody()
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.isDynamic = true
        node.physicsBody?.collisionBitMask = 0
        node.physicsBody?.contactTestBitMask = 0
        node.physicsBody?.categoryBitMask = 0
        node.position = offset.toCGPoint()
        parallaxNodes.append(node)
    }
        
    // Roda em todo o update da cena
    func update(scene: BaseLevelScene) {
        
        if (self.type != .Fixed) {
            fillHorizontal(scene: scene)
        } else {
            for node in parallaxNodes {
                node.position.x = scene.camera!.position.x + offset.dx
                node.position.y = scene.camera!.position.y + offset.dy
            }
        }

        if (type == .Background) {
            for node in parallaxNodes {
                node.position.y = scene.camera!.position.y
                
            }
        }
        
        applyOffset(scene: scene)
    }
    
    // Preenche os sprites horizontalmente pela tela
    func fillHorizontal(scene: BaseLevelScene) {
                
        let camera = scene.camera!
        
        while (!isRightSideFilled(camera: camera)) {
            
            let lastNode = parallaxNodes.last!
            let newNode = lastNode.copy() as! SKSpriteNode
            newNode.position.x = newNode.position.x + newNode.size.width - 1
            
            scene.addChild(newNode)
            parallaxNodes.append(newNode)
            
        }
        
        while (!isLeftSideFilled(camera: camera)) {
            
            let firstNode = parallaxNodes.first!
            let newNode = firstNode.copy() as! SKSpriteNode
            newNode.position.x = newNode.position.x - newNode.size.width
            
            scene.addChild(newNode)
            parallaxNodes.insert(newNode, at: 0)
        }
        
        
        func isLeftSideFilled(camera: SKCameraNode) -> Bool {
            let firstNodeOfParallax = parallaxNodes.first!
            
            return !isLeftCornerInsideCamera(node: firstNodeOfParallax, camera: camera)
        }
        
        func isRightSideFilled(camera: SKCameraNode) -> Bool {
            
            let lastNodeOfParallax = parallaxNodes.last!
            
            return !isRightCornerInsideCamera(node: lastNodeOfParallax, camera: camera)
            
        }
        
        func isRightCornerInsideCamera(node: SKSpriteNode, camera: SKCameraNode) -> Bool {
            
        
            let rightOfCamera = camera.position.x + scene.frame.size.width / 2
            let rightOfNode = node.position.x + node.size.width / 2
            
            
            return rightOfNode < rightOfCamera
        }
        
        func isLeftCornerInsideCamera(node: SKSpriteNode, camera: SKCameraNode) -> Bool {
            let leftOfCamera = camera.position.x - scene.frame.size.width / 2
            let leftOfNode = node.position.x - node.size.width / 2
            
            
            return leftOfNode > leftOfCamera
        }
    }
    
    // Muda o eixo x dos sprites para dar a ilusão de profundidade (parallax)
    func applyOffset(scene: BaseLevelScene) {
        let cameraController = scene.cameraController
        
        for node in parallaxNodes {
            node.physicsBody?.velocity.dx = -cameraController!.cameraVelocity.dx * velocityFactor
        }
    }
    
    
}

// Classe que cria o plano de fundo em parallax
class Parallax {
    
    var scene: BaseLevelScene
    var items: [ParallaxItem]
    
    
    init(scene: BaseLevelScene, items: [ParallaxItem]) {
        self.scene = scene 
        self.items = items
        
        setup()
    }
    
    // Faz o setup de todos os sprites de parallax
    func setup() {
        
        for item in items {
            let nodes = item.parallaxNodes
            
            for node in nodes {
                node.position = scene.cameraController.camera.position
                
                node.position.x = node.position.x + item.offset.dx
                node.position.y = node.position.y + item.offset.dy
                
                scene.addChild(node)
            }
        }
        
    }
    
    // Roda em todo o update da cena
    func update() {
        
        for item in items {
            item.update(scene: scene)
        }
        
    }
    
    
}
