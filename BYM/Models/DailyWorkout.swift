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
        let exercises = program.exercises
        let total = exercises.reduce(0) { $0 + $1.totalVolume }
        return total
    }
    // 3. 날짜
    var today: Data = Data() // 초기화 시 항상 당일 날짜
    // 4. 프로그램
    var program: Program
    
}

struct Program {
    
    // 운동 배열
    var exercises: [Exercise]
    
    // 프로그램 제목
    var title: String
}

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

enum Target: String, CaseIterable {
    case back //등
    case cardio // 유산소
    case chest // 가슴
    case lowerArms // 전완
    case lowerLegs // 종아리
    case neck // 목
    case shoulders // 어깨
    case upperArms // 상완
    case upperLegs // 하체(Basic)
    case waist // 허리
}

struct PSet {
    // 횟수
    var reps: Int
    // 무게
    var weight: Double
    // 체크
    var check: Bool = false
}


/*
 0:"back"
 1:"cardio"
 2:"chest"
 3:"lower arms"
 4:"lower legs"
 5:"neck"
 6:"shoulders"
 7:"upper arms"
 8:"upper legs"
 9:"waist"
*/
