//
//  FlickrServices.swift
//  flickr-map-ios
//
//  Created by João Carlos Brandão on 07/09/17.
//  Copyright © 2017 BWmobi. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage



class FlickrServices {
    
    // Singleton service
    static let instance = FlickrServices()
    
    // Constants
    let numberOfImagesToDownload = 80
    
    // Hold imges loaded
    fileprivate var lstImagesURL = [String]()
    var lstImages = [UIImage]()
    
    func retriveUrls(forAnnotation annotation: DroppablePin, handle: @escaping (_ finished: Bool) -> ()) {
        lstImagesURL = []
        
        Alamofire.request(flickrUrlApi(withAnnotation: annotation, andNumberOfPhotos: numberOfImagesToDownload)).responseJSON { (response) in
            guard let json = response.result.value as? Dictionary<String, AnyObject> else { return }
            let photosDictionary = json["photos"] as! Dictionary<String, AnyObject>
            let photosDictionaryArray = photosDictionary["photo"] as! [Dictionary<String, AnyObject>]

            for photo in photosDictionaryArray {
                let photoUrl = "https://farm\(photo["farm"]!).staticflickr.com/\(photo["server"]!)/\(photo["id"]!)_\(photo["secret"]!)_q.jpg"
                
                self.lstImagesURL.append(photoUrl)
            }
            
            handle(true)
        }
    }
    
    func retriveImages(closure: @escaping (Int) -> Void, handler: @escaping (_ finished: Bool) -> ()) {
        lstImages = []
        
        for url in lstImagesURL {
            Alamofire.request(url).responseImage(completionHandler: { (response) in
                guard let image = response.result.value else { return }
                self.lstImages.append(image)
                closure(self.lstImages.count)
                
                if self.lstImages.count == self.lstImagesURL.count {
                    handler(true)
                }
            })
        }
    }
    
    func cancelAllDownloadSessions() {
        lstImages.removeAll()
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach({ $0.cancel() })    // Cancel all session, where $0 is a temporaty variable
            downloadData.forEach({ $0.cancel() })
        }
    }
}
