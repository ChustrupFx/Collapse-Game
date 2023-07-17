import SpriteKit
import GameplayKit

class BaseLevelScene: SKScene, SKPhysicsContactDelegate{
    
    //    var camere: SKCameraNode = SKCameraNode()
    
    private let player = Player()
    private var ground = Ground()
    private var plataform: SKSpriteNode = SKSpriteNode()
    
    private var hud = SKNode()
    
    private var controllerJoystick = ControllerJoystick()

    private var jump = JumpButton()
    private var dash = DashButton()
    private var joystickInUse: Bool = false
    private var selectedNodes: [UITouch:SKSpriteNode] = [:]
    
    var controls: [String: ()] = [:]
    var distanceX: CGFloat = 0
    var distanceY: CGFloat = 0
    var joystickTouch: UITouch?
    var joystickAngle: CGFloat = 0
    var triggersManager: GKComponentSystem<TriggerComponent>!
    
    var cameraController: CameraController!
    let camera2 = SKCameraNode()
    
    var entities: [GKEntity] = []
    
    override func didMove(to view: SKView) {
        
        triggersManager = GKComponentSystem(componentClass: TriggerComponent.self)
        
        physicsWorld.contactDelegate = self
        backgroundColor = SKColor.gray
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        self.view?.isMultipleTouchEnabled = true
        
        self.camera = camera2
        
        addChild(camera2)
        camera2.addChild(hud)
        
        
        cameraController = CameraController(camera: self.camera!, target: player, boundaries: nil)
        
        addPlayer()
        addGround()
        addPlataform()
        addController()
        addJump()
        addDash()
        
        print(controllerJoystick.virtualControllerB.position)
        setupDoors()
  
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        print(triggersManager.components)
        for triggerComponent in triggersManager.components {
            
            if let triggerNode = triggerComponent.entity?.component(ofType: SpriteComponent.self)?.node {
                
                if triggerNode == nodeA {
                    triggerComponent.callback()
                }
                
                if triggerNode == nodeB {
                    triggerComponent.callback()
                }
                
                
                
            }
            
        }
    }
    
    func setupDoors() {
        
        if let doors = childNode(withName: "doors")?.children as? [SKSpriteNode]
            {
                    
            for door in doors {
                let doorEntity = DoorEntity(node: door)
                
                doorEntity.addComponent(DoorComponent())
                triggersManager.addComponent(foundIn: doorEntity)
                self.entities.append(doorEntity)
            }
                
                
            }
        
    }
    
    
    
    
    override func sceneDidLoad() {
        
        
        let cameraBounds = self.frame.width / 2
        let bounds = self.calculateAccumulatedFrame().width/2 - cameraBounds
        let cameraConstraint = SKConstraint.positionX(SKRange(lowerLimit: -bounds, upperLimit: bounds))
        self.camera?.constraints = [cameraConstraint]
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches{
            
            let location = t.location(in: camera2)
            
            let touchedNode = self.atPoint(t.location(in: self))
            
            let controls: [String: () -> Void] = [
                "jump": applyJump,
                "dash": applyDash
            ]
            
            if let nodeName = touchedNode.name {
                if (controls.contains{ $0.key == nodeName }) {
                    controls[nodeName]!()
                }
            }
            
//            controllerJoystick.virtualControllerB.position = location
//            controllerJoystick.virtualControllerF.position = location
            
            if controllerJoystick.virtualControllerF.frame.contains(location){
                
                joystickInUse = true
                self.joystickTouch = t
                print("move")
            }
        }
    }
    
