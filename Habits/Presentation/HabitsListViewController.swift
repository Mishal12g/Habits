import UIKit
import ProgressHUD

class HabitsListViewController: UIViewController {
    //MARK: - Static prarametrs
    static let dateFormatter = DateFormatter()
    
    //MARK: - Private parametrs
    private let habitsService = HabitsService()
    private var habits: [HabitResult] = []
    private var habitsServiceObserver: NSObjectProtocol?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    //MARK: - Overrides methods
    override func viewDidLoad() {
        super.viewDidLoad()
        UIProgressHUD.show()
        view.backgroundColor = .gray
        
        setupTableView()
        addContraints()
        habitsService.fetchHabits()
        habitsServiceObserver = NotificationCenter.default.addObserver(forName: HabitsService.didChangeNotification,
                                                                       object: nil,
                                                                       queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.updateHabitsViewTable()
        }
    }
}

//MARK: - for methods
extension HabitsListViewController {
    //MARK: - Privates methods
    private func updateHabitsViewTable() {
        UIProgressHUD.dismiss()
        habits = habitsService.habits
        tableView.reloadData()
    }
    
    private func addContraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
        ])
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.contentInset = UIEdgeInsets.zero
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HabitsListCell.self, forCellReuseIdentifier: HabitsListCell.identifier)
    }
    
    private func configCell(cell: HabitsListCell) {
        guard let index = tableView.indexPath(for: cell) else { return }
        setImage(habits[index.row].bool1, boolsName: .bool1, button: cell.buttonOne)
        setImage(habits[index.row].bool2, boolsName: .bool2, button: cell.buttonTwo)
        setImage(habits[index.row].bool3, boolsName: .bool3, button: cell.buttonThree)
        cell.selectionStyle = .none
        cell.delegate = self
    }
    
    private func setImage(_ bool: Bool, boolsName: Bools, button: UIButton) {
        
        let configuration = UIImage.SymbolConfiguration(pointSize: 40)
        if bool {
            button.setImage(UIImage(systemName: "checkmark.circle.fill", withConfiguration: configuration), for: .normal)
            button.tintColor = boolsName == .bool1 ? .systemGreen : .systemRed
        } else {
            button.setImage(UIImage(systemName: "circle", withConfiguration: configuration), for: .normal)
            button.tintColor = .systemBlue
        }
    }
}

//MARK: - HabitlistCell delegate
extension HabitsListViewController: HabitsListCellDelegate {
    func habitsListCellDidTapButtonOne(cell: HabitsListCell) {
        guard let index = tableView.indexPath(for: cell) else { return }
        
        makeRequestForButtons(cell: cell, bool: habits[index.row].bool1, boolName: Bools.bool1)
    }
    
    func habitsListCellDidTapButtonTwo(cell: HabitsListCell) {
        guard let index = tableView.indexPath(for: cell) else { return }
        
        makeRequestForButtons(cell: cell, bool: habits[index.row].bool2, boolName: Bools.bool2)
    }
    
    func habitsListCellDidTapButtonThree(cell: HabitsListCell) {
        guard let index = tableView.indexPath(for: cell) else { return }
        
        makeRequestForButtons(cell: cell, bool: habits[index.row].bool3, boolName: Bools.bool3)
    }
    
    func makeRequestForButtons(cell: HabitsListCell, bool: Bool, boolName: Bools) {
        guard let index = tableView.indexPath(for: cell) else { return }
        let model: ActionModel?
        switch boolName {
        case .bool1:
            model = ActionModel(id: index.row + 1, bool1: !bool)
        case .bool2:
            model = ActionModel(id: index.row + 1, bool2: !bool)
        case .bool3:
            model = ActionModel(id: index.row + 1, bool3: !bool)
        }
        
        guard let model = model else { return }
        
        UIProgressHUD.show()
        habitsService.changeCheckmark(model: model,
                                      boolName: boolName) { [weak self] in
            guard let self = self else { return }
            UIProgressHUD.dismiss()
            self.habits = self.habitsService.habits
            tableView.reloadRows(at: [index], with: .automatic)
        }
    }
}

//MARK: - Delegats UI Table View
extension HabitsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        habits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HabitsListCell.identifier, for: indexPath)
        
        guard let habitsListCell = cell as? HabitsListCell else {
            return UITableViewCell()
        }
        
        habitsListCell.buttonOne.removeTarget(nil, action: nil, for: .allEvents)
        habitsListCell.buttonTwo.removeTarget(nil, action: nil, for: .allEvents)
        habitsListCell.buttonThree.removeTarget(nil, action: nil, for: .allEvents)
        
        configCell(cell: habitsListCell)
        
        habitsListCell.idLabel.text = "\(indexPath.row + 1)"
        
        
        HabitsListViewController.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = HabitsListViewController.dateFormatter.date(from: habits[indexPath.row].date)
        HabitsListViewController.dateFormatter.locale = Locale(identifier: "ru_RU")
        HabitsListViewController.dateFormatter.dateFormat = "EEEE, d MMMM yyyy"
        
        let formattedDate = HabitsListViewController.dateFormatter.string(for: date)
        
        habitsListCell.dateLabel.text = formattedDate
        
        return habitsListCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
