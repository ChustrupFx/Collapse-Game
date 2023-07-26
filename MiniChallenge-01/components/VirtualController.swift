//
//  VirtualController.swift
//  MiniChallenge-01
//
//  Created by Gabriel Eirado on 13/07/23.
//

import SpriteKit
import GameplayKit

protocol VirtualControllerTarget {
    
    func onJoystickChange(direction: CGPoint, angle: CGFloat) -> Void
    func onJoystickJumpBtnTouchStart() -> Void
    func onJoystickJumpBtnTouchEnd() -> Void
    func onJoystickDashBtnTouch(direction: CGVector) -> Void
    
}

class VirtualController: SKNode{
    
    var overlayShadow:SKSpriteNode?
    var overlayPause: SKSpriteNode?
    var isOverlay: Bool = false
    var pauseButton: SKSpriteNode?
    var pauseTouch: UITouch?
    var isAppInForeground: Bool = true
    var exitButton: SKSpriteNode?
    var soundButton: SKSpriteNode?
    
    var virtualJoystickB: SKSpriteNode?
    var virtualJoystickF: SKSpriteNode?
    var jumpButton: SKSpriteNode?
    var dashButton: SKSpriteNode?
    var joystickTouch: UITouch?
    var jumpTouch: UITouch?
    var dashTouch: UITouch?
    var direction: CGVector = CGVector(dx: 0, dy: 0)
    var joystickAngleRounded: CGFloat = 0
    var distanceX: CGFloat = 0 {
        didSet {
            self.target.onJoystickChange(direction: .init(x: self.distanceX, y: self.distanceY), angle: joystickAngleRounded)
        }
    }
    var distanceY: CGFloat = 0 {
        didSet {
            self.target.onJoystickChange(direction: .init(x: self.distanceX, y: self.distanceY), angle: joystickAngleRounded)
        }
    }
    
    var joystickInUse: Bool = false

    var gameScene = BaseLevelScene()
    var target: VirtualControllerTarget!
    
