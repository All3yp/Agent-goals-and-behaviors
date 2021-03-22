//
//  ZombieScene.swift
//  Agent and Goals
//
//  Created by Alley Pereira on 20/03/21.
//

import Foundation
import SpriteKit
import GameplayKit

class ZombieScene: SKScene {

    lazy var sceneCamera: SKCameraNode = {
        let camera = SKCameraNode()
        camera.setScale(4)
        return camera
    }()
    private var lastUpdateTime: TimeInterval = 0

    private let zombie: Zombie = Zombie()
    private var zombieSpriteNode: SKSpriteNode {
        zombie.component(ofType: AnimatedSpriteComponent.self)!.spriteNode
    }

    //private var zombieCircleShape: SKShapeNode!

    //Agents
    let zombieAgent: GKAgent2D = GKAgent2D()
    let brain1Agent: GKAgent2D = GKAgent2D()
    let brain2Agent: GKAgent2D = GKAgent2D()

    override func didMove(to view: SKView) {
        super.didMove(to: view)

        self.backgroundColor = .darkGray

        //Camera
        self.camera = sceneCamera

        //Add Zombie on Scene
        zombieSpriteNode.position = CGPoint(x: self.position.x, y: self.position.y + 1200)
        zombieSpriteNode.zPosition = 5
        self.addChild(zombieSpriteNode)

        //Add Obstacles and Brains on Scene
        generateBrains()
        let obstacles = generateObstacles()

        //Agent
        let radius = zombieSpriteNode.texture!.size().height/2
        zombieAgent.radius = Float(radius)
        zombieAgent.position = vector_float2(x: Float(zombieSpriteNode.position.x), y: Float(zombieSpriteNode.position.y))
        zombieAgent.delegate = self
        zombieAgent.maxSpeed = 100
        zombieAgent.maxAcceleration = 50

        //Goals
        let seekGoal = GKGoal(toSeekAgent: brain1Agent)
        let avoidGoal = GKGoal(toAvoid: obstacles, maxPredictionTime: 3)

        let behavior = GKBehavior(weightedGoals: [
            seekGoal: 1,
            avoidGoal: 100
        ])
        zombieAgent.behavior = behavior

        // A circle to represent the agent's radius in the agent simulation.
        /*
        zombieCircleShape = SKShapeNode(circleOfRadius: radius)
        zombieCircleShape.lineWidth = 2.5
        zombieCircleShape.fillColor = UIColor.gray.withAlphaComponent(0.5)
        addChild(zombieCircleShape)
        */
    }

    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)

        if lastUpdateTime == 0 {
          lastUpdateTime = currentTime
        }
        let delta: Double = currentTime - lastUpdateTime
        lastUpdateTime = currentTime

        zombieAgent.update(deltaTime: delta)

        let angleInDegrees = fmodf(360.0 + zombieAgent.rotation * (180.0 / .pi), 360.0);
        switch angleInDegrees {
        case 0...90:
            zombieSpriteNode.xScale = 1
        case 270...360:
            zombieSpriteNode.xScale = 1
        case 90...270:
            zombieSpriteNode.xScale = -1
        default:
            zombieSpriteNode.xScale = 1
        }
    }

    func generateObstacles() -> [GKObstacle] {
        let obstacleColor: UIColor = .systemGray

        let obstacle1 = SKSpriteNode(color: obstacleColor, size: CGSize(width: 200, height: 200))
        obstacle1.position = CGPoint(x: -700, y: -800)
        obstacle1.makePhysicsBody(bitMask: 1, collision: 3, dynamic: false)
        self.addChild(obstacle1)

        let obstacle2 = SKSpriteNode(color: obstacleColor, size: CGSize(width: 200, height: 200))
        obstacle2.position = CGPoint(x: -700, y: 0)
        obstacle2.makePhysicsBody(bitMask: 1, collision: 3, dynamic: false)
        self.addChild(obstacle2)

        let obstacle3 = SKSpriteNode(color: obstacleColor, size: CGSize(width: 200, height: 200))
        obstacle3.position = CGPoint(x: 0, y: 600)
        obstacle3.makePhysicsBody(bitMask: 1, collision: 3, dynamic: false)
        self.addChild(obstacle3)

        let obstacle4 = SKSpriteNode(color: obstacleColor, size: CGSize(width: 200, height: 200))
        obstacle4.position = CGPoint(x: 700, y: -200)
        obstacle4.makePhysicsBody(bitMask: 1, collision: 3, dynamic: false)
        self.addChild(obstacle4)

        let obstacle5 = SKSpriteNode(color: obstacleColor, size: CGSize(width: 200, height: 200))
        obstacle5.position = CGPoint(x: 200, y: -800)
        obstacle5.makePhysicsBody(bitMask: 1, collision: 3, dynamic: false)
        self.addChild(obstacle5)

        let obstacles: [SKSpriteNode] = [obstacle1, obstacle2, obstacle3, obstacle4, obstacle5]

        return obstacles.map {
            let radius = ($0.frame.width/2)+200

            // A circle to represent the agent's radius in the agent simulation.
            /*
            let circleShape = SKShapeNode(circleOfRadius: radius)
            circleShape.lineWidth = 2.5
            circleShape.fillColor = UIColor.white.withAlphaComponent(0.5)
            circleShape.position = $0.position
            addChild(circleShape)
            */

            let gkObstacle = GKCircleObstacle(radius: Float(radius))
            gkObstacle.position = vector_float2(x: Float($0.position.x), y: Float($0.position.y))
            return gkObstacle
        }
    }

    func generateBrains() {
        let brainColor: UIColor = UIColor.systemPink.withAlphaComponent(0.8)

        let brain1 = SKSpriteNode(color: brainColor, size: CGSize(width: 100, height: 100))
        brain1.position = CGPoint(x: 200, y: -1000)
        self.addChild(brain1)

        let brain2 = SKSpriteNode(color: brainColor, size: CGSize(width: 100, height: 100))
        brain2.position = CGPoint(x: -200, y: -200)
        self.addChild(brain2)

        let radius = brain1.frame.height/2

        brain1Agent.radius = Float(radius)
        brain1Agent.position = vector_float2(x: Float(brain1.position.x), y: Float(brain1.position.y))
        brain1Agent.delegate = self

        brain2Agent.radius = Float(radius)
        brain2Agent.position = vector_float2(x: Float(brain2.position.x), y: Float(brain2.position.y))
        brain2Agent.delegate = self

        // A circle to represent the agent's radius in the agent simulation.
        /*
        let circle1Shape = SKShapeNode(circleOfRadius: radius)
        circle1Shape.lineWidth = 2.5
        circle1Shape.fillColor = UIColor.systemPink.withAlphaComponent(0.5)
        circle1Shape.position = CGPoint(x: CGFloat(brain1Agent.position.x), y: CGFloat(brain1Agent.position.y))
        addChild(circle1Shape)

        // A circle to represent the agent's radius in the agent simulation.
        let circle2Shape = SKShapeNode(circleOfRadius: radius)
        circle2Shape.lineWidth = 2.5
        circle2Shape.fillColor = UIColor.systemPink.withAlphaComponent(0.5)
        circle2Shape.position = CGPoint(x: CGFloat(brain2Agent.position.x), y: CGFloat(brain2Agent.position.y))
        addChild(circle2Shape)
        */
    }

}

extension ZombieScene: GKAgentDelegate {

    func agentWillUpdate(_ agent: GKAgent) {
        guard let agent = agent as? GKAgent2D else { return }

        //zombieCircleShape.position = CGPoint(x: CGFloat(agent.position.x), y: CGFloat(agent.position.y))
        zombieSpriteNode.position = CGPoint(x: CGFloat(agent.position.x), y: CGFloat(agent.position.y))
    }
}

