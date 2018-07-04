//
//  PopImageVC.swift
//  flickr-map-ios
//
//  Created by João Carlos Brandão on 09/09/17.
//  Copyright © 2017 BWmobi. All rights reserved.
//

import UIKit

class PopImageVC: UIViewController, UIGestureRecognizerDelegate {

    // Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dismissInfo: UILabel!
    
    // Variables
    var receivedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = receivedImage
        addSwipeDown()
    }

    func initView(withImage image: UIImage) {
        self.receivedImage = image
    }
    
    func addDoubleTap() {
        dismissInfo.text = "Double-tap to dismiss"
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(closeScreen))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delegate = self
        view.addGestureRecognizer(doubleTap)
    }
    
    func addSwipeDown() {
        dismissInfo.text = "Swipe-down to dismiss"
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(closeScreen))
        swipe.direction = .down
        view.addGestureRecognizer(swipe)
    }
    
    @objc func closeScreen() {
        dismiss(animated: true, completion: nil)
    }
    
}