    init(target: VirtualControllerTarget, scene: SKScene){
        super.init()
        isUserInteractionEnabled = true
        
        self.target = target
        
       
        
        //OVERLAY CREDITS BUTTON
        let textureSoundButton = SKTexture(imageNamed: "soundOn")
        soundButton = SKSpriteNode(texture: textureSoundButton, color: .white, size: textureSoundButton.size())
        
        soundButton?.name = "sound"
        soundButton?.zPosition = 10
        
        
        //OVERLAY EXIT BUTTON
        let textureExitButton = SKTexture(imageNamed: "exitButton")
        exitButton = SKSpriteNode(texture: textureExitButton, color: .white, size: textureExitButton.size())
        
        exitButton?.name = "exit"
        exitButton?.zPosition = 10
        
        //OVERLAY SHADOW
        let textureoverlayReturnButton = SKTexture(imageNamed: "overlayReturn")
        
        overlayShadow = SKSpriteNode(texture: textureoverlayReturnButton, size: textureoverlayReturnButton.size())
        
        overlayShadow?.name = "returnOverlay"
        overlayShadow?.zPosition = -1
        
        //OVERLAY PAUSE
        let textureOverlayPause = SKTexture(imageNamed: "overlayPause")
        
        overlayPause = SKSpriteNode(texture: textureOverlayPause, color: .white, size: textureOverlayPause.size())
        
        overlayPause?.name = "overlay"
        overlayPause?.zPosition = 10
        
        
        // PAUSE
        let texturePause = SKTexture(imageNamed: "pause")
        
        pauseButton = SKSpriteNode(texture: texturePause, color: .white, size: texturePause.size())
        
        pauseButton?.name = "pause"
        pauseButton?.zPosition = 11
        
        
        // JOYSTICK
        let textureControllerB = SKTexture(imageNamed: "virtualControllerB")
        let textureControllerF = SKTexture(imageNamed: "virtualControllerF")
        
        virtualJoystickB = SKSpriteNode(texture: textureControllerB, color: .white, size: textureControllerB.size())
        
        virtualJoystickB?.scale(to: CGSize(width: 200, height: 200))
        virtualJoystickB?.name = "controllerBack"
        virtualJoystickB?.zPosition = 5
        virtualJoystickB?.alpha = 0.6
        
        virtualJoystickF = SKSpriteNode(texture: textureControllerF, color: .white, size: textureControllerF.size())
        
        virtualJoystickF?.name = "controllerFront"
        virtualJoystickF?.zPosition = 6
        virtualJoystickF?.alpha = 1
        
        // JUMP
        let textureJump = SKTexture(imageNamed: "jump")
        
        jumpButton = SKSpriteNode(texture: textureJump, color: .white, size: textureJump.size())
        
        jumpButton?.name = "jump"
        jumpButton?.zPosition = 6
        jumpButton?.alpha = 0.9
        
        // DASH
        let textureDash = SKTexture(imageNamed: "dash")
        
        dashButton = SKSpriteNode(texture: textureDash, color: .white, size: textureDash.size())
        
        dashButton?.name = "dash"
        dashButton?.zPosition = 6
        dashButton?.alpha = 0.9
        
        virtualJoystickB?.position = CGPoint(x: scene.size.width / -3 + scene.size.width / 50 , y: scene.size.height  / -5.3)
        virtualJoystickF?.position = CGPoint(x: scene.size.width / -3 + scene.size.width / 50, y: scene.size.height / -5.3)
        
        jumpButton?.position = CGPoint(x:  scene.size.width / 5 + scene.size.width / 9  , y:  scene.size.height  / -4)
        dashButton?.position = CGPoint(x: scene.size.width / 2.6 - scene.size.width / 200, y: scene.size.height / -14 )
        pauseButton?.position = CGPoint(x: scene.size.width / 2.6 + scene.size.width / 20, y: scene.size.height / 3.5 )
        overlayPause?.position = CGPoint (x: scene.size.width / 3 - scene.size.width / 3 , y: scene.size.height / 14)
        overlayShadow?.position = CGPoint (x: scene.size.width / 3 - scene.size.width / 200, y: scene.size.height / -12)
        exitButton?.position = CGPoint (x: scene.size.width / 9 - scene.size.width / 20 , y: scene.size.height / -10)
        soundButton?.position = CGPoint (x: scene.size.width / -15 - scene.size.width / 20 , y: scene.size.height / -10)
        
        
        
        
        addOverlay()
        addPause()
        addJump()
        addDash()
        addController()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Error")
    }
    
    // JOYSTICK
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        for t in touches{
            
            let location = t.location(in: parent!)
            
            // Player não pular durante o pause
            if isOverlay && jumpButton!.frame.contains(location) {
                       return
                   }
            
            if pauseButton!.frame.contains(location) {
                pauseTouch = t
                if isOverlay {
                    resumeGame()
                } else {
                    pauseGame()
                }
            }
            if jumpButton!.frame.contains(location){
                
                jumpButton?.alpha = 0.6
                let action = SKAction.wait(forDuration: 0.4)
                let reverse = SKAction.run {
                    self.jumpButton?.alpha = 0.9
                }
                run(SKAction.sequence([action, reverse]))
                jumpTouch = t
                
                target.onJoystickJumpBtnTouchStart()
            }
            
            if dashButton!.frame.contains(location){

                dashButton?.alpha = 0.6
                let action = SKAction.wait(forDuration: 0.4)
                let reverse = SKAction.run {
                    self.dashButton?.alpha = 0.9
                }
                run(SKAction.sequence([action, reverse]))
                
                dashTouch = t
                
                target.onJoystickDashBtnTouch(direction: direction)
            }
            
            
            firstTouch(location: location, touch: t)
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil{
            for t in touches{
                if t == joystickTouch && !isOverlay {
                    let location = t.location(in: overlayPause!)
                    
                    if overlayShadow!.frame.contains(location) {
                        // Despausar o jogo e remover o overlay de pausa
                        resumeGame()
                    }
                    movementReset(size: scene!.size)
                }
                
                if t == jumpTouch {
                    target.onJoystickJumpBtnTouchEnd()
                }
            }
        }
    }
    
