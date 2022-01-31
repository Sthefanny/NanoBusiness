//
//  Player.swift
//  NanoBusiness
//
//  Created by Sthefanny Gonzaga on 28/01/22.
//

import Foundation
import SpriteKit

class Player {
    
    private var node: SKSpriteNode
    private let jumpForce = CGFloat(800)
    private let startPosition: CGPoint
    private var animation: SKAction!
    
    init(node: SKSpriteNode) {
        self.node = node
        startPosition = node.position
        physicsSetup()
    }
    
    func physicsSetup() {
        let body = SKPhysicsBody(rectangleOf: CGSize(width: 52, height: 142), center: CGPoint(x: 0, y: -8))
        body.isDynamic = true
        body.affectedByGravity = true
        body.allowsRotation = false
        body.categoryBitMask = 1
        body.collisionBitMask = 2
        body.contactTestBitMask = 4
        
        node.physicsBody = body
    }
    
    func animationSetup() {
        var textures = [SKTexture]()
        
        textures.append(SKTexture(imageNamed: "player1"))
        textures.append(SKTexture(imageNamed: "player2"))
        textures.append(SKTexture(imageNamed: "player3"))
        textures.append(SKTexture(imageNamed: "player4"))
        textures.append(SKTexture(imageNamed: "player5"))
        textures.append(SKTexture(imageNamed: "player6"))
        
        let frames = SKAction.animate(with: textures, timePerFrame: 0.1, resize: false, restore: false)
        
        animation = SKAction.repeatForever(frames)
        
        node.run(animation)
    }
    
    func start() {
        node.physicsBody?.isDynamic = true
        animationSetup()
    }
    
    func jump() {
        node.physicsBody?.velocity.dy = jumpForce
    }
    
    func die() {
        node.yScale = -1
        jump()
        node.removeAllActions()
    }
    
    func reset() {
        node.yScale = 1
        node.position = startPosition
        node.physicsBody?.isDynamic = false
    }
    
}
