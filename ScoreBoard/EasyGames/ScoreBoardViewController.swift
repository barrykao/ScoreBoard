//
//  ScoreBoardViewController.swift
//  ScoreBoard
//
//  Created by BarryKao on 2019/11/1.
//  Copyright © 2019 BarryKao. All rights reserved.
//

import UIKit


protocol ScoreBoardViewControllerDelegate: class {
    func gameSetUp(gameData: GameData)
}


class ScoreBoardViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var optionButton: UIButton!
    
    @IBOutlet weak var hourTextView: UITextView!
    @IBOutlet weak var minuteTextVIew: UITextView!
    @IBOutlet weak var secondTextView: UITextView!
    @IBOutlet weak var pointLabel: UILabel!
    
    @IBOutlet weak var firstTeamTextField: UITextField!
    @IBOutlet weak var secondTeamTextField: UITextField!
    @IBOutlet weak var firstScoreLabel: UILabel!
    @IBOutlet weak var secondScoreLabel: UILabel!
    @IBOutlet weak var firstTeamFoulTextField: UITextField!
    @IBOutlet weak var secondTeamFoulTextField: UITextField!
    
    @IBOutlet weak var firstFoulButton: UIButton!
    @IBOutlet weak var secondFoulButton: UIButton!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var firstScore: Int = 0
    var secondScore: Int = 0
    var firstFoul: Int = 0
    var secondFoul: Int = 0

    var hours: Int = 0
    var minutes: Int = 0
    var seconds: Int = 0
    var point: Int = 0
    var isCountDown: Bool = true
    var timer = Timer()


    var gameQuarterData: [GameData] = []
    let gameData = GameData()

    var teamAllScore: Int = 0
    var visitAllScore: Int = 0
    var timeAll: String = ""
    var hoursAll: Int = 0
    var minutesAll: Int = 0
    var secondsAll: Int = 0
    var timeChangeFlag: Bool = true
    
    var teamQuarterScore = [Int]()
    var visitQuarterScore = [Int]()

    var delegate: ScoreBoardViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.optionButton.setTitle("設定時間", for: .normal)
        
        firstScoreLabel.text = "0"
        secondScoreLabel.text = "0"
