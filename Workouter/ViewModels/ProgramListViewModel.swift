//
//  ProgramListTableViewModel.swift
//  BYM
//
//  Created by 이종현 on 2023/03/29.
//

import RxRelay
import RxSwift

final class ProgramListViewModel {
    
    private let programsRepository: ProgramsRepository
    private let disposeBag = DisposeBag()
    let programsRelay = BehaviorRelay<[Program]>(value: [])
    let numberOfRows = BehaviorRelay(value: 0)
    
    init(programsRepository: ProgramsRepository) {
        self.programsRepository = programsRepository
        
        programsRepository.fetchPrograms()
            .subscribe(onNext: { [weak self] in
                self?.programsRelay.accept($0)
            })
            .disposed(by: disposeBag)
        
        programsRelay
            .map({ $0.count })
            .bind(to: numberOfRows)
            .disposed(by: disposeBag)
    }
    
    func addProgram(_ program: Program) {
        programsRelay.accept(changeProgramsRelay(cases: .create, index: nil, program: program))
        programsRepository.saveProgram(program)
    }
    
    func returnViewModelAt(_ index: Int) -> Program {
        return programsRelay.value[index]
    }
    
    func deleteProgram(_ index: Int) {
        // 순서 중요함. 먼저 데이터 지우고 programList 지워야함.
        programsRepository.deleteProgram(programsRelay.value[index])
        programsRelay.accept(changeProgramsRelay(cases: .delete, index: index, program: nil))
    }
    
    func tempFetchPrograms() {
        programsRepository.fetchPrograms()
            .subscribe(onNext: { [weak self] in
                dump($0)
                self?.programsRelay.accept($0)
            })
            .disposed(by: disposeBag)
    }
    
    private func changeProgramsRelay(cases: CRUD, index: Int?, program: Program?) -> [Program]{
        var values = programsRelay.value
        switch cases {
        case .delete:
            guard let index else { return values }
            values.remove(at: index)
        case .create:
            guard let program else { return values }
            values.append(program)
        case .update:
            break
        }
        return values
    }
}