    func firstTouch(location: CGPoint, touch: UITouch ){
        
        if virtualJoystickF!.frame.contains(location) && location.x < 0{
            joystickInUse = true
            joystickTouch = touch
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches{
            if touches.first == t{
                if t == joystickTouch && !isOverlay{
                    
                    let location = t.location(in: parent!)
                    
                    drag(location: location)
                    
                }
            }
            
        }
    }
    
    func drag(location: CGPoint) {
        
        if joystickInUse{
            //            print("in use")
            
            
            let point = CGPoint(x: location.x - virtualJoystickB!.position.x, y: location.y - virtualJoystickB!.position.y).normalize()
            
            let angle = atan2(point.y, point.x)
            
            joystickAngleRounded = atan2(point.y, point.x).rounded() * (CGFloat.pi / 4)
            
            direction = CGVector(dx: point.x, dy: point.y)
            
            
            let distanceFromCenter = CGFloat(virtualJoystickB!.frame.size.width / 2) // limita o botao pequeno
            
            distanceX = CGFloat(sin(angle - CGFloat.pi / 2) * distanceFromCenter) * -1
            distanceY = CGFloat(cos(angle - CGFloat.pi / 2) * -distanceFromCenter) * -1
            
            
            //let radiusB = controllerJoystick.virtualControllerB.size.width / 2
            
            if virtualJoystickB!.frame.contains(location){
                //                        -location.x / 4 > radiusB && -location.x / 5.8 < radiusB  &&  -location.y * 0.9 > radiusB  && -location.y / 2.9 < radiusB {
                // 0.8 é o meio até o lado para o x
                
                virtualJoystickF!.position = location
                // -267
                
            }else{
                
                virtualJoystickB!.position = CGPoint(x: virtualJoystickF!.position.x - distanceX , y: virtualJoystickF!.position.y - distanceY)
                
                virtualJoystickF!.position = location
            }
        }
    }
    
    func movementReset(size: CGSize){
        
        let moveback = SKAction.move(to: CGPoint(x: size.width / -3 + size.width / 50, y: size.height  / -5.3), duration: 0.1)
        moveback.timingMode = .linear
        virtualJoystickF?.run(moveback)
        virtualJoystickB?.run(moveback)
        joystickInUse = false
        distanceX = 0
        distanceY = 0
        direction = CGVector(dx: 0, dy: 0)
        
    }
    
    
    func addController(){
        
        addChild(virtualJoystickB!)
        addChild(virtualJoystickF!)
        
    }
    
    // JUMP
    
    func addJump(){
        addChild(jumpButton!)
    }
    
    
    // DASH
    
    func addDash(){
        
        
        addChild(dashButton!)
        
    }
    // PAUSE
    func addPause() {
        addChild(pauseButton!)
    }
    
    //OVERLAY PAUSE - Tudo que estiver no overlay de Pause deve ser adicionado como filho de overlayPause.
    func addOverlay (){
        
        addChild(overlayPause!)
        overlayPause?.isHidden = true
        overlayPause?.addChild(overlayShadow!)
        overlayPause?.addChild(exitButton!)
        overlayPause?.addChild(soundButton!)
    }
    // PAUSE GAME
    func pauseGame() {
        isOverlay = true
        overlayPause?.isHidden = false
        
        scene?.isPaused = true
    }
    
    // RESUME GAME
    func resumeGame() {
        isOverlay = false
        overlayPause?.isHidden = true
        scene?.isPaused = false
    }
   
}

