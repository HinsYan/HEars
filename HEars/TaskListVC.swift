//
//  TaskListVC.swift
//  HEars
//
//  Created by yantommy on 2017/6/23.
//  Copyright © 2017年 yantommy. All rights reserved.
//

import UIKit


class TaskListVC: UIViewController {

    @IBOutlet weak var tableTaskList: UITableView!
    
    
    
    var timerVC: HomeVC!
    var timerView: UIView!
    
    
    var panGesture: UIPanGestureRecognizer!
    var timerViewDefaultY: CGFloat = UIScreen.main.bounds.height - 60
    var timerViewLastY:CGFloat = UIScreen.main.bounds.height - 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableTaskList.delegate = self
        tableTaskList.dataSource = self

        
        timerVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        timerView = timerVC.view
        
        addChildViewController(timerVC)
        timerView.frame = view.bounds
        timerView.frame.origin.y = timerViewDefaultY
        timerViewLastY = timerView.frame.origin.y
        timerView.layoutIfNeeded()
        view.addSubview(timerView)
        
        timerView.layer.shadowColor = UIColor.black.cgColor
        timerView.layer.shadowOffset = CGSize(width: 0, height: -4)
        timerView.layer.shadowOpacity = 0.2
        timerView.layer.shadowRadius = 4
        
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.actionForPanGesture(_:)))
        timerView.addGestureRecognizer(panGesture)
        
        
        // Do any additional setup after loading the view.
    }

    
    func actionForPanGesture(_ sender: UIPanGestureRecognizer!) {
    
        
        let translateY = sender.translation(in: sender.view!).y
        let velocityY = sender.velocity(in: sender.view!).y
        
        switch sender.state {
        case .began:
            print("begin")
        case .changed:
            
            print(translateY)
            timerView.frame.origin.y = min(max(timerViewLastY + translateY,0.0), timerView.bounds.height)
            
        default:
            
            print(sender.velocity(in: sender.view!))
            
            UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.75, initialSpringVelocity: 1.0, options: [.curveEaseInOut,.allowUserInteraction], animations: {
            
                if velocityY > 0.0 {
                
                    self.timerView.frame.origin.y = self.timerViewDefaultY

                }else{
                    
                    self.timerView.frame.origin.y = 0

                }
//                
//                if self.timerView.frame.origin.y > self.timerView.bounds.height/2 {
//                    self.timerView.frame.origin.y = self.timerViewDefaultY
//                }else{
//                    self.timerView.frame.origin.y = 0
//                }
                
            }, completion: { (success) in
                print("GestureDone")
            })
            
            self.timerViewLastY = self.timerView.frame.origin.y

            
          
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TaskListVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListCell", for: indexPath)
        cell.textLabel?.text = String(indexPath.row)
        
        return cell
    }
    
}

extension TaskListVC: UITableViewDelegate {
    
    
    
}
