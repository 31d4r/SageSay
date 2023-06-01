//
//  SettingsViewController.swift
//  SageSay
//
//  Created by Eldar Tutnjic on 1. 6. 2023..
//

import UIKit

class SettingsViewController: UIViewController {
    
    var datePicker: UIDatePicker!
    var saveButton: UIButton!
    var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        setupConstraints()
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        view.addSubview(datePicker)
        
        saveButton = UIButton(type: .system)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveSettings), for: .touchUpInside)
        view.addSubview(saveButton)
        
        infoLabel = UILabel()
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.text = "Please setup the time at which you want to receive a quote"
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0
        infoLabel.textColor = traitCollection.userInterfaceStyle == .dark ? .white : .black
        view.addSubview(infoLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            datePicker.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 20),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func saveSettings() {
        let components = Calendar.current.dateComponents([.hour, .minute], from: datePicker.date)
        
        UserDefaults.standard.set(components.hour, forKey: "NotificationHour")
        UserDefaults.standard.set(components.minute, forKey: "NotificationMinute")
        
        (presentingViewController as? MainViewController)?.setNotification(components)
        
        dismiss(animated: true, completion: nil)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.userInterfaceStyle == .dark {
            infoLabel.textColor = .white
        } else {
            infoLabel.textColor = .black
        }
    }
}

