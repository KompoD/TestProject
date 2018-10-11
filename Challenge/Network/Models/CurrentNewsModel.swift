//
//  CurrentNewsModel.swift
//  Challenge
//
//  Created by Nikita Merkel on 11/10/2018.
//  Copyright © 2018 Nikita Merkel. All rights reserved.
//

// To parse the JSON, add this file to your project and do:
//
//   let currentNewsModel = try? newJSONDecoder().decode(CurrentNewsModel.self, from: jsonData)

import Foundation

struct CurrentNewsModel: Codable {
    let success: Bool?
    let data: DataModel?
}

struct DataModel: Codable {
    let news: NewsClass?
}

struct NewsClass: Codable {
    let id: Int?
    let slug, title: String?
    let link: String?
    let source: String?
    let createdAt, text: String?
    let imageURL, thumbnailURL: String?
    let teaser: String?
    let newsCategory: NewsCategoryClass?
    
    enum CodingKeys: String, CodingKey {
        case id, slug, title, link, source
        case createdAt = "created_at"
        case text
        case imageURL = "image_url"
        case thumbnailURL = "thumbnail_url"
        case teaser
        case newsCategory = "news_category"
    }
}

struct NewsCategoryClass: Codable {
    let id: Int?
    let title, slug: String?
}
