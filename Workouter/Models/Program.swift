//
//  Program.swift
//  BYM
//
//  Created by 이종현 on 2023/04/03.
//

import Foundation

struct Program {
    
    // 운동 배열
    var workouts: [Workout]
    
    // 프로그램 제목
    var title: String
    
    init(workouts: [Workout], title: String) {
        self.workouts = workouts
        self.title = title
    }
    
    init() {
        self.init(workouts: [], title: "")
    }
    
}
