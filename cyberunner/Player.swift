//
//  Player.swift
//  cyberunner
//
//  Created by Sthefanny Gonzaga on 28/01/22.
//

import Foundation
import SpriteKit

class Player {
    
    private var node: SKSpriteNode
    private let jumpForce = CGFloat(500)
    private let startPosition: CGPoint
    private var animation: SKAction!
    private var jumping: Bool = false
    
    init(node: SKSpriteNode) {
        self.node = node
        startPosition = node.position
        physicsSetup()
    }
    
    func physicsSetup() {
        let body = SKPhysicsBody(rectangleOf: CGSize(width: 25, height: 77), center: CGPoint(x: 0, y: -3))
        body.isDynamic = true
        body.affectedByGravity = true
        body.allowsRotation = false
        body.categoryBitMask = 1
        body.collisionBitMask = 2
        body.contactTestBitMask = 6
        body.restitution = 0
        
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
        if jumping {
            return
        }
        
        jumping = true
        node.removeAllActions()
        node.texture = SKTexture(imageNamed: "player4")
        node.physicsBody?.velocity.dy = jumpForce
    }
    
    func land() {
        if jumping {
            node.texture = SKTexture(imageNamed: "player1")
            animationSetup()
        }
        
        jumping = false
    }
    
    func die() {
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 80, height: 30), center: CGPoint(x: 0, y: 0))
        node.physicsBody?.velocity.dy = jumpForce
        node.texture = SKTexture(imageNamed: "playerDead")
        node.removeAllActions()
    }
    
    func reset() {
        physicsSetup()
        node.texture = SKTexture(imageNamed: "player1")
        node.position = startPosition
        node.physicsBody?.isDynamic = false
    }
    
}
