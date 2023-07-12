//
//  Exercise.swift
//  BYM
//
//  Created by 이종현 on 2023/04/03.
//

import UIKit

struct Workout {
    
    // 운동 부위
    var target: Target
    // 운동 이름
    var name: String
    // 세트 Set 키워드로 인해 Per Set의 줄임을 사용
    var sets: [SetVolume]
    // 세트 당 쉬는 시간
    var rest: Int
    // 운동 순서를 위한 id
    var id: Int = 0
    // 해당 운동 총 볼륨
    var totalVolume: Double {
        let isChecked = self.sets.filter { $0.check == true }
        let realVolume = isChecked.reduce(0) { $0 + (Double($1.reps)*$1.weight) }
        return realVolume
    }
    
    // 서버에서 오는 Exercise 맞춤
    var gifUrl: String?
    var gif: UIImage?
    var equipment: String?
    
    init(target: Target, name: String, rest: Int, id: Int, sets: [SetVolume]) {
        self.target = target
        self.name = name
        self.sets = sets
        self.rest = rest
        self.id = id
    }
    // 지정생성자
    init(target: Target, name: String, rest: Int, sets: [SetVolume]) {
        self.target = target
        self.name = name
        self.sets = sets
        self.rest = rest
    }
    
    // reset가 60으로 기본 설정된 init
    init(target: Target, name: String, sets: [SetVolume]) {
        self.init(target: target, name: name, rest: 60, sets: sets)
    }
    
    // 나중에 데이터 채워 넣으려고 만든 init
    init() {
        self.init(target: .back, name: "", rest: 60, sets: [])
    }
    
    init?(target: String?, name: String?, gifUrl: String?, equipment: String?) {
        guard let target, let name, let gifUrl, let equipment else { return nil }
        self.init(target: Target(rawValue: target) ?? .chest, name: name, rest: 60, sets: [])
        self.gifUrl = gifUrl
        self.equipment = equipment
    }
    
}
