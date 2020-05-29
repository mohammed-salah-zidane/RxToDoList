//
//  AddTaskViewController.swift
//  GoodList
//
//  Created by prog_zidane on 5/29/20.
//  Copyright © 2020 Prog Zidane. All rights reserved.
//

import Foundation
import UIKit
import RxSwift


class AddTaskViewController: UIViewController {
    
    
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    @IBOutlet weak var taskTitleTextField: UITextField!
    
    private let taskSubject = PublishSubject<Task>()
    var taskSubjectObservable : Observable<Task>{
        return taskSubject.asObservable()
    }
    @IBAction func save() {
        
        guard let priority = Priority(rawValue: self.prioritySegmentedControl.selectedSegmentIndex),
            let title = self.taskTitleTextField.text else {
                return
        }
        
        let task = Task(title: title, priority: priority)
        taskSubject.onNext(task)
        self.dismiss(animated: true, completion: nil)
    }
    
}
