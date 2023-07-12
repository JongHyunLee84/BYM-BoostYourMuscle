//
//  Target.swift
//  BYM
//
//  Created by 이종현 on 2023/04/03.
//

import Foundation

enum Target: String, CaseIterable {
    case back = "back" //등
    case cardio = "cardio" // 유산소
    case chest = "chest" // 가슴
    case lowerArms = "lower arms" // 전완
    case lowerLegs = "lower legs" // 종아리
    case neck = "neck" // 목
    case shoulders = "shoulders" // 어깨
    case upperArms = "upper arms" // 상완
    case upperLegs = "upper legs" // 하체(Basic)
    case waist = "waist" // 허리
}

extension Target {
    static subscript(_ target: Target) -> Int{
        switch target {
        case .back:
            return 0
        case .cardio:
            return 1
        case .chest:
            return 2
        case .lowerArms:
            return 3
        case .lowerLegs:
            return 4
        case .neck:
            return 5
        case .shoulders:
            return 6
        case .upperArms:
            return 7
        case .upperLegs:
            return 8
        case .waist:
            return 9
        }
    }
}
