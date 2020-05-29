//
//  Task.swift
//  GoodList
//
//  Created by prog_zidane on 5/29/20.
//  Copyright © 2020 Prog Zidane. All rights reserved.
//

import Foundation

enum Priority: Int {
    case high
    case medium
    case low 
}

struct Task {
    let title: String
    let priority: Priority
}
