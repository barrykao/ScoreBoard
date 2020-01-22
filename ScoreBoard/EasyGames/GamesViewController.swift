//
//  GamesViewController.swift
//  ScoreBoard
//
//  Created by BarryKao on 2019/11/1.
//  Copyright © 2019 BarryKao. All rights reserved.
//

import UIKit



class GamesViewController: UIViewController, ScoreBoardViewControllerDelegate {
   
    
    @IBOutlet weak var tableView: UITableView!
    
    var gameData: [GameData] = []
    
    var teamAllScore: Int = 0
    var visitAllScore: Int = 0
    var timeAll: String = ""
    var selectRow: Int = 0
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadFromFile()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        
        // Do any additional setup after loading the view.
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        self.tableView.setEditing(editing, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "gameDetailSegue"{
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let gameDetailVC = segue.destination as! GamesDetailViewController
                gameDetailVC.currentGameData = self.gameData
                gameDetailVC.selectRow = indexPath.row
            }
        }
        
        if segue.identifier == "gameSegue"{
            
            let navigationVC = segue.destination as! UINavigationController
            let scoreVC = navigationVC.topViewController as! ScoreBoardViewController
            scoreVC.delegate = self
            
        }
        
        
    }
    func gameSetUp(gameData: GameData) {
        
        self.gameData.append(gameData)
        self.saveToFile()
        self.tableView.reloadData()
        
    }
    
    //MARK: SaveData
    func saveToFile() {
        
        let homeURL = URL(fileURLWithPath: NSHomeDirectory())
        let documents = homeURL.appendingPathComponent("Documents")
        let fileURL = documents.appendingPathComponent("games.archive")
        do{
            //把[Note]轉成Data型式
            let data = try NSKeyedArchiver.archivedData(withRootObject: self.gameData, requiringSecureCoding: false)
            //寫到檔案
            try data.write(to: fileURL, options: [.atomicWrite])
            
        }catch{
            print("error \(error)")
        }
        
    }
    
    
    func loadFromFile() {
        
        let homeURL = URL(fileURLWithPath: NSHomeDirectory())
        let documents = homeURL.appendingPathComponent("Documents")
        let fileURL = documents.appendingPathComponent("games.archive")
        do{
            //把檔案轉成Data型式
            let fileData = try Data(contentsOf: fileURL)
            //從Data轉回Note陣列
            self.gameData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(fileData) as! [GameData]
        }
        catch{
            print("error \(error)")
        }
    }
}

// MARK: GamesTableView
extension GamesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.gameData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as! GameTableViewCell
        let data = self.gameData[indexPath.row]
        
        if let teamAllScore = data.teamAllScore,
            let visitAllScore = data.visitAllScore{
            cell.teamScore.text = String(teamAllScore)
            cell.visitScore.text = String(visitAllScore)
        }
        cell.teamNameLabel.text = data.teamName
        cell.visitNameLabel.text = data.visitName
        cell.gamesNumber.text = "\(indexPath.row + 1)."
        cell.timeAllLabel.text = data.timeAll
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            self.gameData.remove(at: indexPath.row)
            self.saveToFile() //File
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
