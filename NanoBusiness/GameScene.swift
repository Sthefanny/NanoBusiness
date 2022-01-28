//
//  GameScene.swift
//  NanoBusiness
//
//  Created by Sthefanny Gonzaga on 27/01/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var bg1: SKNode!
    var bg2: SKNode!
    var bg3: SKNode!
    var bg4: SKNode!
    var bg5: SKNode!
    var bgLoop: SKAction!
    
    var player: Player!
    var obstacleManager: ObstacleManager!
    
    var lastUpdate = TimeInterval(0)
    
    var status: GameStatus = .intro
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        createBackground()
        
        let playerNode = self.childNode(withName: "player") as! SKSpriteNode
        player = Player(node: playerNode)
        
        let obstacleModel = childNode(withName: "obstacleGround")!
        obstacleManager = ObstacleManager(obstacleModel: obstacleModel, parent: self)
    }
    
    func getBgLoop(timeInterval: TimeInterval) -> SKAction {
        let moveLeft = SKAction.moveBy(x: -self.size.width, y: 0, duration: timeInterval)
        let moveBack = SKAction.moveBy(x: self.size.width, y: 0, duration: 0)
        let sequence = SKAction.sequence([moveLeft, moveBack])
        
        return SKAction.repeatForever(sequence)
    }
    
    func createBackground() {
        bg1 = self.childNode(withName: "bg1")!
        bg2 = self.childNode(withName: "bg2")!
        bg3 = self.childNode(withName: "bg3")!
        bg4 = self.childNode(withName: "bg4")!
        bg5 = self.childNode(withName: "bg5")!
        
        bg1.run(getBgLoop(timeInterval: TimeInterval(50)))
        bg2.run(getBgLoop(timeInterval: TimeInterval(40)))
        bg3.run(getBgLoop(timeInterval: TimeInterval(30)))
        bg4.run(getBgLoop(timeInterval: TimeInterval(20)))
        bg5.run(getBgLoop(timeInterval: TimeInterval(10)))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch status {
        case .intro:
            break
        case .playing:
            break
        case .gameOver:
            break
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if lastUpdate == 0 {
            lastUpdate = currentTime
            return
        }
        
        let deltaTime = currentTime - lastUpdate
        lastUpdate = currentTime
        
        switch status {
        case .intro:
            playingUpdate(deltaTime: deltaTime)
            
//            scrollBackground(deltaTime: deltaTime)
        case .playing:
            break
        case .gameOver:
            break
        }
    }
    
    func playingUpdate(deltaTime: TimeInterval) {
        obstacleManager.update(deltaTime: deltaTime)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("contato = \(contact)")
    }
    
    func PunchPressed() {
        print("punch")
    }
    func FootPressed() {
    }
    func UpPressed() {
    }
    func DownPressed() {
    }
}
