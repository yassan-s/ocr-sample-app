//
//  ViewController.swift
//  ocr-sample-app
//
// 参考サイト
//【【Swift/PhotoKit】PHPickerViewControllerで画像を取得する方法！写真アプリの操作】
// https://tech.amefure.com/swift-uikit-photokit
//

import UIKit
import PhotosUI
import Vision

class ViewController: UIViewController {
    
    // 選択画像
    @IBOutlet weak var imageView: UIImageView!
    // 結果表示
    @IBOutlet var textLabel: UILabel!
    // 画像認識文字列
    var recognizedStrings: [String] = []
    
    
    /**
     画面表示
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    /**
        「写真を選択」を押下時
     */
    @IBAction func buttonTapedSelectPicture(sender: UIButton){
            
        // PHPickerConfiguration の設定
        // 画像のみかつ選択できる枚数を1枚に制限
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = PHPickerFilter.images
        // 例 configuration.filter = PHPickerFilter.any(of: [.livePhotos, .videos])
            
        // 定義した構成を元に、実際に表示させるPickerviewを構築
        let pickerViewController = PHPickerViewController(configuration: config)
        pickerViewController.delegate = self
        self.present(pickerViewController, animated: true, completion: nil)

    }


    /**
        「画像解析」を押下時
     */
    @IBAction func buttonTapedSearchImage(sender: UIButton){
            
        // リクエストを実行するCGImageを取得
        // CGImageに型変換する
        guard let cgImage: CGImage = self.imageView.image?.cgImage else { return }

        // image-request handler を新規作成
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)

        // テキストを認識するための新しいリクエストを作成
        // recognizeTextHandlerの作り方調べる クロージャ
        let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)
        //　ここで日本語を指定する
        request.recognitionLanguages = ["ja-JP"]

        do {
            // テキスト認識のリクエストを実行
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the requests: \(error).")
        }
        

    }
    
    /**
     クロージャ
     */
    func recognizeTextHandler(request: VNRequest, error: Error?) {
        guard let observations =
                request.results as? [VNRecognizedTextObservation] else {
            return
        }
//        let recognizedStrings = observations.compactMap { observation in
//            // Return the string of the top VNRecognizedText instance.
//            return observation.topCandidates(1).first?.string
//        }
        let maximumCandidates = 1
        var recognizedText = ""
        for observation in observations {
            guard let candidate = observation.topCandidates(maximumCandidates).first else { continue }
            recognizedText += candidate.string
        }
        
        // Process the recognized strings.
        setText(text: recognizedText)
    }
    
    func setText(text: String){
//        self.recognizedStrings = text
        self.textLabel.text = text
//        self.textLabel.text = text.joined(separator: ",")
    }
    
    
    /**
        画面遷移時
     */
//    override func prepare(
//        for segue: UIStoryboardSegue,
//        sender: Any?) {
//
//            if let srVC = segue.description as? SearchResultViewController {
//                // 値を渡す
//                srVC.recognizedStrings = self.recognizedStrings
//
//            }
//        }

}


extension ViewController: UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    
    /**
     写真選択完了イベント
     */
    // 配列形式のPHPickerResult形式で取得
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        // 1つのみ選択なので、先頭を決め打ちで取得
        if let itemProvider = results.first?.itemProvider{
            // 対象のプロバイダーオブジェクトを読み込めるかどうかを識別
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                
                // 画像の取り込み
                // loadObjectメソッドは非同期で実行されるメソッド
                // completionHandlerから対象のデータとエラーに参照できる
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    guard let image = image as? UIImage else {
                        return
                    }
                    // ビューを更新するのでメインスレッドで、プロパティにセット
                    DispatchQueue.main.async {
                        self?.imageView.image = image
                    }
                }
            }
        }
        self.dismiss(animated: true)

    }
}
