//
//  GlimpleNode.swift
//  SceneKitGlimpleDemo
//
//  Created by Harikesh Patel on 14/02/22.
//

import UIKit
import SceneKit
import SDWebImage
import CoreGraphics

class GlimpleNode: SCNNode {
    
    var materialLayersList = [SCNMaterial]()
    var originalPosition: SCNVector3?
    var animating: Bool = false
    var visibleIndex: Int = 0
    var frontVisible: Bool = true
    var coinGeometry = GPCoinGeometry()
    
    func GlimpleNode() {
        print("default")
    }
    
    init(position: SCNVector3) {
        super.init()
        self.geometry = SCNCylinder(radius: 0.5, height: 0.03)
        self.geometry?.firstMaterial?.diffuse.contents = UIColor.init(red:0/255, green:188/255, blue:196/255, alpha:1)
        
        self.position = position
        let xValue = degreeToRadians(degree: 90.0)
        let zValue = degreeToRadians(degree: -90.0)
        self.eulerAngles = SCNVector3(xValue, 0, zValue)
        originalPosition = self.position
        
        materialLayers(index: Int(position.z))
    }
    
    override init() {
        super.init()
        self.geometry = SCNCylinder(radius: 0.5, height: 0.03)
        self.geometry?.firstMaterial?.diffuse.contents = UIColor.init(red:0/255, green:188/255, blue:196/255, alpha:1)
        
        self.position = SCNVector3(-0.75, 0.75, 0)
        let xValue = degreeToRadians(degree: 90.0)
        let zValue = degreeToRadians(degree: -90.0)
        self.eulerAngles = SCNVector3(xValue, 0, zValue)
        originalPosition = self.position
        
        //coinGeometry = self.geometry as? GPCoinGeometry
        
        materialLayers(index: Int(position.z))
        
        //coinGeometry = (self.geometry as? GPCoinGeometry)!
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func degreeToRadians(degree: Float) -> Float {
        return (degree * .pi) / 180
    }
    
    func radiansToDegree(radians: Float) -> Float {
        return (radians * 180) / .pi
    }
    
    func getCoinGeometry() -> GPCoinGeometry {
        coinGeometry = self.geometry! as! GPCoinGeometry
        return coinGeometry
    }
    
    func materialLayers(index: Int) {
        if materialLayersList != nil {
            let toStamp = "Harikesh Patel"
            
            /// Mark: Glimpulse Image
            let glimpleImageURL = index == 0 ? "http://res.cloudinary.com/hc9ivkxzb/image/upload/h_380,w_380/stage/SentimentImages/Om_800.png" : index == -1 ? "http://res.cloudinary.com/hc9ivkxzb/image/upload/h_380,w_380/stage/SentimentImages/Good_Work_800.png" : index == -2 ? "http://res.cloudinary.com/hc9ivkxzb/image/upload/h_380,w_380/stage/SentimentImages/Beauty_To_Me_Is_800.png" : "http://res.cloudinary.com/hc9ivkxzb/image/upload/h_380,w_380/stage/SentimentImages/Believe_In_Miracles_800.png"
            let material = SCNMaterial()
            material.name = "glimpule_layer"
            material.diffuse.wrapT = .repeat
            material.diffuse.wrapS = .repeat
            getImageFromURL(imageURL: glimpleImageURL, material: material, text: toStamp)
            materialLayersList.append(material)
            
            let textImageURL = index == 0 ? "http://res.cloudinary.com/hc9ivkxzb/image/upload/h_380,w_380/stage/UserImages/1443C6F5-F412-4544-A02C-BF505A01DBFD.png" : index == -1 ? "http://res.cloudinary.com/hc9ivkxzb/image/upload/h_380,w_380/stage/UserImages/AD4926C9-C244-49BA-A7FD-C7CD276C9239.png" : index == -2 ? "http://res.cloudinary.com/hc9ivkxzb/image/upload/h_380,w_380/stage/UserImages/D9428FE0-CD4E-4B0C-97CF-BE018BAF5EBA.png" : "http://res.cloudinary.com/hc9ivkxzb/image/upload/h_380,w_380/stage/UserImages/A9F05A13-627C-4122-8AD6-CBDD3653AEBC.png"
            let tMaterial = SCNMaterial()
            tMaterial.name = "glimpule_layer"
            tMaterial.diffuse.wrapT = .repeat
            tMaterial.diffuse.wrapS = .repeat
            getImageFromURL(imageURL: textImageURL, material: tMaterial, text: toStamp)
            materialLayersList.append(tMaterial)
            
            let profileImageURL = index == 0 ? "http://res.cloudinary.com/hc9ivkxzb/image/upload/h_380,w_380/stage/UserImages/9C9FECA0-8D6B-4A5C-BA92-600CDB399D96.png" : index == -1 ? "http://res.cloudinary.com/hc9ivkxzb/image/upload/h_380,w_380/stage/UserImages/DD8B4CE8-9255-4701-8D90-193F37EFFCF9.png" : index == -2 ? "http://res.cloudinary.com/hc9ivkxzb/image/upload/h_380,w_380/stage/UserImages/2E88EE3D-2551-40E2-A1DB-EDB21B1122F6.png" : "http://res.cloudinary.com/hc9ivkxzb/image/upload/h_380,w_380/stage/UserImages/9C9FECA0-8D6B-4A5C-BA92-600CDB399D96.png"
            let pMaterial = SCNMaterial()
            pMaterial.name = "glimpule_layer"
            pMaterial.diffuse.wrapT = .repeat
            pMaterial.diffuse.wrapS = .repeat
            getImageFromURL(imageURL: profileImageURL, material: pMaterial, text: toStamp)
            materialLayersList.append(pMaterial)
            
            self.geometry = GPCoinGeometry.cointWithFront(frontMaterial: materialLayersList[0], rearMaterial: materialLayersList[1])
        }
    }
    
    func getImageFromURL(imageURL: String, material: SCNMaterial, text: String, completed: SDExternalCompletionBlock? = nil) {
        
        let downloader = SDWebImageDownloader.shared
        downloader.downloadImage(with: URL(string: imageURL)) { [self] image, imageData, error, finished in
            if image != nil {
                material.diffuse.contents = image
                
                let tImageView = UIImageView(image: image)
                print("iv size = %f %f\n", tImageView.frame.size.width, tImageView.frame.size.height);
                var r = CGRect()
                r.size.width = tImageView.frame.width
                r.size.height = 30
                r.origin.x = 0
                r.origin.y = tImageView.frame.height * 0.8
                
                r = tImageView.frame
                
                let lab = DGCurvedLabel(frame: r)
                
                lab.radius = (tImageView.frame.size.width/2) - 12
                lab.textInside = true
                lab.rotation = 180
                
                lab.backgroundColor = UIColor.clear
                lab.arcWidth = 42
                lab.arcBackgroundColor = UIColor.init(white: 1, alpha: 0.5)
                
                lab.textColor = UIColor.red
                
                lab.minimumScaleFactor = 10
                lab.adjustsFontSizeToFitWidth = true
                
                lab.font = UIFont.systemFont(ofSize: 24)
                
                lab.textAlignment = .center
                lab.text = text
                
                tImageView.addSubview(lab)
                
                let image = self.imageWithSubView(view: tImageView)
                if image != nil {
                    material.diffuse.contents = image?.cgImage
                }
            } else {
                print("downloadImage.error: \(error)")
            }
        }
    }
    
    func imageWithSubView(view: UIView) -> UIImage? {
        let rect = view.bounds
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0.0)
        guard let context: CGContext = UIGraphicsGetCurrentContext() else { return nil }
        
        view.layer.render(in: context)
        for sv in view.subviews {
            context.translateBy(x: sv.frame.origin.x, y: sv.frame.origin.y)
            sv.layer.render(in: context)
            context.translateBy(x: -sv.frame.origin.x, y: -sv.frame.origin.y)
        }
        
        let capturedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return capturedImage
    }
    
    func flipLeft(flipLeft: Bool, completion: @escaping (GPCompletionBlock)) {
        if !animating {
            animating = true
            
            var newVisibleIndex: Int = visibleIndex+1
            if newVisibleIndex > materialLayersList.count - 1 {
                newVisibleIndex = 0
            }
            if materialLayersList.count - 1 == 0 {
                return
            }
            runAction(SCNAction.rotateBy(x: -180.0 * (.pi/180), y: 0, z: 0, duration: 1)) { [self] in
                visibleIndex = newVisibleIndex
                frontVisible = !frontVisible
                
                var futureVisibleIndex = visibleIndex+1
                if futureVisibleIndex > materialLayersList.count - 1 {
                    futureVisibleIndex = 0
                }
                
                if frontVisible {
                    getCoinGeometry().setRearMaterial(material: materialLayersList[futureVisibleIndex])
                } else {
                    getCoinGeometry().setFrontMaterial(material: materialLayersList[futureVisibleIndex])
                }
                animating = false
                
                completion(self, true, nil, self)
            }
        }
    }
}
