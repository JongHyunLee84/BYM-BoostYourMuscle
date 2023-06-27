//
//  SearchWorkoutViewController.swift
//  Workouter
//
//  Created by 이종현 on 2023/04/12.
//

import UIKit
import RxCocoa
import RxSwift

final class SearchWorkoutViewController: BaseViewController, KeyboardProtocol {
    var searchBar = UISearchBar()
    
    // VM 관련 property
    private let searchVM = SearchViewModel()
    
    // 해당 뷰가 사라질 때 Search하며 추가했던 운동들을 다시 AddProgramView로 보냄
    var addedWorkoutList: [ExerciseViewModel] = []
    var passWorkoutList: (([ExerciseViewModel]) -> Void) = { _ in }
    
    private lazy var customView: SearchWorkoutUIView = SearchWorkoutUIView()
    
    override func loadView() {
        view = customView
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        passWorkoutList(addedWorkoutList)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupRxBind() {
        searchVM.workoutsRelay
            .map({ $0.count })
            .subscribe(onNext: { [weak self] count in
                if count.isZero {
                    self?.customView.tableView.setEmptyMessage("Loading...")
                } else {
                    self?.customView.tableView.restore()
                }
            })
            .disposed(by: disposeBag)
        
        searchVM.workoutErrorSubject
            .subscribe(onNext: {
                switch $0 as? NetworkError {
                case .retryError:
                    print("should retry")
                case .maxRequest:
                    print("should tell max request")
                case .none:
                    break;
                }
            })
            .disposed(by: disposeBag)
        
        searchBar.rx.text
            .orEmpty
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
            .subscribe(onNext: { [weak self] str in
                self?.searchVM.bodyPartStr.onNext(str)
            })
            .disposed(by: disposeBag)
        
        searchVM.bodyPartRelay
            .asDriver(onErrorJustReturn: [])
            .drive(customView.tableView.rx.items(cellIdentifier: Identifier.searchWorkoutTableViewCell,
                                                 cellType: SearchWorkoutTableViewCell.self)) { index, item, cell in
                UIImage.gifImageWithURL(item.gifUrl ?? "") { img in
                    DispatchQueue.main.async {
                        cell.workoutImageView.image = img
                    }
                }
                cell.nameLabel.text = item.name.capitalized
                cell.targetLabel.text = item.target.rawValue.capitalized
                cell.equipmentLabel.text = item.equipment?.capitalized
                cell.plusButtonAction = { [weak self] in
                    self?.searchVM.exercise = item
                    let vc = AddWorkoutViewController()
                    vc.exerciseVM = ExerciseViewModel(exercise: self?.searchVM.exercise ?? Exercise())
                    vc.addedWorkout = { [weak self] addedWorkout in
                        self?.addedWorkoutList.append(addedWorkout)
                    }
                    self?.present(vc, animated: true)
                }
            }
                                                 .disposed(by: disposeBag)
    }
    
    override func setupUI() {
        customView.tableView.register(SearchWorkoutTableViewCell.self, forCellReuseIdentifier: Identifier.searchWorkoutTableViewCell)
        customView.buttonTappedAction = targetButtonTapped(_:)
        setupKeyborad(self.view)
        setupSearchBar()
    }
    
}

// MARK: - SearchBar 관련
extension SearchWorkoutViewController: UISearchBarDelegate {
    
    private func setupSearchBar() {
        navigationItem.titleView = searchBar
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func didTapView() {
        searchBar.resignFirstResponder()
    }
    
}
// MARK: - UI
extension SearchWorkoutViewController {
    
    private func targetButtonTapped(_ sender: UIButton) {
        // TODO: 원래 change 메서드 사용했던 것 바꿔야함.
        searchVM.bodyPartStr.onNext(sender.currentTitle ?? "all")
        customView.buttons.forEach { button in
            if button.currentTitle ==  sender.currentTitle {
                button.backgroundColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
            } else {
                button.backgroundColor = .opaqueSeparator
            }
        }
    }
    
}

// MARK: - RX 관련

extension SearchWorkoutViewController {
    
    func filterExercise(query: String, exercise: Exercise) -> Bool {
        let lowerQuery = query.lowercased()
        let equipment = exercise.equipment?.lowercased() ?? ""
        if query.isEmpty || exercise.name.lowercased().contains(lowerQuery) || equipment.contains(lowerQuery) || exercise.target.rawValue.lowercased().contains(lowerQuery) {
            return true
        } else {
            return false
        }
        
    }
}


// Rx 버전으로 만들어봄
//                if let gifUrl = item.gifUrl {
//                    UIImage.gifImageWithURL(gifUrl)
//                        .asDriver(onErrorJustReturn: nil)
//                        .drive(cell.workoutImageView.rx.image)
//                        .disposed(by: self.disposeBag)
//                }
//                이미 다 UIImage로 변환됐다면 아래 코드
//                cell.workoutImageView.image = item.gif
//                 gif 변환하는 과정이 너무 느려서 일단 다른 것들 업로드 하고 마지막에 변환시켜줌.
