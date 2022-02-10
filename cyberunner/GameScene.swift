//
//  GameScene.swift
//  cyberunner
//
//  Created by Sthefanny Gonzaga on 27/01/22.
//

import SpriteKit
import GameplayKit
import FirebaseAnalytics

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: Player!
    var obstacleManager: ObstacleManager!
    var background: Background!
    
    var lastUpdate = TimeInterval(0)
    var totalTime = TimeInterval(0)
    
    var status: GameStatus = .intro
    weak var gameViewController: GameViewController!
    
    var audioPlayer = AudioManager.instance
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
//        physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
//        view.showsPhysics = true
        
        audioPlayer.playBackgroundSound(sound: .backgroundSoundLoop)
        
        let playerNode = self.childNode(withName: "player") as! SKSpriteNode
        player = Player(node: playerNode, scene: self)
        
        background = Background(parent: self)
        
        let obstacleGround = childNode(withName: "obstacleGround")!
        let obstacleCeiling = childNode(withName: "obstacleCeiling")!
        let obstacleWall = childNode(withName: "obstacleWall")!
        let obstacleRat = childNode(withName: "obstacleRat")!
        obstacleManager = ObstacleManager(obstacleGround: obstacleGround, obstacleCeiling: obstacleCeiling, obstacleWall: obstacleWall, obstacleRat: obstacleRat, parent: self)
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
    
    func start() {
        gameViewController.hideIntroView()
        gameViewController.showGameSettings()
        player.start()
        status = .playing
        Analytics.logEvent("level_start", parameters: nil)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if lastUpdate == 0 {
            lastUpdate = currentTime
            return
        }
        
        var deltaTime = currentTime - lastUpdate
        deltaTime = min(deltaTime, 0.1)
        
        lastUpdate = currentTime
        
        totalTime += deltaTime
        
        switch status {
        case .intro:
            GameManager.speed = CGFloat(100)
            obstacleManager.interval = TimeInterval(6)
        case .playing:
            playingUpdate(deltaTime: deltaTime)
        case .gameOver:
            gameViewController.updateScore()
        }
    }
    
    func playingUpdate(deltaTime: TimeInterval) {
        GameManager.speed += GameManager.speedUpdater
        player.update()
        obstacleManager.update(deltaTime: deltaTime)
        gameViewController.setScore(deltaTime: deltaTime)
        background.update(deltaTime: deltaTime)
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
                obstacleManager.breakWall(wall: other as! SKSpriteNode)
                obstacleManager.obstacleStatus = .inactive
            }
            else if obstacleManager.obstacleStatus == .active {
                gameOver()
            }
        case "rat":
            if player.status == .kicking {
                obstacleManager.killRat(rat: other as! SKSpriteNode)
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
            Analytics.logEvent("level_end", parameters: nil)
            
            Analytics.setUserProperty("\(round(totalTime))", forName: "last_run_time")
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
            gameViewController.resetScore()
            Analytics.logEvent("level_restart", parameters: nil)
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
            
            audioPlayer.playSound(sound: .jump)
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
