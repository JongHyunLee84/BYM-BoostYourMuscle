//
//  Constant.swift
//  BYM
//
//  Created by 이종현 on 2023/03/29.
//

import Foundation
//var programSamples: [Program] = [pushDaySample, pullDaySample, legDaySample]
//var pushDaySample =  Program(exercises:
//                                    [
//                                        Exercise(target: .chest,
//                                                 name: "Bench Press",
//                                                 sets: [
//                                                    PSet(reps: 10,
//                                                         weight: 60),
//                                                    PSet(reps: 10,
//                                                          weight: 60),
//                                                    PSet(reps: 10,
//                                                         weight: 60),
//                                                    PSet(reps: 10,
//                                                         weight: 60)
//                                                 ]),
//                                        Exercise(target: .shoulders,
//                                                 name: "OHP",
//                                                 sets: [
//                                                    PSet(reps: 10,
//                                                         weight: 30),
//                                                    PSet(reps: 10,
//                                                          weight: 30),
//                                                    PSet(reps: 10,
//                                                         weight: 30)
//                                                 ]),
//                                        Exercise(target: .upperArms,
//                                                 name: "Push Triceps",
//                                                 sets: [
//                                                    PSet(reps: 10,
//                                                         weight: 35),
//                                                    PSet(reps: 10,
//                                                          weight: 35),
//                                                    PSet(reps: 10,
//                                                         weight: 35)
//                                                 ])
//                                    ],
//                             title: "Push Day")
//var pullDaySample =  Program(exercises:
//                                    [
//                                        Exercise(target: .back,
//                                                 name: "Pull Up",
//                                                 sets: [
//                                                    PSet(reps: 10,
//                                                         weight: 75),
//                                                    PSet(reps: 10,
//                                                          weight: 75),
//                                                    PSet(reps: 10,
//                                                         weight: 75)
//                                                 ]),
//                                        Exercise(target: .back,
//                                                 name: "Barbell Row",
//                                                 sets: [
//                                                    PSet(reps: 10,
//                                                         weight: 40),
//                                                    PSet(reps: 10,
//                                                          weight: 40),
//                                                    PSet(reps: 10,
//                                                         weight: 40)
//                                                 ]),
//                                        Exercise(target: .upperArms,
//                                                 name: "Barbell Curl",
//                                                 sets: [
//                                                    PSet(reps: 10,
//                                                         weight: 35),
//                                                    PSet(reps: 10,
//                                                          weight: 35),
//                                                    PSet(reps: 10,
//                                                         weight: 35)
//                                                 ])
//                                    ],
//                                title: "Pull Day")
//
//var legDaySample =  Program(exercises:
//                                    [
//                                        Exercise(target: .upperLegs,
//                                                 name: "Squat",
//                                                 sets: [
//                                                    PSet(reps: 10,
//                                                         weight: 80),
//                                                    PSet(reps: 10,
//                                                          weight: 80),
//                                                    PSet(reps: 10,
//                                                         weight: 80)
//                                                 ]),
//                                        Exercise(target: .upperLegs,
//                                                 name: "Dead Lift",
//                                                 sets: [
//                                                    PSet(reps: 10,
//                                                         weight: 100),
//                                                    PSet(reps: 10,
//                                                          weight: 100),
//                                                    PSet(reps: 10,
//                                                         weight: 100)
//                                                 ]),
//                                        Exercise(target: .upperLegs,
//                                                 name: "Leg Extension",
//                                                 sets: [
//                                                    PSet(reps: 10,
//                                                         weight: 70),
//                                                    PSet(reps: 10,
//                                                          weight: 70),
//                                                    PSet(reps: 10,
//                                                         weight: 70)
//                                                 ])
//                                    ],
//                                title: "Leg Day")

public struct Identifier {
    static let workoutSectionIdentifier = "WorkoutSectionCell"
    static let workoutRowIdentifier = "WorkoutRowCell"
    static let addWorkoutTableViewCell = "AddWorkoutTableViewCell"
    static let addProgramTableViewCell = "AddProgramTableViewCell"
    static let addProgramVCIdentifier = "AddProgramViewController"
    static let toAddWorkoutViewController = "toAddWorkoutViewController"
    static let workoutVCIdentifier = "WorkoutViewController"
    static let soundButtonKey = "soundButtonKey"
    static let searchWorkoutTableViewCell = "SearchWorkoutTableViewCell"
    static let searchWorkoutViewController = "SearchWorkoutViewController"
    private init() {}
}
