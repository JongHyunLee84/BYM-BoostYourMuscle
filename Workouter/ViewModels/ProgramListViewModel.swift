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
    let emptyMessage = "You don't have any program yet. \n please tap add button to save program 💪"
    
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
        Observable<Program>
            .just(program)
            .withLatestFrom(programsRelay) { (new, programs) -> [Program] in
                let willBeReturned = programs + [new]
                return willBeReturned
            }
            .bind(to: programsRelay)
            .disposed(by: disposeBag)
        
        programsRepository.saveProgram(program)
    }
    
    func returnViewModelAt(_ index: Int) -> Program {
        let program = programsRelay.value[index]
        return .init(exercises: program.exercises, title: program.title)
    }
    
    func deleteProgram(_ index: Int) {
        let willBeDeleted = programsRelay.value[index]
        programsRepository.deleteProgram(willBeDeleted)
        Observable<Program>
            .just(willBeDeleted)
            .withLatestFrom(programsRelay) { (new, programs) -> [Program] in
                programs.filter { new.title != $0.title }
            }
            .bind(to: programsRelay)
            .disposed(by: disposeBag)
    }
    
}







