//
//  ObstacleManager.swift
//  NanoBusiness
//
//  Created by Sthefanny Gonzaga on 28/01/22.
//

import SpriteKit

class ObstacleManager {
    
    private var obstacleModel: SKNode
    private var parent: SKNode
    
    private let interval = TimeInterval(10)
    private var currentTime = TimeInterval(0)
    
    private var obstacles = [SKNode]()
    
    init(obstacleModel: SKNode, parent: SKNode) {
        self.obstacleModel = obstacleModel
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
        
        if let firstPipe = obstacles.first {
            if firstPipe.position.x <= -180 {
                firstPipe.removeFromParent()
                obstacles.removeFirst()
            }
        }
    }
    
    func spawn() {
        let new = obstacleModel.copy() as! SKNode
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
