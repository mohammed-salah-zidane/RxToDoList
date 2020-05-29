//
//  TaskListViewController.swift
//  GoodList
//
//  Created by prog_zidane on 5/29/20.
//  Copyright © 2020 Prog Zidane. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
class TaskListViewController: UIViewController{
    
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    private let disposeBag = DisposeBag()
    private var tasks = BehaviorRelay<[Task]>(value: [])
    private var filteredTask = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navVC = segue.destination as? UINavigationController,let addVC = navVC.viewControllers.first as? AddTaskViewController else {
            return
        }
        
        addVC.taskSubjectObservable.subscribe(onNext: { [weak self] task in
            guard let self = self else {return}
            
            let priority = Priority(rawValue: self.prioritySegmentedControl.selectedSegmentIndex - 1)
            var existingTasks = self.tasks.value
            existingTasks.append(task)
            self.tasks.accept(existingTasks)
            self.filterTasks(by: priority)
            }).disposed(by: disposeBag)
    }
    
    @IBAction func priorityChangedValue(segmentedControll:UISegmentedControl){
        let priority = Priority(rawValue: segmentedControll.selectedSegmentIndex - 1)
        self.filterTasks(by: priority)
    }
}
extension TaskListViewController{
    private func filterTasks(by priority:Priority?){
        guard let priority = priority else {
            self.filteredTask = self.tasks.value
            self.tableView.reloadData()
            return
        }
        self.tasks.map({ task in
            return task.filter{ $0.priority == priority}
        }).subscribe(onNext:{ tasks in
            self.filteredTask = tasks
            self.tableView.reloadData()
            }).disposed(by: disposeBag)
    }
}
extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath)
        cell.textLabel?.text = filteredTask[indexPath.row].title
        return cell
        
    }
}
