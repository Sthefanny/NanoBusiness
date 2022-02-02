//
//  GameScene.swift
//  cyberunner
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
    var introNode: SKSpriteNode!
    var gameOverNode: SKSpriteNode!
    
    var lastUpdate = TimeInterval(0)
    
    var status: GameStatus = .intro
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
//        physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
//        view.showsPhysics = true
        
        createBackground()
        
        introNode = childNode(withName: "intro") as? SKSpriteNode
        gameOverNode = childNode(withName: "gameOver") as? SKSpriteNode
        gameOverNode.removeFromParent()
        
        let playerNode = self.childNode(withName: "player") as! SKSpriteNode
        player = Player(node: playerNode)
        
        let obstacleModel = childNode(withName: "obstacleGround")!
        obstacleManager = ObstacleManager(obstacleModel: obstacleModel, parent: self)
    }
    
    func getBgLoop(timeInterval: TimeInterval) -> SKAction {
        let moveLeft = SKAction.moveBy(x: -1192, y: 0, duration: timeInterval)
        let moveBack = SKAction.moveBy(x: 1192, y: 0, duration: 0)
        let sequence = SKAction.sequence([moveLeft, moveBack])
        
        return SKAction.repeatForever(sequence)
    }
    
    func createBackground() {
        bg1 = self.childNode(withName: "bg1")!
        bg2 = self.childNode(withName: "bg2")!
        bg3 = self.childNode(withName: "bg3")!
        bg4 = self.childNode(withName: "bg4")!
        bg5 = self.childNode(withName: "bg5")!
    }
    
    func startBackground() {
        bg1.run(getBgLoop(timeInterval: TimeInterval(50)))
        bg2.run(getBgLoop(timeInterval: TimeInterval(40)))
        bg3.run(getBgLoop(timeInterval: TimeInterval(30)))
        bg4.run(getBgLoop(timeInterval: TimeInterval(20)))
        bg5.run(getBgLoop(timeInterval: TimeInterval(10)))
    }
    
    func stopBackground() {
        bg1.removeAllActions()
        bg2.removeAllActions()
        bg3.removeAllActions()
        bg4.removeAllActions()
        bg5.removeAllActions()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch status {
        case .intro:
            start()
        case .playing:
            break
        case .gameOver:
            reset()
        }
    }
    
    func start() {
        player.start()
        introNode.removeFromParent()
        status = .playing
        startBackground()
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
            break
//            scrollBackground(deltaTime: deltaTime)
        case .playing:
            playingUpdate(deltaTime: deltaTime)
        case .gameOver:
            break
        }
    }
    
    func playingUpdate(deltaTime: TimeInterval) {
        obstacleManager.update(deltaTime: deltaTime)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "player" {
            playerHasContact(other: contact.bodyB.node!)
        }
        else if contact.bodyB.node?.name == "player" {
            playerHasContact(other: contact.bodyA.node!)
        }
    }
    
    func playerHasContact(other: SKNode) {
        //2 - ground
        //4 - obstaculo
        if other.physicsBody?.categoryBitMask == 2 {
            player.land()
        }
        else if other.physicsBody?.categoryBitMask == 4 {
            other.parent?.removeFromParent()
            gameOver()
        }
    }
    
    func gameOver() {
        if status == .playing {
            status = .gameOver
            player.die()
            self.addChild(gameOverNode)
            stopBackground()
        }
        
    }
    
    func reset() {
        status = .intro
        gameOverNode.removeFromParent()
        self.addChild(introNode)
        player.reset()
        obstacleManager.reset()
    }
    
    func PunchPressed() {
        print("punch")
    }
    func FootPressed() {
        print("Foot")
    }
    func UpPressed() {
        if status == .playing {
            player.jump()
        }
    }
    func DownPressed() {
        print("Down")
    }
}
