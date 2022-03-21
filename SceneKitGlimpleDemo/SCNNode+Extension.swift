//
//  SCNNode+Extension.swift
//  SceneKitGlimpleDemo
//
//  Created by Harikesh Patel on 15/02/22.
//

import UIKit
import SceneKit

typealias GPCompletionBlock = (Any?, Bool, Error?, Any?) -> Void

extension SCNNode {
    class func vectorWithPoint(point: CGPoint, zIndex: Float) -> SCNVector3 {
        return SCNVector3Make(Float(point.x), Float(point.y), zIndex)
    }
    
    class func GP_vector(position: SCNVector3, plusZ: Float) -> SCNVector3 {
        let newPosition = SCNVector3Make(position.x, position.y, position.z + plusZ)
        return newPosition
    }
    
    func GP_positionFrontZ(zIndex: Float) -> SCNVector3 {
        let newPosition = SCNNode.GP_vector(position: self.position, plusZ: zIndex)
        return newPosition
    }
    
    func GP_positionAtExistingZWithPoint(point: CGPoint) -> SCNVector3 {
        let newPosition = SCNNode.vectorWithPoint(point: point, zIndex: self.position.z)
        return newPosition
    }
    
    func GP_animateToPointZeroAtExistingZ(completion: @escaping (GPCompletionBlock)) {
        GP_animateAtExistingZWithPoint(point: .zero, completion: completion)
    }
    
    func GP_animateAtExistingZWithPoint(point: CGPoint, completion: @escaping (GPCompletionBlock)) {
        
        OperationQueue.main.addOperation {
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 1
            SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: .easeIn)

            self.position = self.GP_positionAtExistingZWithPoint(point: point)

            SCNTransaction.completionBlock = {
                completion(self, true, nil, self)
            }

            SCNTransaction.commit()
        }
    }
}
