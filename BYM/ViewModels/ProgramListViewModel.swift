//
//  ProgramListTableViewModel.swift
//  BYM
//
//  Created by 이종현 on 2023/03/29.
//

import Foundation

class ProgramListViewModel {
    private var programList: [ProgramViewModel] = []
    
    func addProgram(_ vm: ProgramViewModel) {
        programList.append(vm)
    }
    
    func numberOfRows() -> Int {
        self.programList.count
    }
    
    func modelAt(_ index: Int) -> ProgramViewModel {
        return programList[index]
    }
}

class ProgramViewModel {
    
    private var program: Program
    
    init(program: Program) {
        self.program = program
    }
    
    func returnTitle() -> String {
        return program.title
    }
    
    func returnExercises() -> [Exercise] {
        return program.exercises
    }

}
