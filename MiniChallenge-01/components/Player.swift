//
//  Player.swift
//  MiniChallenge-01
//
//  Created by Gabriel Eirado on 12/07/23.
//

import SpriteKit
import GameplayKit

class Player: VirtualControllerTarget{
    
    var playerNode: SKSpriteNode!
    var stateMachine: GKStateMachine?
    var velocityX: CGFloat = 0
    var angle: CGFloat = 0
    
    init(){
        let texture = SKTexture(imageNamed: "player")
        
        playerNode = SKSpriteNode(texture: texture, color: .red, size: texture.size())
        
        playerNode.name = "player"
        
        playerNode.zPosition = 1
        
        playerNode.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        playerNode.physicsBody?.collisionBitMask = PhysicsCategory.player.rawValue
        playerNode.physicsBody?.allowsRotation = false
        playerNode.physicsBody?.isDynamic = true
    }
    
    func applyMachine(){
        
        stateMachine = GKStateMachine(states: [
            PlayerIdle(), PlayerRun(), PlayerJump(), PlayerDash()
        ])
        
        stateMachine?.enter(PlayerIdle.self)
    }
    
    func onJoystickChange(direction: CGPoint, angle: CGFloat) {
    
        applyMovement(distanceX: direction.x, angle: angle)
    
        velocityX = direction.x
        self.angle = angle
        
        let xDirection: CGFloat = direction.x < 0 ? -1 : 1
        playerNode.xScale = xDirection
        
    }

    func onJoystickJumpBtnTouch() {
        jump()
    }
    
    func onJoystickDashBtnTouch(direction: CGVector) {
        dash(direction: direction)
    }
    
    func applyMovement(distanceX: CGFloat, angle: CGFloat){
        
        playerNode.physicsBody!.velocity.dx = distanceX  * 4
        
            
        if angle > 1.51 || angle < -1.51{

            playerNode.xScale = -1

        } else{
            
            playerNode.xScale = 1
            
        }
        
        
        if distanceX != 0{
            
            stateMachine?.enter(PlayerRun.self)
        }
    }
    
    func update() {
        applyMovement(distanceX: velocityX, angle: angle)
    }
    
    func jump(){
        
<<<<<<< Updated upstream
        playerNode.physicsBody?.applyImpulse(CGVector(dx: 0 , dy: playerNode.size.height / 2))
=======
       
    playerNode.physicsBody?.applyImpulse(CGVector(dx: 0 , dy: playerNode.size.height / 2))
        
    }
    
    func onJoystickDashBtnTouch(direction: CGVector) {
>>>>>>> Stashed changes
        
        stateMachine?.enter(PlayerJump.self)
    }
    //
    func dash(direction: CGVector){
        
        playerNode.physicsBody?.applyImpulse(CGVector(dx: direction.dx * 50 , dy: direction.dy * 50 ))
        
        stateMachine?.enter(PlayerDash.self)
        
<<<<<<< Updated upstream
//        print(direction)
=======
    }
    
    func dash(direction: CGVector){
        
        if stateMachine.currentState is PlayerDash == false{
            playerNode.physicsBody?.applyImpulse(CGVector(dx: direction.dx * 30 , dy: direction.dy * 30 ))
        }
 
        self.playerNode.run(.sequence([.wait(forDuration: 0.5), .run{
            self.stateMachine?.enter(PlayerIdle.self)
        }]))
>>>>>>> Stashed changes
    }
}

class PlayerIdle: GKState {
    
    override func didEnter(from previousState: GKState?) {
        
   
    }
    
    func move() {
        
    }
}

class PlayerRun: GKState{
    
<<<<<<< Updated upstream
    //    var gameScene = PlataformGameScene()
    var isRunning = false
    
    override func didEnter(from previousState: GKState?) {
        
//        print("Estou correndo")
        
        isRunning = true
=======

    var player = Player()
    
    
    override func didEnter(from previousState: GKState?) {
        
        print("run")

>>>>>>> Stashed changes
        
    }
}

class PlayerJump: GKState{
    
<<<<<<< Updated upstream
    var player = Player()
    var onAir = false
    
=======
>>>>>>> Stashed changes
    override func didEnter(from previousState: GKState?) {

        onAir = true
    }
}

class PlayerDash: GKState{
    
    override func didEnter(from previousState: GKState?) {
        
    }
    
    override func willExit(to nextState: GKState) {
       
    }
}
