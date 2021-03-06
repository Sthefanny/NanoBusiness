//
//  Player.swift
//  cyberunner
//
//  Created by Sthefanny Gonzaga on 28/01/22.
//

import Foundation
import SpriteKit
import FirebaseAnalytics

class Player {
    
    private var node: SKSpriteNode
    private let jumpForce = CGFloat(500)
    private let startPosition: CGPoint
    private var animation: SKAction!
    var status: PlayerStatus = .stopped
    var scene: GameScene!
    private var character: String!
    
    init(node: SKSpriteNode, scene: GameScene) {
        self.node = node
        self.scene = scene
        startPosition = node.position
        physicsSetup()
        character = UserData().getCharacter()
    }
    
    func physicsSetup() {
        let body = SKPhysicsBody(rectangleOf: CGSize(width: 25, height: 77), center: CGPoint(x: 0, y: -3))
        body.isDynamic = true
        body.affectedByGravity = true
        body.allowsRotation = false
        body.categoryBitMask = 1
        body.collisionBitMask = 2
        body.contactTestBitMask = 14
        body.restitution = 0
        
        node.physicsBody = body
        node.yScale = 1
    }
    
    func animationSetup() {
        var textures = [SKTexture]()
        
        textures.append(SKTexture(imageNamed: self.character + "1"))
        textures.append(SKTexture(imageNamed: self.character + "2"))
        textures.append(SKTexture(imageNamed: self.character + "3"))
        textures.append(SKTexture(imageNamed: self.character + "4"))
        textures.append(SKTexture(imageNamed: self.character + "5"))
        textures.append(SKTexture(imageNamed: self.character + "6"))
        
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
        node.texture = SKTexture(imageNamed: self.character + "1")
        node.position = startPosition
        node.physicsBody?.isDynamic = false
    }
    
    func jump() {
        if status == .jumping || status == .crouching {
            return
        }
        
        status = .jumping
        node.removeAllActions()
        node.texture = SKTexture(imageNamed: self.character + "4")
        node.physicsBody?.velocity.dy = jumpForce
        
        Analytics.logEvent("player_jump", parameters: ["player_height": round(node.position.y) as NSNumber])
    }
    
    func toggleCrouch() {
        if status == .crouching {
            status = .running
            node.texture = SKTexture(imageNamed: self.character + "1")
            physicsSetup()
            animationSetup()
            return
        }
        
        status = .crouching
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 25, height: 55), center: CGPoint(x: 0, y: -15))
        node.removeAllActions()
        node.texture = SKTexture(imageNamed: self.character + "3Down")
        var textures = [SKTexture]()
        
        textures.append(SKTexture(imageNamed: self.character + "3Down"))
        textures.append(SKTexture(imageNamed: self.character + "4Down"))
        textures.append(SKTexture(imageNamed: self.character + "5Down"))
        
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
        node.texture = SKTexture(imageNamed: self.character + "3Punch")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.scene.status == .playing {
                self.physicsSetup()
                self.node.texture = SKTexture(imageNamed: self.character + "1")
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
        node.texture = SKTexture(imageNamed: self.character + "2Kick")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.scene.status == .playing {
                self.physicsSetup()
                self.node.texture = SKTexture(imageNamed: self.character + "1")
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
        
        node.texture = SKTexture(imageNamed: self.character + "1")
        animationSetup()
        
        status = .running
    }
    
    func die() {
        status = .dead
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 80, height: 30), center: CGPoint(x: 0, y: 0))
        node.physicsBody?.velocity.dy = jumpForce
        node.texture = SKTexture(imageNamed: self.character + "Dead")
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
