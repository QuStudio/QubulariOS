//
//  Global.swift
//  Qubular
//
//  Created by Oleg Dreyman on 26.04.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

func onMainQueue(task: () -> ()) {
    let mainQueue = dispatch_get_main_queue()
    dispatch_async(mainQueue, task as dispatch_block_t)
}
