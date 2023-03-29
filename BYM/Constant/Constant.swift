//
//  Constant.swift
//  BYM
//
//  Created by 이종현 on 2023/03/29.
//

import Foundation
var programSamples: [Program] = [pushDaySample, pullDaySample, legDaySample]
var pushDaySample =  Program(exercises:
                                    [
                                        Exercise(target: .chest,
                                                 name: "Bench Press",
                                                 set: [
                                                    PSet(reps: 10,
                                                         weight: 60),
                                                    PSet(reps: 10,
                                                          weight: 60),
                                                    PSet(reps: 10, weight: 60)
                                                 ]),
                                        Exercise(target: .shoulders,
                                                 name: "OHP",
                                                 set: [
                                                    PSet(reps: 10,
                                                         weight: 30),
                                                    PSet(reps: 10,
                                                          weight: 30),
                                                    PSet(reps: 10,
                                                         weight: 30)
                                                 ]),
                                        Exercise(target: .upperArms,
                                                 name: "Push Triceps",
                                                 set: [
                                                    PSet(reps: 10,
                                                         weight: 35),
                                                    PSet(reps: 10,
                                                          weight: 35),
                                                    PSet(reps: 10,
                                                         weight: 35)
                                                 ])
                                    ],
                                title: "Push Day")
var pullDaySample =  Program(exercises:
                                    [
                                        Exercise(target: .back,
                                                 name: "Pull Up",
                                                 set: [
                                                    PSet(reps: 10,
                                                         weight: 75),
                                                    PSet(reps: 10,
                                                          weight: 75),
                                                    PSet(reps: 10,
                                                         weight: 75)
                                                 ]),
                                        Exercise(target: .back,
                                                 name: "Barbell Row",
                                                 set: [
                                                    PSet(reps: 10,
                                                         weight: 40),
                                                    PSet(reps: 10,
                                                          weight: 40),
                                                    PSet(reps: 10,
                                                         weight: 40)
                                                 ]),
                                        Exercise(target: .upperArms,
                                                 name: "Barbell Curl",
                                                 set: [
                                                    PSet(reps: 10,
                                                         weight: 35),
                                                    PSet(reps: 10,
                                                          weight: 35),
                                                    PSet(reps: 10,
                                                         weight: 35)
                                                 ])
                                    ],
                                title: "Pull Day")

var legDaySample =  Program(exercises:
                                    [
                                        Exercise(target: .upperLegs,
                                                 name: "Squat",
                                                 set: [
                                                    PSet(reps: 10,
                                                         weight: 80),
                                                    PSet(reps: 10,
                                                          weight: 80),
                                                    PSet(reps: 10,
                                                         weight: 80)
                                                 ]),
                                        Exercise(target: .upperLegs,
                                                 name: "Dead Lift",
                                                 set: [
                                                    PSet(reps: 10,
                                                         weight: 100),
                                                    PSet(reps: 10,
                                                          weight: 100),
                                                    PSet(reps: 10,
                                                         weight: 100)
                                                 ]),
                                        Exercise(target: .upperLegs,
                                                 name: "Leg Extension",
                                                 set: [
                                                    PSet(reps: 10,
                                                         weight: 70),
                                                    PSet(reps: 10,
                                                          weight: 70),
                                                    PSet(reps: 10,
                                                         weight: 70)
                                                 ])
                                    ],
                                title: "Leg Day")
