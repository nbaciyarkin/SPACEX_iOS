//
//  LaunchModel.swift
//  MobilliumProject
//
//  Created by Yarkın Gazibaba on 16.05.2022.
//

import Foundation

struct LaunchesModelResponse: Codable {
    let launchResults: [LaunchesModel]
}

struct LaunchesModel: Codable {
    let name: String?
    let date_local: String?
    let flight_number: Int?
    let details: String?
    let links: LinkModel?
}

struct LinkModel: Codable {
    let patch: PatchModel?
    let youtube_id: String?
    let article: String?
}


struct PatchModel: Codable {
    let small: String?
    let large: String?
}

