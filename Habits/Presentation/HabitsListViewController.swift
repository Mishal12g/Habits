import UIKit
import ProgressHUD

class HabitsListViewController: UIViewController {
    
    //MARK: - Private parametrs
    private let habitsService = HabitsService()
    private var list: [HabitResult] = []
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    //MARK: - Overrides methods
    override func viewDidLoad() {
        super.viewDidLoad()
        UIProgressHUD.show()
        view.backgroundColor = .gray
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
        habitsService.fetchHabits() { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let list):
                self.list = list
                UIProgressHUD.dismiss()
                tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func makeRequest(bool: Bool, boolName: Bools, indexPath: IndexPath) {
        habitsService.changeCheckmark(id: indexPath.row + 1, bool: bool, boolName: boolName) {[weak self] result in
            guard self != nil else { return }
            UIProgressHUD.show()
            switch result {
            case .success:
                UIProgressHUD.dismiss()
            case .failure:
                print("failure HandleHabits")
            }
        }
    }
    
    //MARK: - Actions Methods
    private func configCell(cell: HabitsListCell, indexPath: IndexPath) {
        setImage(list[indexPath.row].bool1, button: cell.buttonOne)
        setImage(list[indexPath.row].bool2, button: cell.buttonTwo)
        setImage(list[indexPath.row].bool3, button: cell.buttonThree)
        let action = UIAction() { [weak self] _ in
            guard let self = self else { return }
//            makeRequest(bool: <#T##Bool#>, boolName: <#T##Bools#>, indexPath: <#T##IndexPath#>)
        }
        
        cell.buttonOne.addAction(action, for: .touchUpInside)
        //        cell.buttonOne.addTarget(nil, action: #selector(buttonAction), for: .touchUpInside)
        //        cell.buttonTwo.addTarget(nil, action: #selector(buttonAction), for: .touchUpInside)
        //        cell.buttonThree.addTarget(nil, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    private func setImage(_ bool: Bool, button: UIButton) {
        let configuration = UIImage.SymbolConfiguration(pointSize: 40)
        if bool {
            button.setImage(UIImage(systemName: "checkmark.circle.fill", withConfiguration: configuration), for: .normal)
            button.tintColor = .systemGreen
        } else {
            button.setImage(UIImage(systemName: "circle", withConfiguration: configuration), for: .normal)
            button.tintColor = .systemBlue
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
        configCell(cell: habitsListCell, indexPath: indexPath)
        
        //        if list[indexPath.row].bool1 == true {
        //            habitsListCell.switchOne.isOn = true
        //        } else {
        //            habitsListCell.switchOne.isOn = false
        //        }
        //
        //        if list[indexPath.row].bool2 == true {
        //            habitsListCell.switchTwo.isOn = true
        //        } else {
        //            habitsListCell.switchTwo.isOn = false
        //        }
        //
        //        if list[indexPath.row].bool3 == true {
        //            habitsListCell.switchThree.isOn = true
        //        } else {
        //            habitsListCell.switchThree.isOn = false
        //        }
        
//                habitsListCell.switchOne.addTarget(self, action: #selector(switchOneValueChanged), for: .valueChanged)
        //        habitsListCell.switchTwo.addTarget(self, action: #selector(switchTwoValueChanged), for: .valueChanged)
        //        habitsListCell.switchThree.addTarget(self, action: #selector(switchThreeValueChanged), for: .valueChanged)
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
