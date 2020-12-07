//
//  ViewController.swift
//  face_ai
//
//  Created by M'haimdat omar on 29-02-2020.
//  Copyright © 2020 M'haimdat omar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let name: UILabel = {
       let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont(name: "Avenir-Heavy", size: 55)
        text.text = "iFace"
        text.textColor = UIColor.systemTeal
        text.shadowColor = UIColor.systemOrange
        
        return text
        
    }()
    
    
    
    
    let faceDetection: BtnPleinLarge = {
        let button = BtnPleinLarge()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonToFaceDetection(_:)), for: .touchUpInside)
        button.setTitle("Face detection", for: .normal)
        let icon = UIImage(systemName: "person.3.fill")?.resized(newSize: CGSize(width: 50, height: 25))
        button.addRightImage(image: icon!, offset: 30)
        button.backgroundColor = .systemFill
        button.layer.borderColor = UIColor.systemOrange.cgColor
        button.layer.shadowOpacity = 0.8
        button.layer.shadowColor = UIColor.white.cgColor
        
        return button
    }()
    
    let faceClassification: BtnPleinLarge = {
        let button = BtnPleinLarge()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonToFaceClassification(_:)), for: .touchUpInside)
        button.setTitle("Face classification", for: .normal)
        let icon = UIImage(systemName: "person.crop.circle.badge.checkmark")?.resized(newSize: CGSize(width: 50, height: 40))
        button.addRightImage(image: icon!, offset: 30)
        button.backgroundColor = .systemFill
        button.layer.borderColor = UIColor.systemYellow.cgColor
        button.layer.shadowOpacity = 0.8
        button.layer.shadowColor = UIColor.white.cgColor
        
        return button
    }()
    
    let faceRecognition: BtnPleinLarge = {
        let button = BtnPleinLarge()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonToFaceRecognition(_:)), for: .touchUpInside)
        button.setTitle("Face Recognition", for: .normal)
        let icon = UIImage(systemName: "faceid")?.resized(newSize: CGSize(width: 50, height: 45))
        button.addRightImage(image: icon!, offset: 30)
        button.backgroundColor = .systemFill
        button.layer.borderColor = UIColor.systemGreen.cgColor
        button.layer.shadowOpacity = 0.8
        button.layer.shadowColor = UIColor.white.cgColor
        
        return button
    }()
    
    let emotionDetection: BtnPleinLarge = {
        let button = BtnPleinLarge()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonToEmotionDetection(_:)), for: .touchUpInside)
        button.setTitle("Emotion Detection", for: .normal)
        let icon = UIImage(systemName: "smiley")?.resized(newSize: CGSize(width: 50, height: 45))
        button.addRightImage(image: icon!, offset: 30)
        button.backgroundColor = .systemFill
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.shadowOpacity = 0.8
        button.layer.shadowColor = UIColor.white.cgColor
        
        return button
    }()
    
    let maskDetection: BtnPleinLarge = {
        let button = BtnPleinLarge()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonToMaskDetection(_:)), for: .touchUpInside)
        button.setTitle("Mask detection", for: .normal)
        let icon = UIImage(systemName: "shield")?.resized(newSize: CGSize(width: 50, height: 50))
        button.addRightImage(image: icon!, offset: 30)
        button.backgroundColor = .systemFill
        button.layer.borderColor = UIColor.systemPurple.cgColor
        button.layer.shadowOpacity = 0.8
        button.layer.shadowColor = UIColor.white.cgColor
        
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTabBar()
        setupLabel()
        setupButtons()
    }
    
    func setupTabBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "iFace"
        if #available(iOS 13.0, *) {
            self.navigationController?.navigationBar.barTintColor = .systemBackground
             navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.label]
        } else {
            self.navigationController?.navigationBar.barTintColor = .lightText
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.black]
        }
        self.navigationController?.navigationBar.isHidden = false
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.barStyle = .default
        if #available(iOS 13.0, *) {
            navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.label]
        } else {
            navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.black]
        }
        if #available(iOS 13.0, *) {
            navigationController?.navigationBar.backgroundColor = .systemBackground
        } else {
            navigationController?.navigationBar.backgroundColor = .white
        }
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func setupLabel() {
        view.addSubview(name)
        name.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        name.heightAnchor.constraint(equalToConstant: 100).isActive = true
        name.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        name.numberOfLines = 1
    }
    
    private func setupButtons() {
        
        view.addSubview(maskDetection)
        view.addSubview(faceDetection)
        view.addSubview(faceClassification)
        view.addSubview(faceRecognition)
        view.addSubview(emotionDetection)
        
        
        faceDetection.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        faceDetection.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        faceDetection.heightAnchor.constraint(equalToConstant: 70).isActive = true
        faceDetection.topAnchor.constraint(equalTo: faceClassification.topAnchor, constant: -90).isActive = true
        
        faceClassification.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        faceClassification.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        faceClassification.heightAnchor.constraint(equalToConstant: 70).isActive = true
        faceClassification.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -60).isActive = true
        
        faceRecognition.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        faceRecognition.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        faceRecognition.heightAnchor.constraint(equalToConstant: 70).isActive = true
        faceRecognition.topAnchor.constraint(equalTo: faceClassification.bottomAnchor, constant: 20).isActive = true
        
        emotionDetection.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emotionDetection.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        emotionDetection.heightAnchor.constraint(equalToConstant: 70).isActive = true
        emotionDetection.topAnchor.constraint(equalTo: faceRecognition.bottomAnchor, constant:
            20).isActive = true
        
        maskDetection.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        maskDetection.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        maskDetection.heightAnchor.constraint(equalToConstant: 70).isActive = true
        maskDetection.centerYAnchor.constraint(equalTo: emotionDetection.bottomAnchor, constant: 55).isActive = true
        
    }
    
    @objc func buttonToMaskDetection(_ sender: BtnPleinLarge) {
        
        let controller = MaskDetectionViewController()

        let navController = UINavigationController(rootViewController: controller)
        
        self.present(navController, animated: true, completion: nil)
    }
    
    @objc func buttonToFaceDetection(_ sender: BtnPleinLarge) {
           
       let controller = FaceDetectionViewController()

       let navController = UINavigationController(rootViewController: controller)
       
       self.present(navController, animated: true, completion: nil)
    }
    
    @objc func buttonToFaceClassification(_ sender: BtnPleinLarge) {
           
       let controller = FaceClassificationViewController()

       let navController = UINavigationController(rootViewController: controller)
       
       self.present(navController, animated: true, completion: nil)
    }
    
    @objc func buttonToFaceRecognition(_ sender: BtnPleinLarge) {
           
       let controller = FaceRecognitionViewController()

       let navController = UINavigationController(rootViewController: controller)
       
       self.present(navController, animated: true, completion: nil)
    }
    @objc func buttonToEmotionDetection(_ sender: BtnPleinLarge) {
           
       let controller = EmotionDetectionViewController()

       let navController = UINavigationController(rootViewController: controller)
       
       self.present(navController, animated: true, completion: nil)
    }

}



