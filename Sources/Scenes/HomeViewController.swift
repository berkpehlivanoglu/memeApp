//
//  HomeViewController.swift
//  MemeMe
//
//  Created by BerkPehlivanoğlu on 15.11.2021.
//

import UIKit

class HomeViewController: UIViewController & Layouting {
    
    typealias ViewType = HomeView

// MARK: - Initialization
    override func loadView() {
        view = ViewType.create()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutableView.topTextField.delegate = self
        layoutableView.bottomTextField.delegate = self
        
        setupButtonTargets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        layoutableView.topTextField.text = "TOP"
        layoutableView.bottomTextField.text = "BOTTOM"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
}
//MARK: - UIImagePickerControllerDelegate
extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.allowsEditing = true
        myPickerController.sourceType = sourceType
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            layoutableView.imagePickerView.image = editedImage
        }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            layoutableView.imagePickerView.image = originalImage
        }
        dismiss(animated: true, completion: nil)
    }
}
// MARK: - SetupButtonTargets
extension HomeViewController {
    func setupButtonTargets() {
        layoutableView.chooseFromPhotosButton.addTarget(self, action: #selector(didTapChooseFromPhotosButton), for: .touchUpInside)
        layoutableView.chooseCameraButton.addTarget(self, action: #selector(didTapChooseCameraButton), for: .touchUpInside)
        layoutableView.shareButton.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
        layoutableView.cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
    }
}
// MARK: - Actions
extension HomeViewController {
    @objc func didTapChooseFromPhotosButton() {
        showImagePickerController(sourceType: .photoLibrary)
    }
    
    @objc func didTapChooseCameraButton() {
        showImagePickerController(sourceType: .camera)
    }
    
    @objc func didTapShareButton() {
        let item = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [item], applicationActivities: nil)
        self.present(activityViewController, animated: true)
        activityViewController.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed:
                                                                Bool, arrayReturnedItems: [Any]?, error: Error?) in
            if completed {
                self.safelySaveMeme(memedImage: item)
                return
            } else {
                print("cancel")
            }
            if let shareError = error {
                print("error while sharing: \(shareError.localizedDescription)")
            }
        }
    }
    
    @objc func didTapCancelButton() {
        layoutableView.imagePickerView.image = nil
        layoutableView.topTextField.text = "TOP"
        layoutableView.bottomTextField.text = "BOTTOM"
        self.dismiss(animated: true, completion: nil)
    }
}
// MARK: - UITextFieldDelegate
extension HomeViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.clearsOnBeginEditing = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        //        remakeconstraintsOfTextField()
        return false
    }
}
//MARK: - Helpers
extension HomeViewController {
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if layoutableView.bottomTextField.isFirstResponder && view.frame.origin.y == 0.0{
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
        
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if layoutableView.bottomTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)   // removed self
    }
    
    func safelySaveMeme(memedImage: UIImage) {
        if layoutableView.imagePickerView.image != nil && layoutableView.topTextField.text != nil && layoutableView.bottomTextField.text != nil
        {
            guard
                let top = layoutableView.topTextField.text,
                let bottom = layoutableView.bottomTextField.text,
                let image = layoutableView.imagePickerView.image
            else { return }
            
            let meme = Meme(topText: top, bottomText: bottom, originalImage: image, memedImage: memedImage)
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        guard let keyboardSize = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue  else { return 0 }// of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func generateMemedImage() -> UIImage {
        
        layoutableView.bottomStackView.isHidden = true
        layoutableView.topStackView.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return memedImage
        
    }
}
