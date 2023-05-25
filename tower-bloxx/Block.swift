//
//  Block.swift
//  tower-bloxx
//
//  Created by Kezia Gloria on 22/05/23.
//

import SpriteKit

class Block: SKSpriteNode {
    let index: Int
    let isBase: Bool
    let pos : CGPoint
    let blockSize : Int
    
    init(index: Int, isBase: Bool, pos: CGPoint, blockSize: Int) {
        self.index = index
        self.isBase = isBase
        self.pos = pos
        self.blockSize = blockSize
        
        let imageName = isBase ? "base" : "block"
        let texture = SKTexture(imageNamed: imageName)
        let size = CGSize(width: blockSize, height: blockSize)
        
        super.init(texture: texture, color: .clear, size: size)
        
        self.position = pos
        self.zRotation = 0
        
        self.physicsBody = SKPhysicsBody(rectangleOf: self.frame.size)
        self.physicsBody?.mass = 0.2
        self.physicsBody?.restitution = 0.2
        self.physicsBody?.categoryBitMask = PhysicsCategory.block
        self.physicsBody?.collisionBitMask = PhysicsCategory.block | PhysicsCategory.ground
        self.physicsBody?.contactTestBitMask = PhysicsCategory.ground | PhysicsCategory.block
        self.physicsBody?.friction = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

