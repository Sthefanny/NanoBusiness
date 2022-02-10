//
//  ObstacleManager.swift
//  cyberunner
//
//  Created by Sthefanny Gonzaga on 28/01/22.
//

import SpriteKit

class ObstacleManager {
    
    private var obstacleGround: SKNode
    private var obstacleCeiling: SKNode
    private var obstacleWall: SKNode
    private var obstacleRat: SKNode
    private var parent: SKNode
    
    var interval = TimeInterval(6)
    private var currentTime = TimeInterval(0)
    
    private var obstacles = [SKNode]()
    var obstacleStatus: ObstacleStatus = .active
    private var ratAnimationList = [SKAction]()
    
    private var audioPlayer = AudioManager.instance
    
    init(obstacleGround: SKNode, obstacleCeiling: SKNode, obstacleWall: SKNode, obstacleRat: SKNode, parent: SKNode) {
        self.obstacleGround = obstacleGround
        self.obstacleCeiling = obstacleCeiling
        self.obstacleWall = obstacleWall
        self.obstacleRat = obstacleRat
        self.parent = parent
        currentTime = interval
    }
    
    func update(deltaTime: TimeInterval) {
        currentTime += deltaTime
        if currentTime >= interval {
            spawn()
            currentTime -= interval
        }
        
        for obstacle in obstacles {
            obstacle.position.x -= GameManager.speed * deltaTime
        }
        
        if let firstObstacle = obstacles.first {
            if firstObstacle.position.x <= -596 {
                firstObstacle.removeFromParent()
                obstacles.removeFirst()
            }
        }
        interval -= GameManager.obstacleUpdater
    }
    
    func spawn() {
        let obstacleOptions = [obstacleGround, obstacleCeiling, obstacleWall, obstacleRat]
        let new = obstacleOptions.randomElement()?.copy() as! SKNode
        parent.addChild(new)
        obstacles.append(new)
        obstacleStatus = .active
        if new.isEqual(to: obstacleRat) {
            animateRat(ratNode: new)
        }
    }
    
    func reset() {
        for obstacle in obstacles {
            obstacle.removeFromParent()
        }
        obstacles.removeAll()
        currentTime = interval
    }
    
    func animateRat(ratNode: SKNode) {
        audioPlayer.playSound(sound: .rat)
        
        var walking = [SKTexture]()
        
        walking.append(SKTexture(imageNamed: "rat1"))
        walking.append(SKTexture(imageNamed: "rat2"))
        
        let frames = SKAction.animate(with: walking, timePerFrame: 0.05, resize: false, restore: false)
        let repeatFrames = SKAction.repeat(frames, count: Int(0.5 / 0.05))
        let rightMove = SKAction.moveBy(x: 50, y: 0, duration: 0.5)
        let rightGroup = SKAction.group([repeatFrames, rightMove])
        
        ratAnimationList.append(rightGroup)
        
        var walkingLeft = [SKTexture]()
        
        walkingLeft.append(SKTexture(imageNamed: "ratLeft1"))
        walkingLeft.append(SKTexture(imageNamed: "ratLeft2"))
        
        let framesLeft = SKAction.animate(with: walkingLeft, timePerFrame: 0.05, resize: false, restore: false)
        let repeatFramesLeft = SKAction.repeat(framesLeft, count: Int(0.5 / 0.05))
        let leftMove = SKAction.moveBy(x: -50, y: 0, duration: 0.5)
        let leftGroup = SKAction.group([repeatFramesLeft, leftMove])
        
        ratAnimationList.append(leftGroup)
        
        
        let stopped = SKTexture(imageNamed: "ratFront")
        let stoppedAction = SKAction.setTexture(stopped)
        let wait = SKAction.wait(forDuration: 0.5)
        let stoppedGroup = SKAction.group([stoppedAction, wait])
        ratAnimationList.append(stoppedGroup)
        
        startRatAnimation(ratNode: ratNode.childNode(withName: "rat")!)
    }
    
    func startRatAnimation(ratNode: SKNode) {
        ratNode.removeAllActions()
        ratNode.run(ratAnimationList.randomElement()!) {
            self.startRatAnimation(ratNode: ratNode)
        }
    }
    
    func killRat(rat: SKSpriteNode) {
        
        audioPlayer.playSound(sound: .punchRat)
        
        rat.removeAllActions()
        rat.texture = SKTexture(imageNamed: "ratDead")
        rat.physicsBody?.velocity.dy = CGFloat(400)
        rat.physicsBody?.contactTestBitMask = 0
        rat.physicsBody?.categoryBitMask = 0
        rat.physicsBody?.collisionBitMask = 2
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            rat.removeFromParent()
        }
    }
    
    func breakWall(wall: SKSpriteNode) {
        
        audioPlayer.playSound(sound: .punchWall)
        
        wall.physicsBody = nil
        
        var textures = [SKTexture]()
        
        textures.append(SKTexture(imageNamed: "wallbreak1"))
        textures.append(SKTexture(imageNamed: "wallbreak2"))
        textures.append(SKTexture(imageNamed: "wallbreak3"))
        
        let frames = SKAction.animate(with: textures, timePerFrame: 0.1, resize: false, restore: false)
        
        let animation = SKAction.repeat(frames, count: 1)
        
        wall.run(animation)
    }
    
}

enum Obstacles {
    case ground
    case platform
    case ceiling
    case wall
    case rat
}


enum ObstacleStatus {
    case active
    case inactive
}
