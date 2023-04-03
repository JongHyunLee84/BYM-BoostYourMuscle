//
//  Constant.swift
//  BYM
//
//  Created by 이종현 on 2023/03/29.
//

import Foundation
var programSamples: [Programs] = [pushDaySample, pullDaySample, legDaySample]
var pushDaySample =  Programs(exercises:
                                    [
                                        Exercises(target: .chest,
                                                 name: "Bench Press",
                                                 sets: [
                                                    PSets(reps: 10,
                                                         weight: 60),
                                                    PSets(reps: 10,
                                                          weight: 60),
                                                    PSets(reps: 10,
                                                         weight: 60),
                                                    PSets(reps: 10,
                                                         weight: 60)
                                                 ]),
                                        Exercises(target: .shoulders,
                                                 name: "OHP",
                                                 sets: [
                                                    PSets(reps: 10,
                                                         weight: 30),
                                                    PSets(reps: 10,
                                                          weight: 30),
                                                    PSets(reps: 10,
                                                         weight: 30)
                                                 ]),
                                        Exercises(target: .upperArms,
                                                 name: "Push Triceps",
                                                 sets: [
                                                    PSets(reps: 10,
                                                         weight: 35),
                                                    PSets(reps: 10,
                                                          weight: 35),
                                                    PSets(reps: 10,
                                                         weight: 35)
                                                 ])
                                    ],
                                title: "Push Day")
var pullDaySample =  Programs(exercises:
                                    [
                                        Exercises(target: .back,
                                                 name: "Pull Up",
                                                 sets: [
                                                    PSets(reps: 10,
                                                         weight: 75),
                                                    PSets(reps: 10,
                                                          weight: 75),
                                                    PSets(reps: 10,
                                                         weight: 75)
                                                 ]),
                                        Exercises(target: .back,
                                                 name: "Barbell Row",
                                                 sets: [
                                                    PSets(reps: 10,
                                                         weight: 40),
                                                    PSets(reps: 10,
                                                          weight: 40),
                                                    PSets(reps: 10,
                                                         weight: 40)
                                                 ]),
                                        Exercises(target: .upperArms,
                                                 name: "Barbell Curl",
                                                 sets: [
                                                    PSets(reps: 10,
                                                         weight: 35),
                                                    PSets(reps: 10,
                                                          weight: 35),
                                                    PSets(reps: 10,
                                                         weight: 35)
                                                 ])
                                    ],
                                title: "Pull Day")

var legDaySample =  Programs(exercises:
                                    [
                                        Exercises(target: .upperLegs,
                                                 name: "Squat",
                                                 sets: [
                                                    PSets(reps: 10,
                                                         weight: 80),
                                                    PSets(reps: 10,
                                                          weight: 80),
                                                    PSets(reps: 10,
                                                         weight: 80)
                                                 ]),
                                        Exercises(target: .upperLegs,
                                                 name: "Dead Lift",
                                                 sets: [
                                                    PSets(reps: 10,
                                                         weight: 100),
                                                    PSets(reps: 10,
                                                          weight: 100),
                                                    PSets(reps: 10,
                                                         weight: 100)
                                                 ]),
                                        Exercises(target: .upperLegs,
                                                 name: "Leg Extension",
                                                 sets: [
                                                    PSets(reps: 10,
                                                         weight: 70),
                                                    PSets(reps: 10,
                                                          weight: 70),
                                                    PSets(reps: 10,
                                                         weight: 70)
                                                 ])
                                    ],
                                title: "Leg Day")

public struct Cell {
    static let workoutSectionIdentifier = "WorkoutSectionCell"
    static let workoutRowIdentifier = "WorkoutRowCell"
    private init() {}
}
