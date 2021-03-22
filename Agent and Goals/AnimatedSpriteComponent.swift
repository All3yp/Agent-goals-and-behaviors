//
//  AnimatedSpriteComponent.swift
//  Agent and Goals
//
//  Created by Alley Pereira on 20/03/21.
//

import Foundation
import GameplayKit
import SpriteKit

class AnimatedSpriteComponent: GKComponent {

    var spriteNode: SKSpriteNode!

    var animationAtlas: SKTextureAtlas?
    var animationTextures: [SKTexture] {
        animationAtlas?.textureNames.compactMap { textureName in animationAtlas?.textureNamed(textureName) } ?? []
    }

    init(textureName: String) {
        super.init()
        self.spriteNode = SKSpriteNode(imageNamed: textureName)
    }

    init(atlasName: String) {
        super.init()

        self.animationAtlas = SKTextureAtlas(named: atlasName)
        self.spriteNode = SKSpriteNode(imageNamed: animationAtlas!.textureNames.first!)
        self.spriteNode.texture = animationTextures.first!
        setAnimation(atlasName: atlasName)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setAnimation(atlasName: String) {
        spriteNode.removeAllActions()

        self.animationAtlas = SKTextureAtlas(named: atlasName)
        self.spriteNode.texture = animationTextures.first!

        spriteNode.run(
            SKAction.repeatForever(
                SKAction.animate(
                    with: animationTextures,
                    timePerFrame: 0.1,
                    resize: false,
                    restore: true
                )
            ),
            withKey: atlasName
        )
    }

    func turnSpriteAccordingTo(rotation: Float) {
        let angleInDegrees = fmodf(360.0 + rotation * (180.0 / .pi), 360.0)
        switch angleInDegrees {
        case 90...270:
            self.spriteNode.xScale = -1
        default:
            self.spriteNode.xScale = 1
        }
    }
}

