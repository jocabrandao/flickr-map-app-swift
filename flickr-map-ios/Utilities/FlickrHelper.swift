//
//  Constants.swift
//  flickr-map-ios
//
//  Created by João Carlos Brandão on 07/09/17.
//  Copyright © 2017 BWmobi. All rights reserved.
//

import Foundation

let FLICKR_API_KEY = "SUA-CHAVE-DE-API"

func flickrUrlApi(withAnnotation annotation: DroppablePin, andNumberOfPhotos numberPhotos: Int) -> String {
    
    return "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(FLICKR_API_KEY)&lat=\(annotation.coordinate.latitude)&lon=\(annotation.coordinate.longitude)&radius=1&radius_units=km&per_page=\(numberPhotos)&format=json&nojsoncallback=1"
    
}
