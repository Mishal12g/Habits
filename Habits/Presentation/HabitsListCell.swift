//
//  HabitsListCell.swift
//  Habits
//
//  Created by mihail on 25.11.2023.
//

import UIKit

class HabitsListCell: UITableViewCell {
    static let identifier = "HabitsListCell"
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "dsadasd"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    let switchOne: UISwitch = {
        let uiSwitch = UISwitch()
        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        return uiSwitch
    }()
    
    let switchTwo: UISwitch = {
        let uiSwitch = UISwitch()
        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        return uiSwitch
    }()
    
    let switchThree: UISwitch = {
        let uiSwitch = UISwitch()
        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        return uiSwitch
    }()
    
    override func layoutSubviews() {
          super.layoutSubviews()
        contentView.addSubview(label)
        contentView.addSubview(switchOne)
        contentView.addSubview(switchTwo)
        contentView.addSubview(switchThree)
        addConstraints()
      }
}

private extension HabitsListCell {
    func addConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            switchOne.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 10),
            switchOne.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            switchTwo.leadingAnchor.constraint(equalTo: switchOne.trailingAnchor, constant: 10),
            switchTwo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            switchThree.leadingAnchor.constraint(equalTo: switchTwo.trailingAnchor, constant: 10),
            switchThree.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
        ])
    }
}
