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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chestButton: UIButton!
    @IBOutlet weak var lowerLegsButton: UIButton!
    @IBOutlet weak var shouldersButton: UIButton!
    @IBOutlet weak var upperArmsButton: UIButton!
    @IBOutlet weak var upperLegButton: UIButton!
    @IBOutlet weak var lowerArmsButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    private lazy var buttons: [UIButton] = [chestButton, lowerLegsButton, shouldersButton, upperArmsButton, upperLegButton, lowerArmsButton, backButton]
    // VM 관련 property
    private let searchVM = SearchViewModel("chest")
    private var disposeBag = DisposeBag()
    // 몇 번째 셀의 데이터를 AddWorkoutView에 보낼 건지
    private var cellIndex: Int = 0
    // 해당 뷰가 사라질 때 Search하며 추가했던 운동들을 다시 AddProgramView로 보냄
    var addedWorkoutList: [ExerciseViewModel] = []
    var passWorkoutList: (([ExerciseViewModel]) -> Void) = { _ in } 
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        passWorkoutList(addedWorkoutList)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupBinding()
    }
    
    @IBAction func targetButtonTapped(_ sender: UIButton) {
        self.title = sender.currentTitle?.capitalized
        searchVM.changeExercise(sender.currentTitle ?? "chest")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifier.toAddWorkoutViewController {
            let vc = segue.destination as! AddWorkoutViewController
            vc.exerciseVM = ExerciseViewModel(exercise: searchVM.exerciseByIndex(cellIndex))
            vc.addedWorkout = { [weak self] addedWorkout in
                self?.addedWorkoutList.append(addedWorkout)
            }
        }
    }
    
}

// MARK: - UI
extension SearchWorkoutViewController {
    func setupUI() {
        buttons.forEach { button in
            button.frame = CGRect(x: 160, y: 100, width: 30, height: 30)
            button.layer.cornerRadius = 0.5 * button.bounds.size.width
            button.clipsToBounds = true
        }
    }
}

// MARK: - RX 관련

extension SearchWorkoutViewController {
    func setupBinding() {
        searchVM.workoutsRelay
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: Identifier.searchWorkoutTableViewCell, cellType: SearchWorkoutTableViewCell.self)) { index, item, cell in
                // gif 변환하는 과정이 너무 느려서 일단 다른 것들 업로드 하고 마지막에 변환시켜줌.
                UIImage.gifImageWithURL(item.gifUrl!) { img in
                    DispatchQueue.main.async {
                        cell.workoutImageView.image = img
                    }
                }
                cell.nameLabel.text = item.name.capitalized
                cell.targetLabel.text = item.target.rawValue.capitalized
                cell.equipmentLabel.text = item.equipment?.capitalized
                cell.plusButtonTapped = { [weak self] in
                    self?.cellIndex = index
                    self?.performSegue(withIdentifier: Identifier.toAddWorkoutViewController, sender: self)
                }
            }
            .disposed(by: disposeBag)
        
        searchVM.workoutsRelay
            .asDriver(onErrorJustReturn: [])
            .map({ $0.count })
            .drive(onNext: { [weak self] count in
                if count.isZero {
                    self?.tableView.setEmptyMessage("Loading...")
                } else {
                    self?.tableView.restore()
                }
            })
            .disposed(by: disposeBag)
    }
    
}


// MARK: - Table View
extension SearchWorkoutViewController: UITableViewDelegate {

    func setupTableView() {
        tableView.delegate = self
        tableView.allowsSelection = false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}

