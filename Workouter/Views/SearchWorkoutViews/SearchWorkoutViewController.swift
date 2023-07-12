//
//  SearchWorkoutViewController.swift
//  Workouter
//
//  Created by 이종현 on 2023/04/12.
//

import UIKit
import RxCocoa
import RxSwift

final class SearchWorkoutViewController: BaseViewController, KeyboardProtocol, Alertable {
    
    var searchBar = UISearchBar()
    
    // VM 관련 property
    private let viewModel = SearchViewModel()
    
    // 해당 뷰가 사라질 때 Search하며 추가했던 운동들을 다시 AddProgramView로 보냄
    var passWorkoutList: (([Workout]) -> Void) = { _ in }
    
    private lazy var customView: SearchWorkoutUIView = SearchWorkoutUIView()
    
    override func loadView() {
        view = customView
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        passWorkoutList(viewModel.addedWorkoutList.value)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupRxBind() {
        
        customView.buttons.forEach { button in
            button.rx.tap
                .bind {
                    self.viewModel.targetButtonTapped(title: button.currentTitle)
                    self.searchBar.text = "" // 부위 카테코리가 변하면 searchBar는 자동으로 비어진다.
                }
                .disposed(by: disposeBag)
        }
        
        viewModel.bodyPartStr
            .bind { str in
                self.customView.buttons.forEach { button in
                    if button.currentTitle == str {
                        button.backgroundColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
                    } else {
                        button.backgroundColor = .opaqueSeparator
                    }
                }
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.text
            .orEmpty
            .debounce(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: viewModel.searchBarStr)
            .disposed(by: disposeBag)
        
        viewModel.totalWorkouts
            .map{ $0.count }
            .bind { count in
                count.isZero ?
                self.customView.tableView.setEmptyMessage("Loading...") :
                self.customView.tableView.restore()
            }
            .disposed(by: disposeBag)
        
        viewModel.workoutErrorSubject
            .bind {
                switch $0 as? NetworkError {
                case .retryError:
                    // TODO: retry 로직 추가
                    print("should retry")
                case .maxRequest:
                    let okAction = UIAlertAction(title: "OK", style: .default) {_ in
                        // Pop the current view controller
                        self.navigationController?.popViewController(animated: true)
                    }
                    self.showAlert(title: self.viewModel.errorTitle, message: self.viewModel.errorMessage, actions: [okAction])
                case .none:
                    break;
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.filteredWorkouts
            .bind(to: customView.tableView.rx.items(cellIdentifier: Identifier.searchWorkoutTableViewCell,
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
                    let vc = AddWorkoutViewController(exercise: item)
                    vc.addButtonTapped = { [weak self] exercise in
                        self?.viewModel.exerciseAdded(exercise)
                    }
                    self?.present(vc, animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
    
    override func setupUI() {
        customView.tableView.register(SearchWorkoutTableViewCell.self, forCellReuseIdentifier: Identifier.searchWorkoutTableViewCell)
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
//// MARK: - UI
//extension SearchWorkoutViewController {
//
//    private func targetButtonTapped(_ sender: UIButton) {
//        // TODO: customview에서부터 binding시켜서 vm으로 넘겨야함.
//        viewModel.targetButtonTapped(title: <#T##String?#>)
//        searchBar.text = "" // 부위 카테코리가 변하면 searchBar는 자동으로 비어진다.
//        customView.buttons.forEach { button in
//            if button.currentTitle ==  sender.currentTitle {
//                button.backgroundColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
//            } else {
//                button.backgroundColor = .opaqueSeparator
//            }
//        }
//    }
//
//}

// MARK: - RX 관련

//extension SearchWorkoutViewController {
//
//    func filterExercise(query: String, exercise: Exercise) -> Bool {
//        let lowerQuery = query.lowercased()
//        let equipment = exercise.equipment?.lowercased() ?? ""
//        if query.isEmpty || exercise.name.lowercased().contains(lowerQuery) || equipment.contains(lowerQuery) || exercise.target.rawValue.lowercased().contains(lowerQuery) {
//            return true
//        } else {
//            return false
//        }
//
//    }
//}
