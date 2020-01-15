//
//  GamesDetailViewController.swift
//  ScoreBoard
//
//  Created by BarryKao on 2020/1/6.
//  Copyright © 2020 BarryKao. All rights reserved.
//

import UIKit

class GamesDetailViewController: UIViewController {


    @IBOutlet weak var tableView: UITableView!
    
    var currentGameData: [GameData] = []
    var selectRow: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension GamesDetailViewController: UITableViewDataSource ,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentGameData[selectRow].timeQuarter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "quarterCell", for: indexPath) as! QuarterTableViewCell
        let data = self.currentGameData[selectRow]
        cell.quarterNumber.text = "\(indexPath.row + 1)."
        
//        cell.firstScoreLabel.text = "\(data.teamQuarterScore[indexPath.row])"
//        cell.secondScoreLabel.text = "\(data.visitQuarterScore[indexPath.row])"
//        cell.timeLabel.text = "\(data.timeQuarter[indexPath.row])"
        
        cell.firstScoreLabel.text = "\(data.teamQuarterScore[indexPath.row])"
        cell.secondScoreLabel.text = "\(data.visitQuarterScore[indexPath.row])"
        cell.timeLabel.text = "\(data.timeQuarter[indexPath.row])"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
