//
//  SearchWorkoutViewController.swift
//  Workouter
//
//  Created by 이종현 on 2023/04/12.
//

import RxCocoa
import RxSwift
import UIKit

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
            .asDriver(onErrorJustReturn: 0)
            .drive { count in
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
                
                cell.passData(Workout(name: item.name, target: item.target, equipment: item.equipment ?? "", gif: #imageLiteral(resourceName: "imagePlaceholder")))
                UIImage.gifImageWithURL(item.gifUrl ?? "") { img in
                    guard let img = img else { return }
                    DispatchQueue.main.async {
                        cell.workoutImageView.image = img
                    }
                }
                cell.plusButton.rx.tap
                    .bind {
                        let vc = AddWorkoutViewController(workout: item)
                        vc.addButtonTapped = { [weak self] workout in
                            self?.viewModel.workoutAdded(workout)
                        }
                        self.present(vc, animated: true)
                    }
                    .disposed(by: self.disposeBag)
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