    func movementPossible(){
        joystickInUse = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches{
            if touches.first == t{
                let location = t.location(in: camera2)
                
                //            print(t == self.joystickTouch)  verifica se o toque foi o mesmo
                if joystickInUse{
                    
                    let point = CGPoint(x: location.x - controllerJoystick.virtualControllerB.position.x, y: location.y - controllerJoystick.virtualControllerB.position.y).normalize()
                    
                    joystickAngle = atan2(point.y, point.x)
                    
                    let distanceFromCenter = CGFloat(controllerJoystick.virtualControllerB.frame.size.width / 2) // limita o botao pequeno
                    
                    distanceX = CGFloat(sin(joystickAngle - CGFloat.pi / 2) * distanceFromCenter) * -1
                    distanceY = CGFloat(cos(joystickAngle - CGFloat.pi / 2) * -distanceFromCenter) * -1
                    
                    let xDirection: CGFloat = distanceX < 0 ? -1 : 1
                    player.xScale = xDirection
                    // raiz de 2 - 1
                    
//                    let radiusB = controllerJoystick.virtualControllerB.size.width / 2
                    
                    if controllerJoystick.virtualControllerB.frame.contains(location){
//                        -location.x / 4 > radiusB && -location.x / 5.8 < radiusB  &&  -location.y * 0.9 > radiusB  && -location.y / 2.9 < radiusB {
                        // 0.8 é o meio até o lado para o x
                        
                        controllerJoystick.virtualControllerF.position = location
                        // -267
                        
                    }else{
                        
                        controllerJoystick.virtualControllerB.position = CGPoint(x: controllerJoystick.virtualControllerF.position.x - distanceX, y: controllerJoystick.virtualControllerF.position.y - distanceY)
                        
                        controllerJoystick.virtualControllerF.position = location
                        
                    }
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if touches.first != nil{
            for t in touches{
                if t == self.joystickTouch {
                    
                    let moveback = SKAction.move(to: CGPoint(x: size.width / -3 + size.width / 50, y: size.height  / -3.7), duration: 0.1)
                    moveback.timingMode = .linear
                    controllerJoystick.virtualControllerF.run(moveback)
                    controllerJoystick.virtualControllerB.run(moveback)
                    joystickInUse = false
                    
                    
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if !joystickInUse{
            
            distanceX = 0
            
        }
        
        applyMovement()
    }
    
    override func didFinishUpdate() {
        
        self.cameraController.onFinishUpdate()
        
    }
    

    
    func applyMovement(){
        
        player.physicsBody!.velocity.dx = distanceX * 4
        
    }
    
    func applyDash(){
        
        player.physicsBody!.applyImpulse(CGVector(dx: distanceX, dy: distanceY))
        
    }
    
    func applyJump(){
        
        player.physicsBody?.applyImpulse(CGVector(dx: player.size.width, dy: player.size.height * 0.5))
    }
    
    func addPlataform(){
        
        plataform = SKSpriteNode(imageNamed: "plataform")
        plataform.position = CGPoint(x: 0 , y: 0 + plataform.size.height)
        plataform.zPosition = 1
        plataform.physicsBody = SKPhysicsBody(texture: plataform.texture!, size: plataform.size)
        plataform.physicsBody?.affectedByGravity = false
        plataform.physicsBody?.isDynamic = false
        
        addChild(plataform)
        
    }
    
    func addPlayer(){
        
        player.position = CGPoint(x: 0, y: 0)
        self.addChild(player)
        
    }
    
    func addGround(){
        
        ground.position = CGPoint(x: 0, y: 0 - ground.size.height)
        self.addChild(ground)
        
    }
    
    func addController(){
        
        controllerJoystick.virtualControllerB.position = CGPoint(x: size.width / -3 + size.width / 50 , y: size.height  / -3.7)
        controllerJoystick.virtualControllerF.position = CGPoint(x: size.width / -3 + size.width / 50, y: size.height / -3.7)
        
        
        
        hud.addChild(controllerJoystick.virtualControllerB)
        hud.addChild(controllerJoystick.virtualControllerF)
        
    }
    
    func addJump(){
        
        jump.position = CGPoint(x: size.width / -30 + size.width / -20 , y: size.height  / -3.7)
        hud.addChild(jump)
        
    }
    
    func addDash(){
        
        dash.position = CGPoint(x: size.width - 570, y: size.height - 440)
        hud.addChild(dash)
        
    }
}
