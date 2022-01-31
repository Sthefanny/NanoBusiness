//
//  Background.swift
//  cyberunner
//
//  Created by Sthefanny Gonzaga on 27/01/22.
//

import Foundation
import SpriteKit

class Background {
    
    var node: SKNode
    
    init(node: SKNode) {
        self.node = node
    }
    
    func update(sizeWidth: CGFloat, deltaTime: TimeInterval) {
        
        let moveLeft = SKAction.moveBy(x: -sizeWidth, y: 0, duration: deltaTime)
        let moveBack = SKAction.moveBy(x: sizeWidth, y: 0, duration: 0)
        let sequence = SKAction.sequence([moveLeft, moveBack])
        
        let loop = SKAction.repeatForever(sequence)
        
        node.run(loop)
        
        
//        var count = 0
//        var aditional = CGFloat(10)
//
//        for node in bgNodes {
//            node.position.x -= GameManager.bgSpeed + aditional * deltaTime
//
//            if node.position.x <= 0 {
//                node.position.x += 24
//            }
//
//            count += 1
//            aditional += CGFloat(10)
//        }
        
//        node.position.x -= GameManager.bgSpeed * deltaTime
//
//        if node.position.x <= 0 {
//            node.position.x += 1334
//        }
    }
    
}
