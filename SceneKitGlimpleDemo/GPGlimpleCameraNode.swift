//
//  GPGlimpleCameraNode.swift
//  SceneKitGlimpleDemo
//
//  Created by Harikesh Patel on 15/02/22.
//

import UIKit
import SceneKit

class GPGlimpleCameraNode: SCNNode {
    
    var view = SCNView()
    
    private static var sharedCameraObj: GPGlimpleCameraNode = {
        let sharedCamera = GPGlimpleCameraNode()
        return sharedCamera
    }()
    
    class func sharedCamera() -> GPGlimpleCameraNode? {
        return sharedCameraObj
    }
    
    class func node(in view: SCNView?) -> Self {
        // create and add a camera to the scene
        let node = GPGlimpleCameraNode()
        node.name = "camera"

        node.camera = SCNCamera()

        node.camera?.xFov = 30
        node.camera?.yFov = 40

        node.camera?.zNear = 1.25
        node.camera?.zFar = 40 * 6.5

        node.camera?.aperture = 1.25
        
        node.position = SCNVector3Make(0, 0, 4)

        node.view = view!

        sharedCameraObj = node

        view?.scene?.rootNode.addChildNode(node)

        return node as! Self
    }
    
    func setPosition(position: SCNVector3) {
        super.position = position
    }
}
