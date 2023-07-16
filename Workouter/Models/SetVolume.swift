//
//  Pset.swift
//  BYM
//
//  Created by 이종현 on 2023/04/03.
//
import Differentiator
import Foundation

struct SetVolume {

    var reps: Int
    var weight: Double
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

extension SetVolume: IdentifiableType, Equatable {
    var identity: String {
        return UUID().uuidString
    }
}
