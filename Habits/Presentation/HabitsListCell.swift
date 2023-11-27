//
//  HabitsListCell.swift
//  Habits
//
//  Created by mihail on 25.11.2023.
//

import UIKit

class HabitsListCell: UITableViewCell {
    static let identifier = "HabitsListCell"
    
    let idLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .left
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
        contentView.addSubview(idLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(switchOne)
        contentView.addSubview(switchTwo)
        contentView.addSubview(switchThree)
        
        addConstraints()
    }
    
}

private extension HabitsListCell {
    func addConstraints() {
        NSLayoutConstraint.activate([
        ])
        
        NSLayoutConstraint.activate([
            idLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            idLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            idLabel.widthAnchor.constraint(equalToConstant: 40),
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: idLabel.trailingAnchor, constant: 10),
            
        ])
        
        NSLayoutConstraint.activate([
            switchOne.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 10),
            switchOne.leadingAnchor.constraint(equalTo: idLabel.trailingAnchor, constant: 10),
            switchOne.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1.0/3.0, constant: -idLabel.bounds.width ),
            switchTwo.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 10),
            switchTwo.leadingAnchor.constraint(equalTo: switchOne.trailingAnchor, constant: 10),
            switchTwo.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1.0/3.0, constant: -idLabel.bounds.width  ),
            switchThree.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 10),
            switchThree.leadingAnchor.constraint(equalTo: switchTwo.trailingAnchor, constant: 10),
            switchThree.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1.0/3.0, constant: -idLabel.bounds.width),
        ])
    }
}
