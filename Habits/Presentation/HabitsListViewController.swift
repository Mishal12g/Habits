//
//  ViewController.swift
//  Habits
//
//  Created by mihail on 25.11.2023.
//

import UIKit

class HabitsListViewController: UIViewController {

    //MARK: - Private parametrs
    private let habitsLoadingService = HabitsLoading()
    private let habitsService = HabitsService()
    private var list: [Habit] = []
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    //MARK: - Overrides methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        tableView.rowHeight = 100
        tableView.contentInset = UIEdgeInsets.zero
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        setupTableView()
        addContraints()
        loadHabits()
        
    }
}

//MARK: - for methods
private extension HabitsListViewController {
    func addContraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
        ])
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HabitsListCell.self, forCellReuseIdentifier: HabitsListCell.identifier)
    }
    
    func loadHabits() {
        habitsLoadingService.fetchHabits() { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let list):
                self.list = list
                tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func makeRequest(bool: Bool, boolName: Bools, indexPath: IndexPath) {
        habitsService.changeSwitch(id: indexPath.row + 1, bool: bool, boolName: boolName) {[weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.loadHabits()
                self.tableView.reloadData()
                print(indexPath.row)
            case .failure:
                print("failure HandleHabits")
            }
        }
    }
    
    //MARK: - Actions Methods
    @objc private func switchOneValueChanged(_ sender: UISwitch) {
        guard let cell = sender.superview?.superview as? HabitsListCell, let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        if cell.switchOne.isOn {
            makeRequest(bool: true, boolName: Bools.bool1, indexPath: indexPath)
            
        } else {
            makeRequest(bool: false, boolName: Bools.bool1, indexPath: indexPath)
        }
    }
    
    @objc private func switchTwoValueChanged(_ sender: UISwitch) {
        guard let cell = sender.superview?.superview as? HabitsListCell, let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        if cell.switchTwo.isOn {
            makeRequest(bool: true, boolName: Bools.bool2, indexPath: indexPath)
            
        } else {
            makeRequest(bool: false, boolName: Bools.bool2, indexPath: indexPath)
        }
    }
    
    @objc private func switchThreeValueChanged(_ sender: UISwitch) {
        guard let cell = sender.superview?.superview as? HabitsListCell, let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        if cell.switchThree.isOn {
            makeRequest(bool: true, boolName: Bools.bool3, indexPath: indexPath)
            
        } else {
            makeRequest(bool: false, boolName: Bools.bool3, indexPath: indexPath)
        }
    }
}

//MARK: - Delegats
extension HabitsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HabitsListCell.identifier, for: indexPath)
        
        guard let habitsListCell = cell as? HabitsListCell else {
            return UITableViewCell()
        }
        
        if list[indexPath.row].bool1 == true {
            habitsListCell.switchOne.isOn = true
        } else {
            habitsListCell.switchOne.isOn = false
        }
        
        if list[indexPath.row].bool2 == true {
            habitsListCell.switchTwo.isOn = true
        } else {
            habitsListCell.switchTwo.isOn = false
        }
        
        if list[indexPath.row].bool3 == true {
            habitsListCell.switchThree.isOn = true
        } else {
            habitsListCell.switchThree.isOn = false
        }
        
        habitsListCell.switchOne.addTarget(self, action: #selector(switchOneValueChanged), for: .valueChanged)
        habitsListCell.switchTwo.addTarget(self, action: #selector(switchTwoValueChanged), for: .valueChanged)
        habitsListCell.switchThree.addTarget(self, action: #selector(switchThreeValueChanged), for: .valueChanged)
        
        habitsListCell.idLabel.text = "\(indexPath.row + 1)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = dateFormatter.date(from: list[indexPath.row].date)
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "EEEE, d MMMM yyyy"
        
        let formattedDate = dateFormatter.string(for: date)
        
        habitsListCell.dateLabel.text = formattedDate
        
        return habitsListCell
    }
}
