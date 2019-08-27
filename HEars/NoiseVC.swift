//
//  NoiseVC.swift
//  HEars
//
//  Created by yantommy on 16/8/13.
//  Copyright © 2016年 yantommy. All rights reserved.
//

import UIKit

class NoiseVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var arrowButton: SpringButton!
    
    var resetLabel: UILabel!
    
    var shimmeringView: FBShimmeringView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layoutIfNeeded()
        //布局和谐
        tableView.contentInset = UIEdgeInsetsMake(4, 0, 0, 0)
        
        
        self.shimmeringView = FBShimmeringView(frame: self.tableView.frame)
        self.shimmeringView.frame.size.height = 50

        self.view.addSubview(self.shimmeringView)
        
        
        resetLabel = UILabel(frame: self.shimmeringView.bounds)
        resetLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightLight)
        resetLabel.textColor = AppManager.currentTheme.themeColor
        resetLabel.text = NSLocalizedString("Pull Down To Reset", comment: "")
        resetLabel.center = self.view.center
        
        shimmeringView.contentView = self.resetLabel
        
        shimmeringView.shimmeringBeginFadeDuration = 0.5
        shimmeringView.shimmeringEndFadeDuration = 0.5
        shimmeringView.shimmeringSpeed = 150
        shimmeringView.shimmeringAnimationOpacity = 0.2
        
        resetLabel.layer.opacity = 0.0
        
              // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func downButtonDidTouch(_ sender: SpringButton) {

        
        //暂停
        if Pomodoro.isPaused || !Pomodoro.isfocusing || !Noise.enableNoise {
        

            print(Noise.enableNoise)
            Noise.pauseNoisesWithTheme(NoiseTheme.currentNoiseTheme, isPaused: true)
            

        }
    
        
        
        self.dismiss(animated: true, completion: nil)
        
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NoiseVC: UITableViewDataSource {


    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Noise.allNoises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let noiseCell = tableView.dequeueReusableCell(withIdentifier: "NoiseCell") as! NoiseCell
        
        
        noiseCell.noiseIcon.image = Noise.allNoises[indexPath.row].icon
        
        //方便更新调整音量
        noiseCell.cellNumber = indexPath.row
        noiseCell.noisePlayer = Noise.allNoises[indexPath.row].soundPlayer
        
        
        //slider(注意保住与音量同步)
        //注意非調整默認設置的情況下不要用SetValue帶動畫方法，（当进入当前页面的同时，快速点按返回按钮的情况下，此值会变化造成保存不精确）
        
        noiseCell.volumeSlider.value = NoiseTheme.currentNoiseTheme.themevolumes[indexPath.row] * noiseCell.volumeSlider.maximumValue

        
        noiseCell.volumeValue.text = String(Int(noiseCell.volumeSlider.value))
        noiseCell.noiseTitle.text = NSLocalizedString(Noise.noiseNames[indexPath.row], comment: "")
        
        print(noiseCell.noiseTitle.text!)
     
        
        return noiseCell
    }
    
    
}

extension NoiseVC: UITableViewDelegate{

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
    }


}

extension NoiseVC {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
     
    
        
        let contentOffsetY = scrollView.contentOffset.y
        
        print(contentOffsetY)
        
        
        if contentOffsetY <= -4 && contentOffsetY > -54 {
        
            self.resetLabel.layer.opacity = 0.0
            
        }
        
        if contentOffsetY <= -54 && contentOffsetY > -108 {
        
            let opcityPercentage = (abs(contentOffsetY).truncatingRemainder(dividingBy: 54) + 1)/54
            
            print("百分比\(opcityPercentage)")
            
        
            self.resetLabel.layer.opacity = Float(opcityPercentage)
            self.shimmeringView.isShimmering = false
            NoiseTheme.isDefault = false

        }
        
    
        if scrollView.contentOffset.y < -108 {
        
            self.resetLabel.layer.opacity = 1.0
            NoiseTheme.isDefault = true
            self.shimmeringView.isShimmering = true
        
        }
    
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("WillDragging")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        

    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("EndDrag")
        
        
        if NoiseTheme.isDefault {
            
            //移除儲存的設置
            User.userDefalut.removeObject(forKey: NoiseTheme.currentNoiseTheme.themeName)
            
            //重新得到默認設置
            NoiseTheme.currentNoiseTheme = NoiseTheme.allNoiseTheme[NoiseTheme.indexOfCurrentNoiseTheme]
            
//            print(NoiseTheme.currentNoiseTheme.themevolumes)
            
            //可見的Cell
            for index in 0..<tableView.numberOfRows(inSection: 0) {
                
                
                
                if index < tableView.visibleCells.count {
                    
                    let cell = tableView.visibleCells[index] as! NoiseCell
                    
                    cell.expectCellVolume = NoiseTheme.currentNoiseTheme.themevolumes[index] * cell.volumeSlider.maximumValue
                    cell.currentCellVolume = Float(cell.volumeValue.text!)!
                    //大約1秒種完成動畫
                    cell.changedVolume = (cell.currentCellVolume - cell.expectCellVolume)/60
                    
                    cell.displayLink.isPaused = false
                    
                    NoiseTheme.isDefault = false
                    
                }else{
                    
                    let noisePlayer = Noise.allNoises[index].soundPlayer
                    
                    let fader = iiFaderForAvAudioPlayer(player: noisePlayer!)
                    
                    fader.fade(fromVolume: Double((noisePlayer?.volume)!), toVolume: Double(NoiseTheme.currentNoiseTheme.themevolumes[index]), duration: 1, velocity: 0.4, onFinished: { (success) in
                        
                    })
                    
                    
                }
                
            }
            
        }
        
        
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        print("willEndDrag")
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {



    }
}
