//
//  ViewController.swift
//  Habits
//
//  Created by mihail on 25.11.2023.
//

import UIKit

class ViewController: UIViewController {
    private let service = HabitsService()
    private var list: [Habit] = []
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        setupTableView()
        addContraints()
        loadHabits()
    }
}

//MARK: - for methods
private extension ViewController {
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
        service.fetchHabits() { [weak self] result in
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
}

//MARK: - Delegats
extension ViewController: UITableViewDelegate, UITableViewDataSource {
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

        habitsListCell.label.text = "\(indexPath.row + 1)"
        
        return habitsListCell
    }
}
