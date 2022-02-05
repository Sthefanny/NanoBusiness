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
    
    var lastUpdate = TimeInterval(0)
    
    var status: GameStatus = .intro
    weak var gameViewController: GameViewController!
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
//        physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
//        view.showsPhysics = true
        
        createBackground()
        
        let playerNode = self.childNode(withName: "player") as! SKSpriteNode
        player = Player(node: playerNode, scene: self)
        
        let obstacleGround = childNode(withName: "obstacleGround")!
        let obstacleCeiling = childNode(withName: "obstacleCeiling")!
        let obstacleWall = childNode(withName: "obstacleWall")!
        let obstacleRat = childNode(withName: "obstacleRat")!
        obstacleManager = ObstacleManager(obstacleGround: obstacleGround, obstacleCeiling: obstacleCeiling, obstacleWall: obstacleWall, obstacleRat: obstacleRat, parent: self)
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
    
    func resetBackgroundPosition() {
        let resetPosition = SKAction.moveTo(x: 0, duration: 0)
        bg1.run(resetPosition)
        bg2.run(resetPosition)
        bg3.run(resetPosition)
        bg4.run(resetPosition)
        bg5.run(resetPosition)
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
            break
        case .playing:
            break
        case .gameOver:
            reset()
        }
    }
    
    func start() {
        gameViewController.hideIntroView()
        gameViewController.showGameSettings()
        player.start()
        status = .playing
        createBackground()
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
            gameViewController.updateScore()
        }
    }
    
    func playingUpdate(deltaTime: TimeInterval) {
        player.update()
        obstacleManager.update(deltaTime: deltaTime)
        gameViewController.setScore(deltaTime: deltaTime)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if status == .playing {
            if contact.bodyA.node?.name == "player" {
                playerHasContact(other: contact.bodyB.node!)
            }
            else if contact.bodyB.node?.name == "player" {
                playerHasContact(other: contact.bodyA.node!)
            }
        }
    }
    
    func playerHasContact(other: SKNode) {
        //2 - ground
        //4 - obstaculo
        let obstacleName = other.physicsBody?.node?.userData?["obstacleName"] as! String
        
        switch obstacleName {
        case "ground":
            player.land()
            gameViewController.setButton(button: .up, status: .untap)
        case "platform":
            other.parent?.removeFromParent()
            gameOver()
        case "platformLand":
            player.land()
            resetAllButton()
        case "ceiling":
            gameOver()
        case "wall":
            if player.status == .punching {
                obstacleManager.breakWall()
                obstacleManager.obstacleStatus = .inactive
            }
            else if obstacleManager.obstacleStatus == .active {
                gameOver()
            }
        case "rat":
            if player.status == .kicking {
                obstacleManager.killRat()
                obstacleManager.obstacleStatus = .inactive
            }
            else if obstacleManager.obstacleStatus == .active {
                gameOver()
            }
        default:
            player.land()
            gameViewController.setButton(button: .up, status: .untap)
        }
    }
    
    func gameOver() {
        if status == .playing {
            status = .gameOver
            player.die()
            gameViewController.showEndView()
            stopBackground()
        }
        
    }
    
    func reset() {
        if player.status == .dead {
            gameViewController.hideGameSettings()
            status = .intro
            gameViewController.hideEndView()
            gameViewController.showIntroView()
            player.reset()
            obstacleManager.reset()
            resetAllButton()
            resetBackgroundPosition()
            gameViewController.resetScore()
        }
    }
    
    func resetAllButton() {
        gameViewController.setButton(button: .up, status: .untap)
        gameViewController.setButton(button: .down, status: .untap)
        gameViewController.setButton(button: .punch, status: .untap)
        gameViewController.setButton(button: .kick, status: .untap)
    }
    
    func PunchPressed() {
        if status == .playing && player.status == .running {
            gameViewController.setButton(button: .punch, status: .tap)
            player.punch()
        }
    }
    func KickPressed() {
        if status == .playing && player.status == .running {
            gameViewController.setButton(button: .kick, status: .tap)
            player.kick()
        }
    }
    func UpPressed() {
        if status == .playing && player.status == .running {
            gameViewController.setButton(button: .up, status: .tap)
            player.jump()
        }
    }
    func DownPressed() {
        if status == .playing && player.status == .running || player.status == .crouching {
            gameViewController.setButton(button: .down, status: player.status == .crouching ? .untap : .tap)
            player.toggleCrouch()
        }
    }
}