//        timeTextView.text = "00:00:00.0"
        self.hourTextView.text = "0"
        self.minuteTextVIew.text = "0"
        self.secondTextView.text = "0"
        self.pointLabel.text = "0"
        self.firstTeamFoulTextField.text = "0"
        self.secondTeamFoulTextField.text = "0"
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.firstTeamTextField.delegate = self
        self.secondTeamTextField.delegate = self
        self.firstTeamFoulTextField.isEnabled = false
        self.secondTeamFoulTextField.isEnabled = false
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false

        self.saveButton.isEnabled = false
        self.startButton.isEnabled = false
        self.resetButton.isEnabled = true
        
        let firstScoreText = UITapGestureRecognizer( target:self, action:#selector(firstScoreTap(recognizer:)))
        // 點幾下才觸發 設置 1 時 則是要點一下才會觸發 依此類推
        firstScoreText.numberOfTapsRequired = 1
        // 幾根指頭觸發
        firstScoreText.numberOfTouchesRequired = 1
        // 為視圖加入監聽手勢
        self.firstScoreLabel.isUserInteractionEnabled = true
        self.firstScoreLabel.addGestureRecognizer(firstScoreText)
        
        let secondScoreText = UITapGestureRecognizer( target:self, action:#selector(secondScoreTap(recognizer:)))
        // 點幾下才觸發 設置 1 時 則是要點一下才會觸發 依此類推
        secondScoreText.numberOfTapsRequired = 1
        // 幾根指頭觸發
        secondScoreText.numberOfTouchesRequired = 1
        self.secondScoreLabel.isUserInteractionEnabled = true
        self.secondScoreLabel.addGestureRecognizer(secondScoreText)
        // Do any additional setup after loading the view.
    }
    
    // 觸發單指輕點一下手勢後 執行的動作
    @objc func firstScoreTap(recognizer:UITapGestureRecognizer){
        print("team")
        
        let controller = UIAlertController(title: "TeamScore", message: "Please enter team score number.", preferredStyle: .alert)
        controller.addTextField { (textField) in
            textField.placeholder = "000"
            textField.keyboardType = UIKeyboardType.phonePad
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            guard let firstScoreLabel = controller.textFields?[0].text else {return}
            guard let firstScore = Int(firstScoreLabel) else {return}
            if firstScore > 999 {
                alertAction(controller: self, title: "Error", message: "Please enter 0~999.")
            }else {
                self.firstScore = firstScore
                self.firstScoreLabel.text = firstScoreLabel
            }
        }
        controller.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)

        
    }
    @objc func secondScoreTap(recognizer:UITapGestureRecognizer){
        print("visit")
        let controller = UIAlertController(title: "VisitScore", message: "Please enter visit score number.", preferredStyle: .alert)
        controller.addTextField { (textField) in
            textField.placeholder = "000"
            textField.keyboardType = UIKeyboardType.phonePad
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            guard let secondScoreLabel = controller.textFields?[0].text else {return}
            guard let secondScore = Int(secondScoreLabel) else {return}
            if secondScore > 999 {
                alertAction(controller: self, title: "Error", message: "Please enter 0~999.")
            }else {
                self.secondScore = secondScore
                self.secondScoreLabel.text = secondScoreLabel
            }
        }
        controller.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        self.setEditing(editing, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Point
    @IBAction func addFirstTeamPointButton(_ sender: Any) {
        
        if firstScore >= 0 {
            firstScore += 1
            let firstScoreString = String(firstScore)
            self.firstScoreLabel.text = firstScoreString
        }
    }
    
    @IBAction func minusFirstTeamButton(_ sender: Any) {
        
        if firstScore > 0 {
            firstScore -= 1
            let firstScoreString = String(firstScore)
            self.firstScoreLabel.text = firstScoreString
        }else {
            self.firstScoreLabel.text = "0"
            firstScore = 0
        }
        
    }
    
    @IBAction func addSecondTeamPointButton(_ sender: Any) {
        if secondScore >= 0 {
            secondScore += 1
            let secondScoreString = String(secondScore)
            self.secondScoreLabel.text = secondScoreString
        }
        
    }
    
    @IBAction func minusSecondTeamPointButton(_ sender: Any) {
        
        if secondScore > 0 {
            secondScore -= 1
            let secondScoreString = String(secondScore)
            self.secondScoreLabel.text = secondScoreString
        }else {
            self.secondScoreLabel.text = "0"
            secondScore = 0
        }
    }
    
    // MARK: Foul
    @IBAction func addFirstTeamFoulButton(_ sender: Any) {
        
        if firstFoul >= 0 {
            firstFoul += 1
            let firstFoulString = String(firstFoul)
            self.firstTeamFoulTextField.text = firstFoulString
            if firstFoul == 5 {
                self.firstTeamFoulTextField.text = "Bouns"
                self.firstFoulButton.isEnabled = false
            }else {
                self.firstFoulButton.isEnabled = true
            }
        }
    }
    
    @IBAction func minusFirstTeamFoulButton(_ sender: Any) {
        
        self.firstFoulButton.isEnabled = true
        if firstFoul > 0 {
            firstFoul -= 1
            let firstFoulString = String(firstFoul)
            self.firstTeamFoulTextField.text = firstFoulString
        }else {
            self.firstTeamFoulTextField.text = "0"
            firstFoul = 0
        }
        
    }
    
    @IBAction func addSecondTeamFoulButton(_ sender: Any) {
        
        if secondFoul >= 0 {
            secondFoul += 1
            let secondFoulString = String(secondFoul)
            self.secondTeamFoulTextField.text = secondFoulString
            if secondFoul == 5 {
                self.secondTeamFoulTextField.text = "Bouns"
                self.secondFoulButton.isEnabled = false
            }else {
                self.secondFoulButton.isEnabled = true
            }
        }
        
    }
    
    @IBAction func minusSecondTeamFoulButton(_ sender: Any) {
        
        self.secondFoulButton.isEnabled = true
        if secondFoul > 0 {
            secondFoul -= 1
            let secondFoulString = String(secondFoul)
            self.secondTeamFoulTextField.text = secondFoulString
        }else {
            self.secondTeamFoulTextField.text = "0"
            secondFoul = 0
        }
        
    }
    
    // MARK: Timer
    @objc func UpdateTimer() {
        
        if self.point < 1 {
            if self.seconds > 0 {
                self.seconds -= 1
                self.point = 10
            }else {
                if self.minutes > 0 {
                    self.minutes -= 1
                    self.seconds = 59
                    self.point = 10
                }else{
                    if self.hours > 0 {
                        self.hours -= 1
                        self.minutes = 59
                        self.seconds = 59
                        self.point = 10
                    }
                }
            }
        }
    
        self.point -= 1

        self.hourTextView.text = String(format: "%d", hours)
        self.minuteTextVIew.text = String(format: "%d", minutes)
        self.secondTextView.text = String(format: "%d", seconds)
        self.pointLabel.text = String(format: "%d",point)
        if self.hours == 0 && self.minutes == 0 && self.seconds == 0 && self.point == 0 {
            
                self.timer.invalidate()
                self.hourTextView.text = UserDefaults.standard.string(forKey: "hours")
                self.minuteTextVIew.text = UserDefaults.standard.string(forKey: "minutes")
                self.secondTextView.text = UserDefaults.standard.string(forKey: "seconds")
                self.hours = UserDefaults.standard.integer(forKey: "hours")
                self.minutes = UserDefaults.standard.integer(forKey: "minutes")
                self.seconds = UserDefaults.standard.integer(forKey: "seconds")
                self.startButton.setTitle("Start", for: .normal)
                self.isCountDown = true
                self.navigationItem.leftBarButtonItem?.isEnabled = true
                self.optionButton.isEnabled = true
                self.resetButton.isEnabled = true
            if self.timeChangeFlag {
                self.saveButton.isEnabled = true
                alertAction(controller: self, title: "時間到!", message: "比賽結束\n點選Save可以儲存該節比賽")
            }else {
                self.timeChangeFlag = true
                self.saveButton.isEnabled = false
                alertAction(controller: self, title: "時間到!", message: "暫停時間已到")
            }
            
            
        }
//        self.timeTextView.text = String(format: "%d : %d : %.1f",hours,minutes,seconds)
        
    }
    
    @IBAction func startButton(_ sender: Any) {
        
        if isCountDown {
            self.startButton.setTitle("Pause", for: .normal)
            self.navigationItem.leftBarButtonItem?.isEnabled = false
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            self.resetButton.isEnabled = false
            self.saveButton.isEnabled = false
            isCountDown = false
            self.optionButton.isEnabled = false
            DispatchQueue.main.async {
                self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.UpdateTimer), userInfo: nil, repeats: true)
            }
            
        }else {
            self.startButton.setTitle("Start", for: .normal)
            self.navigationItem.leftBarButtonItem?.isEnabled = true
            isCountDown = true
            self.timer.invalidate()
            self.resetButton.isEnabled = true
            self.optionButton.isEnabled = true
        }
        
    }
    
    @IBAction func resetButton(_ sender: Any) {
        
        let alert = UIAlertController(title: "清除設定", message: "你想要清除所有設定嗎?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .default) { (ok) in
            self.resetAll()
            self.resetButton.isEnabled = false
        }
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }

    @IBAction func saveButton(_ sender: Any) {
        
        self.saveButton.isEnabled = false
        self.navigationItem.rightBarButtonItem?.isEnabled = true
//        let data = QuarterData()
        
        self.teamQuarterScore.append(self.firstScore)
        self.visitQuarterScore.append(self.secondScore)
//        data.firstScore = self.firstScore
//        data.secondScore = self.secondScore
        
        self.teamAllScore += self.firstScore
        self.visitAllScore += self.secondScore

        self.hoursAll += self.hours
        self.minutesAll += self.minutes
        self.secondsAll += self.seconds
        self.timeAll = "\(self.hoursAll):\(self.minutesAll):\(self.secondsAll)"
//        data.time = "\(self.hours):\(self.minutes):\(self.seconds)"
//        quarterData.append(data)
        gameData.teamAllScore = self.teamAllScore
        gameData.visitAllScore = self.visitAllScore
        gameData.timeAll = self.timeAll
        gameData.teamQuarterScore.append(self.firstScore)
        gameData.visitQuarterScore.append(self.secondScore)
        
        guard let teamName = self.firstTeamTextField.text else {return}
        guard let visitName = self.secondTeamTextField.text else {return}

        if teamName == "" {
            gameData.teamName = "Team:"
        }else {
            gameData.teamName = teamName + ":"
        }
        if visitName == "" {
            gameData.visitName = "Visit:"
        }else {
            gameData.visitName = visitName + ":"
        }
        
        let time = "\(self.hours):\(self.minutes):\(self.seconds)"
        gameData.timeQuarter.append(time)
        self.gameQuarterData.append(gameData)
        
        self.firstScore = 0
        self.secondScore = 0
        self.firstScoreLabel.text = "0"
        self.secondScoreLabel.text = "0"

     
        self.tableView.reloadData()
        
    }
    
    @IBAction func saveAllButton(_ sender: Any) {
        
        let alert = UIAlertController(title: "Games End!", message: "Do you want to save this games?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .default) { (ok) in
            self.delegate?.gameSetUp(gameData: self.gameData)
            self.dismiss(animated: true)
        }
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
  
        
        
    }
    
    @IBAction func optionTime(_ sender: Any) {
        
        let controller = UIAlertController(title: "設定時間", message: "請選擇設定的功能", preferredStyle: .actionSheet)
        let actions = ["設定比賽時間", "設定暫停時間"]
        for action in actions {
            let action = UIAlertAction(title: action, style: .default) { (action) in
                if action.title == "設定比賽時間" {
                    self.timeChangeFlag = true
                    let controller = UIAlertController(title: "設定比賽時間", message: "請輸入比賽時間", preferredStyle: .alert)
                    controller.addTextField { (textField) in
                        textField.placeholder = "時:00"
                        textField.keyboardType = UIKeyboardType.phonePad
                    }
                    controller.addTextField { (textField) in
                        textField.placeholder = "分:00"
                        textField.keyboardType = UIKeyboardType.phonePad
                    }
                    controller.addTextField { (textField) in
                        textField.placeholder = "秒:00"
                        textField.keyboardType = UIKeyboardType.phonePad
                    }
                    let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                        guard let hours = controller.textFields?[0].text else {return}
                        guard let minutes = controller.textFields?[1].text else {return}
                        guard let seconds = controller.textFields?[2].text else {return}
                        self.setTimeAction(hours: hours, minutes: minutes, seconds: seconds)
                    }
                    controller.addAction(okAction)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    controller.addAction(cancelAction)
                    self.present(controller, animated: true, completion: nil)
                }
                if action.title == "設定暫停時間" {
                    self.timeChangeFlag = false
                    let controller = UIAlertController(title: "設定暫停時間", message: "請設定暫停時間", preferredStyle: .alert)
                    controller.addTextField { (textField) in
                        textField.placeholder = "時:00"
                        textField.keyboardType = UIKeyboardType.phonePad
                    }
                    controller.addTextField { (textField) in
                        textField.placeholder = "分:00"
                        textField.keyboardType = UIKeyboardType.phonePad
                    }
                    controller.addTextField { (textField) in
                        textField.placeholder = "秒:00"
                        textField.keyboardType = UIKeyboardType.phonePad
                    }
                    let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                        guard let hours = controller.textFields?[0].text else {return}
                        guard let minutes = controller.textFields?[1].text else {return}
                        guard let seconds = controller.textFields?[2].text else {return}
                        self.setTimeAction(hours: hours, minutes: minutes, seconds: seconds)
                    }
                    controller.addAction(okAction)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    controller.addAction(cancelAction)
                    self.present(controller, animated: true, completion: nil)
                    
                }
            }
            controller.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)

    }
    
    
    // MARK: setTimeAction
    func setTimeAction(hours: String, minutes: String, seconds: String) {
        
        self.hours = Int(hours) ?? 0
        self.minutes = Int(minutes) ?? 0
        self.seconds = Int(seconds) ?? 0
        self.point = 0

        if self.hours > 99 {
            alertAction(controller: self, title: "Error!", message: "小時數字必須為0~99")
            self.resetAll()
            return
        }else {
            if hours == "" {
                self.hourTextView.text = "0"
            }else {
                self.hourTextView.text = hours
            }
        }
        
        if self.minutes > 59 || self.seconds > 59 {
            alertAction(controller: self, title: "Error!", message: "分鐘與秒鐘數字必需為0~59")
            self.resetAll()
            return
        }else {
            if minutes == "" {
                self.minuteTextVIew.text = "0"
            }else {
                self.minuteTextVIew.text = minutes
            }
            if seconds == "" {
                self.secondTextView.text = "0"
            }else {
                self.secondTextView.text = seconds
            }
        }
        self.pointLabel.text = "0"
        if self.hours == 0 && self.minutes == 0 && self.seconds == 0 {
            self.startButton.isEnabled = false
        }else {
            self.startButton.isEnabled = true
        }
        self.resetButton.isEnabled = true
        if self.timeChangeFlag {
            UserDefaults.standard.set(self.hours, forKey: "hours")
            UserDefaults.standard.set(self.minutes, forKey: "minutes")
            UserDefaults.standard.set(self.seconds, forKey: "seconds")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.isEnabled = false
    }
    
    func resetAll() {
        self.hourTextView.text = "0"
        self.minuteTextVIew.text = "0"
        self.secondTextView.text = "0"
        self.pointLabel.text = "0"
        
        self.hours = 0
        self.minutes = 0
        self.seconds = 0
        self.point = 0
        
        self.firstScore = 0
        self.firstScoreLabel.text = "0"
        self.secondScore = 0
        self.secondScoreLabel.text = "0"
        
        self.startButton.isEnabled = false
    }

    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
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

// MARK: QuarterTableView
extension ScoreBoardViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.quarterData.count
        return self.gameQuarterData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "quarterCell", for: indexPath) as! QuarterTableViewCell
        
//        let data = self.quarterData[indexPath.row]
//        cell.quarterNumber.text = "\(indexPath.row + 1)"
//        if let firstScore = data.firstScore,
//            let secondScore = data.secondScore,
//            let time = data.time {
//            cell.firstScoreLabel.text = "\(firstScore)"
//            cell.secondScoreLabel.text = "\(secondScore)"
//            cell.timeLabel.text = "\(time)"
//        }
        
        let data = self.gameQuarterData[indexPath.row]
        cell.quarterNumber.text = "\(indexPath.row + 1)."
        
//        if let temaScore = data.teamQuarterScore[indexPath.row],
//            let visitScore = data.visitQuarterScore[indexPath.row],
//            let time = data.timeQuarter[indexPath.row]{
//            cell.firstScoreLabel.text = "\(temaScore)"
//            cell.secondScoreLabel.text = "\(visitScore)"
//            cell.timeLabel.text = "\(time)"
//        }
//
        cell.firstScoreLabel.text = "\(data.teamQuarterScore[indexPath.row])"
        cell.secondScoreLabel.text = "\(data.visitQuarterScore[indexPath.row])"
        cell.timeLabel.text = "\(data.timeQuarter[indexPath.row])"

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
