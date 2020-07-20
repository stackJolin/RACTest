//
//  RouterTest.swift
//  RacTest_Swift
//
//  Created by houlin on 2020/7/16.
//  Copyright © 2020 houlin. All rights reserved.
//

import Foundation
protocol RouterModuleProtocol {
    func exclute(_ command:RouterCommand)
}

class RouterModule:NSObject,RouterModuleProtocol {
    
    // 子类重写
    func exclute(_ command:RouterCommand) {
        
    }
}

struct RouterCommand {
    var module:String = ""
    var params:Any?
    var handler:Any?
}

class Router {
    
    static let `default` = Router()
    
    /// 路由表
    var maps:[String:RouterModule] = [:]
    
    func exclute(_ command:RouterCommand) -> Error? {
        
        // 查找没有该条路由
        
        return nil
    }
}
