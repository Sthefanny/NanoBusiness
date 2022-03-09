//
//  CoinManager.swift
//  cyberunner
//
//  Created by Sthefanny Gonzaga on 24/02/22.
//

import SpriteKit

class CoinManager {
    
    private var coin: SKNode
    private var parent: SKNode
    private let startPosition: CGPoint
    
    var interval = TimeInterval(5)
    private var currentTime = TimeInterval(0)
    
    init(coin: SKNode, parent: SKNode) {
        self.coin = coin
        self.parent = parent
        startPosition = coin.position
        resetCoinPosition()
        currentTime = interval
    }
    
    func update(deltaTime: TimeInterval) {
        currentTime += deltaTime
        if currentTime >= interval {
            currentTime -= interval
        }
        
        coin.position.x -= GameManager.speed * deltaTime
        
        if coin.position.x <= -596 {
            resetCoinPosition()
        }
        
        interval -= GameManager.obstacleUpdater
    }
    
    func updateVerticalPosition() {
        let verticalPositions = [CGFloat(-30), CGFloat(0), CGFloat(50), CGFloat(90)]
        coin.position.y = verticalPositions.randomElement()!
        print("coin position y = \(coin.position.y)")
    }
    
    func spawn() {
        let new = coin.copy() as! SKNode
        parent.addChild(new)
        animate()
    }
    
    func reset() {
        resetCoinPosition()
        currentTime = interval
    }
    
    func animate() {
        var textures = [SKTexture]()
        
        textures.append(SKTexture(imageNamed: "coin1"))
        textures.append(SKTexture(imageNamed: "coin2"))
        textures.append(SKTexture(imageNamed: "coin3"))
        textures.append(SKTexture(imageNamed: "coin2"))
        
        let frames = SKAction.animate(with: textures, timePerFrame: 0.1, resize: false, restore: false)
        
        let animation = SKAction.repeatForever(frames)
        
        coin.run(animation)
    }
    
    func pickCoin() {
        coin.removeAllActions()
        coin.physicsBody?.velocity.dy = CGFloat(400)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.resetCoinPosition()
        }
    }
    
    func resetCoinPosition() {
        coin.position = startPosition
        coin.physicsBody?.velocity.dy = CGFloat(0)
        updateVerticalPosition()
    }
}
