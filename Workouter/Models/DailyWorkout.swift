//
//  DailyWorkout.swift
//  BYM
//
//  Created by 이종현 on 2023/03/29.
//

import Foundation

struct DailyWorkOut {
    // 1. 총 운동 시간
    
    // 2. 총 볼륨
    var totalVolume: Double {
        let workouts = program.workouts
        let total = workouts.reduce(0) { $0 + $1.totalVolume }
        return total
    }
    // 3. 날짜
    var today: Data = Data() // 초기화 시 항상 당일 날짜
    // 4. 프로그램
    var program: Program
    
}
