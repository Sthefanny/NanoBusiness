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
    var scene: GameScene!
    
    init(node: SKSpriteNode, scene: GameScene) {
        self.node = node
        self.scene = scene
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
        node.yScale = 1
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
    
    func reset() {
        status = .stopped
        physicsSetup()
        node.texture = SKTexture(imageNamed: "player1")
        node.position = startPosition
        node.physicsBody?.isDynamic = false
    }
    
    func jump() {
        if status == .jumping || status == .crouching {
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
    
    func punch() {
        if status == .punching {
            return
        }
        
        status = .punching
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 77), center: CGPoint(x: 0, y: -3))
        node.removeAllActions()
        node.texture = SKTexture(imageNamed: "player3Punch")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.scene.status == .playing {
                self.physicsSetup()
                self.node.texture = SKTexture(imageNamed: "player1")
                self.animationSetup()
                self.status = .running
                self.scene.resetAllButton()
            }
        }
    }
    
    func kick() {
        if status == .kicking {
            return
        }
        
        status = .kicking
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 77), center: CGPoint(x: 0, y: -3))
        node.removeAllActions()
        node.texture = SKTexture(imageNamed: "player2Kick")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.scene.status == .playing {
                self.physicsSetup()
                self.node.texture = SKTexture(imageNamed: "player1")
                self.animationSetup()
                self.status = .running
                self.scene.resetAllButton()
            }
        }
    }
    
    func land() {
        if status == .crouching || status == .punching || status == .kicking {
            return
        }
        
        node.texture = SKTexture(imageNamed: "player1")
        animationSetup()
        
        status = .running
    }
    
    func die() {
        status = .dead
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 80, height: 30), center: CGPoint(x: 0, y: 0))
        node.physicsBody?.velocity.dy = jumpForce
        node.texture = SKTexture(imageNamed: "playerDead")
        node.removeAllActions()
    }
    
    func update() {
        node.zRotation = 0
    }
    
}

enum PlayerStatus {
    case stopped
    case running
    case jumping
    case punching
    case kicking
    case crouching
    case dead
}
