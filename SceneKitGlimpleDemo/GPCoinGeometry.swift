//
//  GPCoinGeometry.swift
//  SceneKitGlimpleDemo
//
//  Created by Harikesh Patel on 15/02/22.
//

import UIKit
import SceneKit

class GPCoinGeometry: SCNCylinder {
    class func cointWithFront(frontMaterial: SCNMaterial, rearMaterial: SCNMaterial) -> GPCoinGeometry {
        let coin = GPCoinGeometry.init(radius: 0.5, height: 0.03)
        coin.radialSegmentCount = 288
        
        let sideMaterial = SCNMaterial.init()
        sideMaterial.name = "side"
        
        coin.materials = [sideMaterial, transformedFrontMaterial(material: frontMaterial), transformedRearMaterial(material: rearMaterial)]
        
        return coin
    }
    
    class func transformedFrontMaterial(material: SCNMaterial) -> SCNMaterial {
        material.diffuse.contentsTransform = SCNMatrix4MakeScale(1, -1, -1)
        return material
    }
    
    class func transformedRearMaterial(material: SCNMaterial) -> SCNMaterial {
        material.diffuse.contentsTransform = SCNMatrix4MakeScale(-1, 1, 1)
        return material
    }
    
    func setFrontMaterial(material: SCNMaterial) {
        replaceMaterial(at: 1, with: GPCoinGeometry.transformedFrontMaterial(material: material))
    }
    
    func setRearMaterial(material: SCNMaterial) {
        replaceMaterial(at: 2, with: GPCoinGeometry.transformedRearMaterial(material: material))
    }
    
    func setSideMaterial(material: SCNMaterial) {
        replaceMaterial(at: 0, with: material)
    }
}
