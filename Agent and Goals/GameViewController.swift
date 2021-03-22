//
//  GameViewController.swift
//  Agent and Goals
//  Created by Alley Pereira on 19/03/21.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    let skView: SKView = SKView()

    override func loadView() {
        super.loadView()
        self.view = skView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = ZombieScene(size: CGSize(width: 2048, height: 1536))
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        skView.ignoresSiblingOrder = true
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

}
