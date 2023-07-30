//
//  ViewController.swift
//  LocalNotificationDemo
//
//  Created by YE002 on 17/07/23.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    @IBOutlet var notificationTitle: UITextField!
    @IBOutlet var notificationDescription: UITextField!
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    
    @IBOutlet var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { permissionGranted, error in
            if !permissionGranted
            {
                print("Permission Denied")
            }
        }
        
    }

    @IBAction func scheduleButtonPressed(_ sender: UIButton) {
        print("Button tapped")
        notificationCenter.getNotificationSettings { settings in
            
            DispatchQueue.main.async {
                let title = self.notificationTitle.text!
                let description = self.notificationDescription.text!
                let date = self.datePicker.date
                
                if (settings.authorizationStatus == .authorized)
                {
                    let content = UNMutableNotificationContent()
                    content.title = title
                    content.body = description
                    
                    let dateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
                    
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
                    
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    
                    self.notificationCenter.add(request) { error in
                        if error != nil
                        {
                            print("Error " + error.debugDescription)
                            return
                        }
                    }
                    let ac = UIAlertController(title: "Notification Scheduled", message: "At " + self.formattedDate(date: date), preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in }))
                    self.present(ac, animated: true)
                    
                }
                else
                {
                    let ac = UIAlertController(title: "Enable Notifications?", message: "To use this feature you must enable notifications in settings", preferredStyle: .alert)
                    let goToSettings = UIAlertAction(title: "Settings", style: .default) { _ in
                        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {return}
                        
                        if UIApplication.shared.canOpenURL(settingsURL)
                        {
                            UIApplication.shared.open(settingsURL) { _ in}
                        }
                    }
                    ac.addAction(goToSettings )
                    ac.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in }))
                    self.present(ac, animated: true)
                }
            }
        }
    }
    
    func formattedDate(date: Date) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y HH:mm"
        return formatter.string(from: date)
    }
    
}

