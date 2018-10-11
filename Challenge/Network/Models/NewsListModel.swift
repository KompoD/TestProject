//
//  DataModel.swift
//  Challenge
//
//  Created by Nikita Merkel on 10/10/2018.
//  Copyright © 2018 Nikita Merkel. All rights reserved.
//

import Foundation

struct NewsListModel: Codable {
    let success: Bool?
    let data: DataClass?
}

struct DataClass: Codable {
    let news: [News]?
    let meta: Meta?
}

struct Meta: Codable {
    let totalPages, totalCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case totalCount = "total_count"
    }
}

struct News: Codable {
    let id: Int?
    let slug: String?
    let link: String?
    let title: String?
    let statistics: Statistics?
    let createdAt: String?
    let imageURL, thumbnailURL: String?
    let newsCategory: NewsCategory?
    
    enum CodingKeys: String, CodingKey {
        case id, slug, link, title, statistics
        case createdAt = "created_at"
        case imageURL = "image_url"
        case thumbnailURL = "thumbnail_url"
        case newsCategory = "news_category"
    }
}

struct NewsCategory: Codable {
    let id: Int?
    let title, slug: String?
}

struct Statistics: Codable {
    let show, time, share, source: Bool?
    let perusal: Bool?
}
