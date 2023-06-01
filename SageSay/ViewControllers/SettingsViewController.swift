//
//  SettingsViewController.swift
//  SageSay
//
//  Created by Eldar Tutnjic on 1. 6. 2023..
//

import UIKit

class SettingsViewController: UIViewController {
    
    var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        return picker
    }()

    var soundPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save", for: .normal)
        button.tintColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
        }
        return button
    }()

    var infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Please setup the time at which you want to receive a quote"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name: "Avenir-Light", size: 20)
        label.textColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
        }
        return label
    }()

    var soundLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Select sound for notification:"
        label.font = UIFont(name: "Avenir-Light", size: 20)
        label.textColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
        }
        return label
    }()
    
    var sounds = ["Default", "Accent", "Alert", "Ping"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .dark ? UIColor.black : UIColor.white
        }
        
        setupUI()
        
        setupConstraints()
    }
    
    func setupUI() {
        view.addSubview(datePicker)
        view.addSubview(soundPicker)
        view.addSubview(saveButton)
        view.addSubview(infoLabel)
        view.addSubview(soundLabel)
        
        
        soundLabel.textColor = traitCollection.userInterfaceStyle == .dark ? .white : .black
        
        saveButton.addTarget(self, action: #selector(saveSettings), for: .touchUpInside)
        
        soundPicker.delegate = self
        soundPicker.dataSource = self
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
            
            soundLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            soundLabel.bottomAnchor.constraint(equalTo: soundPicker.topAnchor, constant: 20),
            soundLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            soundLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            soundPicker.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            soundPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            soundPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.topAnchor.constraint(equalTo: soundPicker.bottomAnchor, constant: 20),
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


extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sounds.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sounds[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UserDefaults.standard.set(sounds[row], forKey: "NotificationSound")
    }
}
