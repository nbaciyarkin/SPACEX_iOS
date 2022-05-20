//
//  YoutubeResponseModel.swift
//  MobilliumProject
//
//  Created by Yarkın Gazibaba on 20.05.2022.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: IdVideoElement
}

struct IdVideoElement: Codable {
    let kind:String
    let videoId: String
}
