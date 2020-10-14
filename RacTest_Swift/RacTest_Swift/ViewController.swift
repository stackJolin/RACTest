//
//  ViewController.swift
//  RacTest_Swift
//
//  Created by houlin on 2020/7/1.
//  Copyright © 2020 houlin. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON
import Kingfisher

protocol zhuhoulin {
    
    func dddddd()
}

extension zhuhoulin {
    
    func dddddd() {
        print("fddfdfd")
    }
    
    func func2() {
        print("func2")
    }
}

class ViewController: UIViewController, zhuhoulin {
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.dddddd()
//        self.func2()
//        let json:JSON = JSON(parseJSON: "")
//        let a = json["d"]["c"].boolValue
//
//        let jsonStr = "{\"name\":\"fdf\"}"
//
////        let model = HandyJsonObj1.deserialize(from: jsonStr)
//
//        let model1 = HandyJsonObj2.deserialize(from: jsonStr)
        // Do any additional setup after loading the view.
        
        let iv = UIImageView()
        
        let b = Ddddd()
        b.kf
        
        iv.kf.setImage(with: <#T##Source?#>)

    }
}

class Ddddd:NSObject {
    
}

extension Ddddd:KingfisherCompatible {
    
}


struct HandyJsonObj1:HandyJSON {
    var name:String = ""
    var index:Int   = 0
    
    var obj1:HandyJsonObj2 = HandyJsonObj2()
}

class HandyJsonObj2:HandyJSON {
    var title:String = ""
    var index:Int   = 0
    
    required init() {
        
    }
}
