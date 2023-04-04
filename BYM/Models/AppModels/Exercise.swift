//
//  Exercise.swift
//  BYM
//
//  Created by 이종현 on 2023/04/03.
//

import Foundation

struct Exercise {
    
    // 운동 부위
    var target: Target
    // 운동 이름
    var name: String
    // 세트 Set 키워드로 인해 Per Set의 줄임을 사용
    var sets: [PSet]
    // 세트 당 쉬는 시간
    var rest: Int = 60
    // 해당 운동 총 볼륨
    var totalVolume: Double {
        let isChecked = self.sets.filter { $0.check == true }
        let realVolume = isChecked.reduce(0) { $0 + (Double($1.reps)*$1.weight) }
        return realVolume
    }
}
