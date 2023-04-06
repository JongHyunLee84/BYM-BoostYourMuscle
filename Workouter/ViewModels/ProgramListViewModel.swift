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
    
    var numberOfRows: Int {
        return programList.count
    }
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
    
    func returnViewModelAt(_ index: Int) -> ProgramViewModel {
        return programList[index]
    }
    
    func deleteProgram(_ index: Int) {
        // 순서 중요함. 먼저 데이터 지우고 programList 지워야함.
        cdService.deleteProgram(programList[index].program)
        programList.remove(at: index)
    }
}







