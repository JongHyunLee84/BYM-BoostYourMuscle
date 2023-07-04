//
//  PsetViewModel.swift
//  BYM
//
//  Created by 이종현 on 2023/04/05.
//

import Foundation

final class PSetViewModel {
    
    private var pset: SetVolume
    var weight: Double {
        return pset.weight
    }
    var reps: Int {
        return pset.reps
    }

    init(pset: SetVolume) {
        self.pset = pset
    }
    
    convenience init?(weight: String, reps: String) {
        guard let weight = Double(weight), let reps = Int(reps) else { print("fail to init psetvm"); return nil }
        self.init(pset: SetVolume(reps: reps, weight: weight))
    }
    
    func returnWeight() -> String {
        // 소수점이 있는지 여부 % 쓰려니까 이제 못 쓰게함
        if pset.weight.truncatingRemainder(dividingBy: 1).isZero {
            let rounded = Int(pset.weight)
            return "\(rounded) kg"
        }
        return "\(pset.weight) kg"
    }
    func returnReps() -> String {
        return "\(pset.reps) reps"
    }
    func returnCheck() -> Bool {
        return pset.check
    }
    
    func toggleCheck() {
        pset.check.toggle()
    }
    
    func changeWeight(_ weight: String) {
        guard let weight = Double(weight) else { print("fail to type conversion"); return }
        pset.weight = weight
    }
    
    func changeReps(_ reps: String) {
        guard let reps = Int(reps) else { print("fail to type conversion"); return }
        pset.reps = reps
    }
    
}
