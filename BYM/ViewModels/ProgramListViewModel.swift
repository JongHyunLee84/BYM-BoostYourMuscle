//
//  ProgramListTableViewModel.swift
//  BYM
//
//  Created by 이종현 on 2023/03/29.
//

import Foundation

final class ProgramListViewModel {
    
    private let cdService = CoreDataService()
    private var programList: [ProgramViewModel] = []
    
    init() {
        let programViewModels = cdService.fetchProgram().compactMap { program in
            return ProgramViewModel(program: program)
        }
        self.programList = programViewModels
    }
    
    func fetchProgramVMList() {
        programList = cdService.fetchProgram().map { ProgramViewModel(program: $0) }
    }
    
    func addProgram(_ vm: ProgramViewModel) {
        programList.append(vm)
        cdService.saveProgram(Program(exercises: vm.program.exercises,
                                    title: vm.title))
    }
    
    func numberOfRows() -> Int {
        self.programList.count
    }
    
    func returnViewModelAt(_ index: Int) -> ProgramViewModel {
        return programList[index]
    }
}







