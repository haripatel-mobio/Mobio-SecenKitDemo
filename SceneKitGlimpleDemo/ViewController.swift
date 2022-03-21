//
//  ViewController.swift
//  SceneKitGlimpleDemo
//
//  Created by Harikesh Patel on 13/02/22.
//

import UIKit
import SceneKit

class ViewController: UIViewController {

    @IBOutlet weak var scnView: SCNView!
    var scnScene: SCNScene!
    var lightNode: SCNNode?
    var ambientLightNode: SCNNode?
    var gradientNode: SCNNode?
    var selectedNode: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupSceneView()
        setupScene()
    }
    
    func setupSceneView() {
        scnScene = SCNScene.init(named: "GlimpleScene.scn")!
    }
    
    func setupScene() {
        // scnScene = SCNScene()
        /*let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        
        cameraNode.position = SCNVector3(0, 0, 4)
        
        scnScene.rootNode.addChildNode(cameraNode)*/
        
        //[self.scene.rootNode addChildNode:[GPGlimpleCameraNode nodeInView:self.sceneView]];
        
        scnScene.rootNode.addChildNode(GPGlimpleCameraNode.node(in: scnView))
        
        /*lightNode = SCNNode()
        lightNode?.light = SCNLight()
        lightNode?.light?.type = .omni
        setLightNodeForCameraPosition(cameraPosition: SCNVector3(0, 0, 0))
        lightNode?.name = "lightNode"
        scnScene.rootNode.addChildNode(lightNode!)
        
        ambientLightNode = SCNNode()
        ambientLightNode?.light = SCNLight()
        ambientLightNode?.light?.type = .ambient
        ambientLightNode?.light?.color = UIColor.darkGray
        ambientLightNode?.name = "ambientLightNode"
        scnScene.rootNode.addChildNode(ambientLightNode!)*/
        
        let glimpleNode = GlimpleNode(position: SCNVector3(-0.75, 0.75, 0))
        scnScene.rootNode.addChildNode(glimpleNode)
        
        let glimpleNode1 = GlimpleNode(position: SCNVector3(-0.75, -0.75, -1))
        scnScene.rootNode.addChildNode(glimpleNode1)
        
        let glimpleNode2 = GlimpleNode(position: SCNVector3(0.75, -0.75, -2))
        scnScene.rootNode.addChildNode(glimpleNode2)
        
        let glimpleNode3 = GlimpleNode(position: SCNVector3(0.75, 0.75, -3))
        scnScene.rootNode.addChildNode(glimpleNode3)
        
        /*scnScene.fogColor = UIColor.init(red: 0/255, green: 187/255, blue: 196/255, alpha: 1)
        scnScene.fogStartDistance = 6.0
        scnScene.fogEndDistance = 4 * 6.5
        scnScene.fogDensityExponent = 2.0*/
        
        scnView.scene = scnScene
        scnView.allowsCameraControl = false
        scnView.showsStatistics = false
        scnView.backgroundColor = UIColor.clear
        
        setupGestures()
    }
    
    func cameraNode() -> GPGlimpleCameraNode? {
        return scnScene.rootNode.childNode(withName: "camera", recursively: true) as? GPGlimpleCameraNode
    }
    
    func setupGestures() {
        var tapGestures = [UIGestureRecognizer]()
        
        let tapHandler = UITapGestureRecognizer(target: self, action: #selector(sceneViewNodeTapHandler(_:)))
        tapGestures.append(tapHandler)
        
        let longPressHandler = UILongPressGestureRecognizer(target: self, action: #selector(sceneViewNodeLongPressHandler(_:)))
        tapGestures.append(longPressHandler)
        
        let panHandler = UIPanGestureRecognizer(target: self, action: #selector(sceneViewNodePanHandler(_:)))
        tapGestures.append(panHandler)
        
        tapGestures.append(contentsOf: scnView.gestureRecognizers!)
        scnView.gestureRecognizers = tapGestures
    }
    
    func moveCameraToZ(z: Float) {
        let position: SCNVector3 = SCNNode.vectorWithPoint(point: .zero, zIndex: z)
        cameraNode()?.setPosition(position: position)
    }
    
    func setLightNodeForCameraPosition(cameraPosition: SCNVector3) {
        
    }
    
    @objc func sceneViewNodeTapHandler(_ gestureRecognize: UITapGestureRecognizer) {
        print("sceneViewNodeTapHandler")
        let p = gestureRecognize.location(in: scnView)
        let hitResult = scnView.hitTest(p, options: nil)
        if hitResult.count > 0 {
            let result: SCNHitTestResult = hitResult[0]
            if result.node.position.z > ((cameraNode()?.position.z)! - Float((cameraNode()?.camera!.zFar)!)) {
                if selectedNode != nil {
                    if let glimpleNode = result.node as? GlimpleNode {
                        glimpleNode.flipLeft(flipLeft: true) { sender, success, error, result in
                            
                        }
                    }
                } else {
                    selectNode(node: result.node)
                }
            }
            
        } else {
            unSelectNode()
        }
    }
    
    func unSelectNode() {
        if let node = selectedNode {
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            SCNTransaction.animationTimingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
            
            if let glimpleNode = node as? GlimpleNode {
                node.position = glimpleNode.originalPosition!
            }
            moveCameraToZ(z: node.GP_positionFrontZ(zIndex: 3.0).z)
            
            SCNTransaction.commit()
            
            selectedNode = nil
            /*SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            SCNTransaction.animationTimingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
            
            moveCameraToZ(z: node.GP_positionFrontZ(zIndex: 3.0).z)
            
            SCNTransaction.commit()*/
        }
    }
    
    func selectNode(node: SCNNode) {
        selectedNode = node
        
        scnView.prepare([node], completionHandler: nil)
        
        //let fadeImagePlane: SCNPlane = SCNPlane.init(width: 4, height: 5)
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.5
        SCNTransaction.animationTimingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
        
        node.GP_animateToPointZeroAtExistingZ { sender, success, error, result in
            
        }
        
        moveCameraToZ(z: node.GP_positionFrontZ(zIndex: 2.0).z)
        /*if SCNVector3EqualToVector3(cameraNode()!.position, node.GP_positionFrontZ(zIndex: 2.0)) {
            moveCameraToZ(z: node.GP_positionFrontZ(zIndex: 2.0).z)
        }*/
        
        SCNTransaction.commit()
    }
    
    @objc func sceneViewNodeLongPressHandler(_ gestureRecognize: UITapGestureRecognizer) {
        print("sceneViewNodeLongPressHandler")
    }
    
    @objc func sceneViewNodePanHandler(_ gestureRecognize: UIPanGestureRecognizer) {
        let velocy: Float = Float(gestureRecognize.velocity(in: self.view).y)
        let transy: Float = Float(gestureRecognize.translation(in: self.view).y)
        
        let tZ = cameraNode()?.position.z ?? 0
        let z:Float = tZ + transy/400
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.5
        
        print("move camera to z %f\n", z);
        moveCameraToZ(z: z)
        
        SCNTransaction.commit()
    }
}

