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
    private var parent: SKNode
    
    private let interval = TimeInterval(5)
    private var currentTime = TimeInterval(0)
    
    private var obstacles = [SKNode]()
    
    init(obstacleGround: SKNode, obstacleCeiling: SKNode, parent: SKNode) {
        self.obstacleGround = obstacleGround
        self.obstacleCeiling = obstacleCeiling
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
        let obstacleOptions = [obstacleGround, obstacleCeiling]
        let new = obstacleOptions.randomElement()?.copy() as! SKNode
        parent.addChild(new)
        obstacles.append(new)
    }
    
    func reset() {
        for obstacle in obstacles {
            obstacle.removeFromParent()
        }
        obstacles.removeAll()
        currentTime = interval
    }
    
}

enum Obstacles {
    case ground
    case platform
    case ceiling
    case wall
    case rat
}
