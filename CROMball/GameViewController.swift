//
//  GameViewController.swift
//  CROMball
//
//  Created by Allan Hull on 6/10/16.
//  Copyright (c) 2016 CROM.mobi. All rights reserved.
//

import UIKit
import SceneKit

class GameViewController: UIViewController {

    // SceneKit values
    var scnView:SCNView!
    var scnScene: SCNScene!
    var game = GameHelper.sharedInstance
    
    // Camera values
    var horizontalCameraNode:  SCNNode!
    var verticalCameraNode: SCNNode!
    
    // Node values
    var basketBallNode: SCNNode!
    var shipsNode: SCNNode!
    
    // martin ship
    var ships: [SCNNode] = []
    var numberOfShips = 3
    var shipRingRadius:CGFloat = 1.0
    var shipPipeRadius:CGFloat = 0.4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load setup methods
        setupScene()
        setupNodes()
        setupSounds()
//        setupBasketBall()
//         setupMartianShip()
        
        
     }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        let deviceOrientation = UIDevice.current.orientation
        switch(deviceOrientation) {
        case .portrait:
            scnView.pointOfView = verticalCameraNode
        default:
            scnView.pointOfView = horizontalCameraNode
        }
    }
    

    //
    // BEGIN: setup methods
    //
    
    func setupScene() {
        scnView = self.view as! SCNView
        scnView.delegate = self
        
        scnScene = SCNScene(named: "CROMball.scnassets/Scenes/Game.scn")
        scnView.scene = scnScene
        
    }
    
    func setupNodes() {
        
        // hud
        scnScene.rootNode.addChildNode(game.hudNode)
        
        // camera
        horizontalCameraNode = scnScene.rootNode.childNode(withName: "HorizontalCamera", recursively: true)!
        verticalCameraNode = scnScene.rootNode.childNode(withName: "VerticalCamera",recursively: true)!
        
        // nodes
        basketBallNode = scnScene.rootNode.childNode(withName: "basketBall", recursively: true)
        shipsNode = scnScene.rootNode.childNode(withName: "Ships", recursively: true)
        
        // move ship nodes
        let moveRight = SCNAction.moveBy(x: 1.0, y: 0.0, z: 0.0, duration: 1.0)
        let moveLeft = SCNAction.moveBy(x: -1.0, y: 0.0, z: 0.0, duration: 1.0)
        let moveSequence = SCNAction.sequence([moveRight,moveLeft])
        let repeatSequence = SCNAction.repeatForever(moveSequence)
        shipsNode.runAction(repeatSequence)
        
        // move ball node
        let moveBallRight = SCNAction.moveBy(x: 3.0, y: 0.0, z: 0.0, duration: 1.0)
        let moveBallLeft = SCNAction.moveBy(x: -3.0, y: 0.0, z: 0.0, duration: 1.0)
        let moveBallSequence = SCNAction.sequence([moveBallRight,moveBallLeft])
        let repeatBallSequence = SCNAction.repeatForever(moveBallSequence)
        basketBallNode.runAction(repeatBallSequence)
        
        
    }

    func setupSounds() {
        
    }
    
    func setupBasketBall() {
    
        print("setupBasketBall")
        
        // define ball geometry
        let ballGeometry = SCNSphere(radius: 0.75)
        let ballNode = SCNNode(geometry: ballGeometry)
        
        // define ball materials
        ballGeometry.firstMaterial!.diffuse.contents = UIImage(named: "balldimpled")
        ballGeometry.firstMaterial!.locksAmbientWithDiffuse = true
        ballGeometry.firstMaterial!.diffuse.wrapS = SCNWrapMode.repeat
        
        // position ball
        ballNode.position = SCNVector3Make(0,0,0)
        scnScene.rootNode.addChildNode(ballNode)
        
    }
    
    func setupMartianShip() {
        
        print("setupMartianShip")
        
        for i in 0..<numberOfShips {
            
            // define ship geometry

            let color = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0 )
            let body = SCNSphere(radius: 0.75)
            let bodyNode = SCNNode(geometry: body)
            let ship = SCNTorus(ringRadius: shipRingRadius, pipeRadius: shipPipeRadius)
            let shipNode = SCNNode(geometry: ship)
            
            // define ship materials
            ship.firstMaterial?.diffuse.contents = color
            ship.firstMaterial?.specular.contents = UIColor.white
            body.firstMaterial?.diffuse.contents = color
//            let img = UIImage(named: "bnr_hat_only.png")
//            body.firstMaterial?.diffuse.contents = img
            body.firstMaterial?.specular.contents = UIColor.white
            
            // position ship
            switch(i) {
            case 0:
                shipNode.position.x = 0.0
                shipNode.position.y = 0.0
                shipNode.position.z = 0.0
                bodyNode.position.x = 0.0
                bodyNode.position.y = 0.0
                bodyNode.position.z = 0.0
            case 1:
                shipNode.position.x = 4.0
                shipNode.position.y = 0.0
                shipNode.position.z = 0.0
                bodyNode.position.x = 4.0
                bodyNode.position.y = 0.0
                bodyNode.position.z = 0.0
            case 2:
                shipNode.position.x = -4.0
                shipNode.position.y = 0.0
                shipNode.position.z = 0.0
                bodyNode.position.x = -4.0
                bodyNode.position.y = 0.0
                bodyNode.position.z = 0.0
            default: break
            }
            
            // move ship
            let moveRight = SCNAction.moveBy(x: 1.0, y: 0.0, z: 0.0, duration: 1.0)
            let moveLeft = SCNAction.moveBy(x: -1.0, y: 0.0, z:0.0, duration: 1.0)
            let moveSequence = SCNAction.sequence([moveRight,moveLeft])
            let repeatSequence = SCNAction.repeatForever(moveSequence)
            bodyNode.runAction(repeatSequence)
            shipNode.runAction(repeatSequence)
            
            // position ship
            scnScene.rootNode.addChildNode(bodyNode)
            scnScene.rootNode.addChildNode(shipNode)
            ships.append(shipNode)
            
        }
        
    }
    
    //
    // END: setup methods
    //
    
 
}

//
// extension methods
//

extension GameViewController: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval ) {
        
        game.updateHUD()
    }
}
