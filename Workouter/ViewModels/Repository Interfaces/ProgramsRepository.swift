//
//  ProgramsRepository.swift
//  Workouter
//
//  Created by 이종현 on 2023/07/04.
//

import RxSwift

protocol ProgramsRepository {
    func saveProgram(_ program: Program)
    func fetchPrograms() -> Observable<[Program]>
    func deleteProgram(_ program: Program)
    func updateProgram(_ program: Program)
}
