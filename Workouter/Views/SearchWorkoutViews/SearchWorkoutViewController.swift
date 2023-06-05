//
//  SearchWorkoutViewController.swift
//  Workouter
//
//  Created by 이종현 on 2023/04/12.
//

import UIKit
import RxCocoa
import RxSwift

class SearchWorkoutViewController: UIViewController {
    var searchBar = UISearchBar()

    // VM 관련 property
    private let searchVM = SearchViewModel("chest")
    private var disposeBag = DisposeBag()

    // 해당 뷰가 사라질 때 Search하며 추가했던 운동들을 다시 AddProgramView로 보냄
    var addedWorkoutList: [ExerciseViewModel] = []
    var passWorkoutList: (([ExerciseViewModel]) -> Void) = { _ in }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        passWorkoutList(addedWorkoutList)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupUI()
        setupTableView()
        setupBinding()
        
    }

    
    @IBAction func targetButtonTapped(_ sender: UIButton) {
                searchVM.changeExercise(sender.currentTitle ?? "chest")
//        buttons.forEach { button in
//            if button.currentTitle ==  sender.currentTitle {
//                button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//            } else {
//                button.backgroundColor = .systemBackground
//            }
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifier.toAddWorkoutViewController {
            let vc = segue.destination as! AddWorkoutViewController
            vc.exerciseVM = ExerciseViewModel(exercise: searchVM.exercise ?? Exercise())
            vc.addedWorkout = { [weak self] addedWorkout in
                self?.addedWorkoutList.append(addedWorkout)
            }
        }
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
    func setupUI() {
        
        // 버튼 관련
//        chestButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//        buttons.forEach { button in
//            button.frame = CGRect(x: 160, y: 100, width: 30, height: 30)
//            button.layer.cornerRadius = 0.5 * button.bounds.size.width
//            button.clipsToBounds = true
//            // 버튼 테두리
//            button.layer.borderWidth = 2.0
//            button.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
//        }
    }
    
}

// MARK: - RX 관련

extension SearchWorkoutViewController {
    func setupBinding() {
//        searchVM.workoutsRelay
//            .asDriver(onErrorJustReturn: [])
//            .map({ $0.count })
//            .drive(onNext: { [weak self] count in
//                if count.isZero {
//                    self?.tableView.setEmptyMessage("Loading...")
//                } else {
//                    self?.tableView.restore()
//                }
//            })
//            .disposed(by: disposeBag)
//
//        searchBar.rx.text.orEmpty
//            .flatMap { [weak self] query in
//                return self?.searchVM.workoutsRelay
//                    .map { $0.filter { exercise in
//                        self?.filterExercise(query: query, exercise: exercise) ?? false
//                    }} ?? Observable<[Exercise]>.just([])
//            }
//            .asDriver(onErrorJustReturn: [])
//            .drive(tableView.rx.items(cellIdentifier: Identifier.searchWorkoutTableViewCell,
//                                      cellType: SearchWorkoutTableViewCell.self)) { index, item, cell in
//// Rx 버전으로 만들어봄
////                if let gifUrl = item.gifUrl {
////                    UIImage.gifImageWithURL(gifUrl)
////                        .asDriver(onErrorJustReturn: nil)
////                        .drive(cell.workoutImageView.rx.image)
////                        .disposed(by: self.disposeBag)
////                }
////                이미 다 UIImage로 변환됐다면 아래 코드
////                cell.workoutImageView.image = item.gif
////                 gif 변환하는 과정이 너무 느려서 일단 다른 것들 업로드 하고 마지막에 변환시켜줌.
//                UIImage.gifImageWithURL(item.gifUrl ?? "") { img in
//                    DispatchQueue.main.async {
//                        cell.workoutImageView.image = img
//                    }
//                }
//                cell.nameLabel.text = item.name.capitalized
//                cell.targetLabel.text = item.target.rawValue.capitalized
//                cell.equipmentLabel.text = item.equipment?.capitalized
//                cell.plusButtonAction = { [weak self] in
//                    self?.searchVM.exercise = item
//                    self?.performSegue(withIdentifier: Identifier.toAddWorkoutViewController, sender: self)
//                }
//            }
//            .disposed(by: disposeBag)
    }
    
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


// MARK: - Table View
extension SearchWorkoutViewController: UITableViewDelegate {
    
    func setupTableView() {
//        tableView.delegate = self
//        tableView.allowsSelection = false
//        tableView.register(SearchWorkoutTableViewCell.self, forCellReuseIdentifier: Identifier.searchWorkoutTableViewCell)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}


