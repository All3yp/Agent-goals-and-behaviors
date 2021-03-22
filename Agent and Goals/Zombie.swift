//
//  Zombie.swift
//  Agent and Goals
//
//  Created by Alley Pereira on 20/03/21.
//

import Foundation
import GameplayKit

class Zombie: GKEntity {

    override init() {
        super.init()

        self.addComponent(AnimatedSpriteComponent(atlasName: "WalkZombie"))

        self.component(ofType: AnimatedSpriteComponent.self)?.spriteNode.makePhysicsBody(bitMask: 3, collision: 1, widthMultiplier: 0.6, heightMultiplier: 0.85)
        self.component(ofType: AnimatedSpriteComponent.self)?.spriteNode.anchorPoint = CGPoint(x: 0.5, y: 0.45)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
