//
//  MainViewController.swift
//  SageSay
//
//  Created by Eldar Tutnjic on 1. 6. 2023..
//

import UIKit

class MainViewController: UIViewController {

    let quoteText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name: "Avenir-Light", size: 20)
        label.textColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
        }
        return label
    }()
    
    let quoteAuthor: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont(name: "Avenir-Black", size: 17)
        label.textColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
        }
        return label
    }()
    
    let generateBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        button.addTarget(self, action: #selector(generateQuoteBtn), for: .touchUpInside)
        button.tintColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
        }
        return button
    }()
    
    var settingsButton = UIBarButtonItem()
    var viewModel = QuotesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .dark ? UIColor.black : UIColor.white
        }
        
        UNUserNotificationCenter.current().delegate = self
        
        view.addSubview(quoteText)
        view.addSubview(quoteAuthor)
        view.addSubview(generateBtn)
        setupConstraints()

        settingsButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(handleSettingsButton))
        navigationItem.rightBarButtonItem = settingsButton
        
    }
    
    @objc func generateQuoteBtn(_ sender: Any) {
        getQuotes()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            quoteText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            quoteText.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            quoteText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            quoteText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            
            quoteAuthor.topAnchor.constraint(equalTo: quoteText.bottomAnchor, constant: 20),
            quoteAuthor.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            
            generateBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            generateBtn.topAnchor.constraint(equalTo: quoteAuthor.bottomAnchor, constant: 20),
            generateBtn.widthAnchor.constraint(equalToConstant: 50),
            generateBtn.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func getQuotes() {
        viewModel.fetchQuotes { [weak self] quotes in
            DispatchQueue.main.async {
                let randomQuote = quotes.randomElement()
                self?.quoteText.text = randomQuote?.text
                self?.quoteAuthor.text = randomQuote?.author
            }
        }
    }
    
    @objc func handleSettingsButton() {
        let settingsVC = SettingsViewController()
        present(settingsVC, animated: true, completion: nil)
    }
    
    func setNotification(_ components: DateComponents) {
        scheduleQuoteNotification(time: components)
    }
    
    func scheduleQuoteNotification(time: DateComponents) {
        let content = UNMutableNotificationContent()
        content.title = "Daily Quote"
        content.body = "Here is your daily quote!"
        content.sound = UNNotificationSound.default

        var dateComponents = DateComponents()
        dateComponents.hour = UserDefaults.standard.integer(forKey: "NotificationHour")
        dateComponents.minute = UserDefaults.standard.integer(forKey: "NotificationMinute")

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            } else {
                print("Notification scheduled successfully")
            }
        }
    }


}

extension MainViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
