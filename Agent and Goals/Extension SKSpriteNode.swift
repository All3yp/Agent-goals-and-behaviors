//
//  Extension SKSpriteNode.swift
//  Agent and Goals
//
//  Created by Alley Pereira on 20/03/21.
//

import SpriteKit

extension SKSpriteNode {

    func makePhysicsBody(bitMask: UInt32, collision: UInt32,
                         customSize size: CGSize? = nil,
                         byTexture: Bool = false,
                         gravity: Bool = true,
                         dynamic: Bool = true,
                         rotation: Bool = false,
                         widthMultiplier: CGFloat = 1,
                         heightMultiplier: CGFloat = 1) {

        var physicsBody: SKPhysicsBody
        var bodySize: CGSize

        if let size = size {
            bodySize = size
        } else if let texture = texture {
            bodySize = texture.size()
        } else {
            bodySize = self.frame.size
        }

        bodySize.width *= widthMultiplier
        bodySize.height *= heightMultiplier

        if byTexture, let texture = self.texture {
            physicsBody = SKPhysicsBody(texture: texture, size: bodySize)
        } else {
            physicsBody = SKPhysicsBody(rectangleOf: bodySize)
        }

        physicsBody.collisionBitMask = bitMask
        physicsBody.contactTestBitMask = collision
        physicsBody.categoryBitMask = collision

        physicsBody.affectedByGravity = gravity
        physicsBody.isDynamic = dynamic
        physicsBody.allowsRotation = rotation

        self.physicsBody = physicsBody
    }

}
