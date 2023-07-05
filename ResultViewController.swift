//
//  ResultViewController.swift
//  ocr-sample-app
//

import UIKit

class ResultViewController: UIViewController {
    
    // 画像認識文字列
    var recognizedStrings: String!
    // 選択画像
    var selectedUIImage: UIImage!
    // 選択画像
    @IBOutlet weak var imageView: UIImageView!
    // 結果表示
    @IBOutlet var textView: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.backgroundColor = UIColor.white
        
        self.textView.text = self.recognizedStrings
        self.imageView.image = self.selectedUIImage

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
