//
//  AudioRecording.swift
//  Pitch Perfect
//
//  Created by Naresh Chavda on 3/22/15.
//  Copyright (c) 2015 Naresh Chavda. All rights reserved.
//

import Foundation

class AudioRecording: NSObject {
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL!, title: String!){
        self.filePathUrl = filePathUrl
        self.title = title
    }
}


