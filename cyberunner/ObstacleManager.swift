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
    private var parent: SKNode
    
    private let interval = TimeInterval(5)
    private var currentTime = TimeInterval(0)
    
    private var obstacles = [SKNode]()
    var obstacleStatus: ObstacleStatus = .active
    
    init(obstacleGround: SKNode, obstacleCeiling: SKNode, obstacleWall: SKNode, parent: SKNode) {
        self.obstacleGround = obstacleGround
        self.obstacleCeiling = obstacleCeiling
        self.obstacleWall = obstacleWall
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
            obstacle.position.x -= GameManager.obstacleSpeed * deltaTime
        }
        
        if let firstObstacle = obstacles.first {
            if firstObstacle.position.x <= -596 {
                firstObstacle.removeFromParent()
                obstacles.removeFirst()
            }
        }
    }
    
    func spawn() {
        let obstacleOptions = [obstacleGround, obstacleCeiling, obstacleWall]
        let new = obstacleOptions.randomElement()?.copy() as! SKNode
        parent.addChild(new)
        obstacles.append(new)
        obstacleStatus = .active
    }
    
    func reset() {
        for obstacle in obstacles {
            obstacle.removeFromParent()
        }
        obstacles.removeAll()
        currentTime = interval
    }
    
    func breakWall() {
        
        obstacles.first?.physicsBody?.categoryBitMask = 0
        
        var textures = [SKTexture]()
        
        textures.append(SKTexture(imageNamed: "wallbreak1"))
        textures.append(SKTexture(imageNamed: "wallbreak2"))
        textures.append(SKTexture(imageNamed: "wallbreak3"))
        
        let frames = SKAction.animate(with: textures, timePerFrame: 0.1, resize: false, restore: false)
        
        let animation = SKAction.repeat(frames, count: 1)
        
        obstacles.first?.run(animation)
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
