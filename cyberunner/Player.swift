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
    var status: PlayerStatus = .stopped
    
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
        status = .running
        node.physicsBody?.isDynamic = true
        animationSetup()
    }
    
    func jump() {
        if status == .jumping {
            return
        }
        
        status = .jumping
        node.removeAllActions()
        node.texture = SKTexture(imageNamed: "player4")
        node.physicsBody?.velocity.dy = jumpForce
    }
    
    func toggleCrouch() {
        if status == .crouching {
            status = .running
            node.texture = SKTexture(imageNamed: "player1")
            physicsSetup()
            animationSetup()
            return
        }
        
        status = .crouching
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 25, height: 55), center: CGPoint(x: 0, y: -15))
        node.removeAllActions()
        node.texture = SKTexture(imageNamed: "player3Down")
        var textures = [SKTexture]()
        
        textures.append(SKTexture(imageNamed: "player3Down"))
        textures.append(SKTexture(imageNamed: "player4Down"))
        textures.append(SKTexture(imageNamed: "player5Weapon"))
        
        let frames = SKAction.animate(with: textures, timePerFrame: 0.1, resize: false, restore: false)
        
        animation = SKAction.repeatForever(frames)
        
        node.run(animation)
    }
    
    func land() {
        if status == .crouching {
            return
        }
        if status == .jumping {
            node.texture = SKTexture(imageNamed: "player1")
            animationSetup()
        }
        
        status = .running
    }
    
    func die() {
        status = .dead
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 80, height: 30), center: CGPoint(x: 0, y: 0))
        node.physicsBody?.velocity.dy = jumpForce
        node.texture = SKTexture(imageNamed: "playerDead")
        node.removeAllActions()
    }
    
    func reset() {
        status = .stopped
        physicsSetup()
        node.texture = SKTexture(imageNamed: "player1")
        node.position = startPosition
        node.physicsBody?.isDynamic = false
    }
    
}

enum PlayerStatus {
    case stopped
    case running
    case jumping
    case crouching
    case dead
}
