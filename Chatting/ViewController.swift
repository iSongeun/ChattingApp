//
//  ViewController.swift
//  Chatting
//
//  Created by 이송은 on 2023/03/13.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    @IBOutlet weak var inputTextView: UITextView!{
        didSet{
            inputTextView.delegate = self
        }
    }
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
        }
    }
    
    @IBOutlet weak var bottomContraint: NSLayoutConstraint!
    var chatDatas = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ChattingCell", bundle: nil), forCellReuseIdentifier: "ChattingCell")
        tableView.register(UINib(nibName: "YourCell", bundle: nil), forCellReuseIdentifier: "YourCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
    }

    @objc func keyboardWillShow(noti : Notification) {
        let notiInfo = noti.userInfo!
        let keyboardFrame = notiInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let height = keyboardFrame.size.height - self.view.safeAreaInsets.bottom
        
        let animationDuration = notiInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        UIView.animate(withDuration: animationDuration) {
            self.bottomContraint.constant = height
            self.view.layoutIfNeeded()
        }
      
    }
    
    @objc func keyboardWillHide(noti : Notification){
        let notiInfo = noti.userInfo!
        let animationDuration = notiInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        UIView.animate(withDuration: animationDuration) {
            self.bottomContraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }

    @IBAction func sendMessage(_ sender: Any) {
        chatDatas.append(inputTextView.text)
        tableView.reloadData()
        inputTextView.text = ""
        let lastIndexpath = IndexPath(row: chatDatas.count - 1, section: 0
        )
        tableView.scrollToRow(at: lastIndexpath, at: .bottom, animated: true) // 마지막 인덱스가 맨 밑에 보이도록 설계
        textViewHeight.constant = 40
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChattingCell", for: indexPath) as? ChattingCell else {
                return UITableViewCell()
            }
            
            let dateFormmater = DateFormatter()
            dateFormmater.dateFormat = "yyyy-MM-dd, HH:mm"
            cell.dateLabel.text = dateFormmater.string(from: Date())
            cell.textView.text = chatDatas[indexPath.row]
            return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "YourCell", for: indexPath) as? YourCell else {
                return UITableViewCell()
            }
            
            let dateFormmater = DateFormatter()
            dateFormmater.dateFormat = "yyyy-MM-dd, HH:mm"
            cell.dateLabel.text = dateFormmater.string(from: Date())
            cell.textView.text = chatDatas[indexPath.row]
            return cell
        }
    }
    
    
}

extension ViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.contentSize.height <= 40 {
            textViewHeight.constant = 40
        }else if textView.contentSize.height >= 100 {
            textViewHeight.constant = 100
        }else{
            textViewHeight.constant = inputTextView.contentSize.height
        }
        
        /*
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
         */
    }
}
