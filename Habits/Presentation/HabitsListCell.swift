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
    
    let buttonOne: UIButton = {
        let configuration = UIImage.SymbolConfiguration(pointSize: 40)
        let image = UIImage(systemName: "circle.square", withConfiguration: configuration)
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        
        return button
    }()
    
    let buttonTwo: UIButton = {
        let configuration = UIImage.SymbolConfiguration(pointSize: 40)
        let image = UIImage(systemName: "circle.square", withConfiguration: configuration)
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        
        return button
    }()
    
    let buttonThree: UIButton = {
        let configuration = UIImage.SymbolConfiguration(pointSize: 40)
        let image = UIImage(systemName: "circle.square", withConfiguration: configuration)
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true

        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addSubview(idLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(buttonOne)
        contentView.addSubview(buttonTwo)
        contentView.addSubview(buttonThree)
        
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
            buttonOne.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 10),
            buttonOne.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -100),
            
            buttonTwo.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 10),
            buttonTwo.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0),
            
            buttonThree.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 10),
            buttonThree.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 100),
        ])
    }
}
