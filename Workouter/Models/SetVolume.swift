//
//  Pset.swift
//  BYM
//
//  Created by 이종현 on 2023/04/03.
//

import Foundation

struct SetVolume {
    // 횟수
    var reps: Int
    // 무게
    var weight: Double
    // 체크
    var check: Bool = false
    
    var id: Int = 0
    
    init(reps: Int, weight: Double) {
        self.reps = reps
        self.weight = weight
    }
    
    init(reps: Int, weight: Double, id: Int) {
        self.reps = reps
        self.weight = weight
        self.id = id
    }
    
    
    
}
