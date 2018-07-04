//
//  ViewController.swift
//  flickr-map-ios
//
//  Created by João Carlos Brandão on 07/09/17.
//  Copyright © 2017 BWmobi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController, UIGestureRecognizerDelegate {

    // Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imagesView: UIView!
    @IBOutlet weak var imagesViewHeightConstraint: NSLayoutConstraint!
    
    // Location
    fileprivate var locationManager = CLLocationManager()
    fileprivate let authorizationStatus = CLLocationManager.authorizationStatus()
    fileprivate let regionRadius: Double = 1000

    // Screen Animations
    fileprivate var imagesViewHeightSize: Double?
    fileprivate let screenSize = UIScreen.main.bounds
    
    fileprivate var spinner: UIActivityIndicatorView?
    fileprivate var yForSpinner: Double?
    fileprivate var progressLbl: UILabel?
    
    // Images Load
    fileprivate var collectionView: UICollectionView?
    fileprivate let sectionInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegate set
        mapView.delegate = self
        locationManager.delegate = self

        // Configurations
        setupLocationServices()
        addDoubleTapGestureRecognizer()
    }

    @IBAction func currentLocationBtnTapped(_ sender: Any) {
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            centerMapOnCurrentUserLocation()
            animateImagesViewDown()
        }
    }
    
    func addImageListView(atPosition frame : CGRect) {
        // Configurations for layout
        let floatLayout = UICollectionViewFlowLayout()
        floatLayout.scrollDirection = .vertical
        
        // Configurations for collection view
        collectionView = UICollectionView(frame: frame, collectionViewLayout: floatLayout)
        collectionView?.register(PhotoCell.self, forCellWithReuseIdentifier: "photoCell")
        collectionView?.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.1458791813)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        imagesView.addSubview(collectionView!)
    }
    
    func addDoubleTapGestureRecognizer() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(dropPin(sender:)))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delegate = self
        mapView.addGestureRecognizer(doubleTap)
    }
    
    func addImagesViewSwipeDown() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(animateImagesViewDown))
        swipe.direction = .left
        imagesView.addGestureRecognizer(swipe)
    }
    
    func addImagesViewSpinner() {
        spinner = UIActivityIndicatorView()
        let xForSpinner = ((screenSize.width / 2) - ((spinner?.frame.width)! / 2))
        yForSpinner = (imagesViewHeightSize! / 2)
        spinner?.center = CGPoint(x: CGFloat(xForSpinner), y: CGFloat(yForSpinner!))
        spinner?.activityIndicatorViewStyle = .whiteLarge
        spinner?.color = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        spinner?.startAnimating()
        collectionView?.addSubview(spinner!)
    }
    
    func removeImagesViewSpinner() {
        if spinner != nil {
            spinner?.removeFromSuperview()
        }
    }
    
    func addImagesViewProgressLbl() {
        progressLbl = UILabel()
        progressLbl?.frame = CGRect(x: ((screenSize.width / 2) - 100), y: CGFloat(yForSpinner! + 25), width: 200, height: 40)
        progressLbl?.font = UIFont(name: "Avenir Next", size: 18)
        progressLbl?.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        progressLbl?.textAlignment = .center
        collectionView?.addSubview(progressLbl!)
    }
    
    func removeImagesViewProgressLbl() {
        if progressLbl != nil {
            progressLbl?.removeFromSuperview()
        }
    }
    
    func animateImagesViewUp() {
        let mapViewHeightMinSize: Double = 0.35 // % representation
        //let mapViewHeight = mapView.frame.height
        let mainViewHeight = self.view.frame.height
        imagesViewHeightSize = (Double(mainViewHeight) - (Double(mainViewHeight) * mapViewHeightMinSize))
        
        imagesViewHeightConstraint.constant = CGFloat(imagesViewHeightSize!)
        UIView.animate(withDuration: 0.3){
            self.view.layoutIfNeeded()
        }
        
        collectionView?.frame = imagesView.bounds
        
        addImageListView(atPosition: imagesView.bounds)
        addImagesViewSwipeDown()
        addImagesViewSpinner()
        addImagesViewProgressLbl()

    }
    
    @objc func animateImagesViewDown() {
        imagesViewHeightConstraint.constant = 0
        UIView.animate(withDuration: 0.3){
            self.view.layoutIfNeeded()
        }
        removeDroppedPin()
        removeImagesViewSpinner()
        removeImagesViewProgressLbl()
        FlickrServices.instance.cancelAllDownloadSessions()
        collectionView?.reloadData()
    }
    
    
}

extension MapVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
}

extension MapVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FlickrServices.instance.lstImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCell else {
            return UICollectionViewCell()
        }
        let imageCell = UIImageView(image: FlickrServices.instance.lstImages[indexPath.row])
        cell.addSubview(imageCell)
        
//        print("Images for item: \(indexPath.row)")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let popImageVC = storyboard?.instantiateViewController(withIdentifier: "popImageVC") as? PopImageVC else { return }
        popImageVC.initView(withImage: FlickrServices.instance.lstImages[indexPath.row])
        present(popImageVC, animated: true, completion: nil)
    }
}

extension MapVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "droppablePin")
        pinAnnotation.pinTintColor = #colorLiteral(red: 0.9771530032, green: 0.7062081099, blue: 0.1748393774, alpha: 1)
        pinAnnotation.animatesDrop = true
        return pinAnnotation
    }
    
    func centerMapOnCurrentUserLocation(location: MKCoordinateRegion? = nil) {
        guard let coordinate = locationManager.location?.coordinate else { return }
        if let _ = location {
            mapView.setRegion(location!, animated: true)
        } else {
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, (regionRadius * 2.0), (regionRadius * 2.0))
            mapView.setRegion(coordinateRegion, animated: true)
            removeDroppedPin()
        }
    }
    
    @objc func dropPin(sender: UITapGestureRecognizer) {
        removeDroppedPin()
        removeImagesViewSpinner()
        removeImagesViewProgressLbl()
        FlickrServices.instance.cancelAllDownloadSessions()
        collectionView?.reloadData()
        
        let touchPoint = sender.location(in: mapView)
        let touchCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        let annotation = DroppablePin(coordinate: touchCoordinate, identifier: "droppablePin")
        mapView.addAnnotation(annotation)
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(touchCoordinate, (regionRadius * 2.0), (regionRadius * 2.0))
        
        animateImagesViewUp()
        
        FlickrServices.instance.retriveUrls(forAnnotation: annotation) { (finished) in
            if finished {
                FlickrServices.instance.retriveImages(closure: self.updateDonwloadProgress, handler: { (finished) in
                    if finished {
                        self.removeImagesViewSpinner()
                        self.removeImagesViewProgressLbl()
                        self.collectionView?.reloadData()
                    }
                })
            }
        }
        
        centerMapOnCurrentUserLocation(location: coordinateRegion)
    }
    
    func removeDroppedPin() {
        for annotation in mapView.annotations {
            mapView.removeAnnotation(annotation)
        }
    }
    
    func updateDonwloadProgress(value: Int) -> Void {
        progressLbl?.text = "\(value)/\(FlickrServices.instance.numberOfImagesToDownload) Photos loaded"
    }
    
}

extension MapVC: CLLocationManagerDelegate {
    
    func setupLocationServices() {
        if authorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else {
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        centerMapOnCurrentUserLocation()
    }
    
}


