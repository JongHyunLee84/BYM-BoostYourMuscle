//
//  Program.swift
//  BYM
//
//  Created by 이종현 on 2023/04/03.
//

import Foundation

struct Program {
    
    // 운동 배열
    var exercises: [Exercise]
    
    // 프로그램 제목
    var title: String
    
    init(exercises: [Exercise], title: String) {
        self.exercises = exercises
        self.title = title
    }
    
    init() {
        self.init(exercises: [], title: "")
    }
    
}
