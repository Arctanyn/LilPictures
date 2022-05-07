//
//  PhotoResultModel.swift
//  LilPictures
//
//  Created by Малиль Дугулюбгов on 03.05.2022.
//

import Foundation

//MARK: PhotoResultModel

struct PhotoResultModel: Decodable {
    let results: [PhotoInfo]?
}

//MARK: - PhotoInfo

struct PhotoInfo: Decodable {
    let id: String?
    let width: Int?
    let height: Int?
    let color: String?
    let user: PhotoUser?
    let description: String?
    let urls: [PhotoURLType.RawValue: String]?
    
    enum PhotoURLType: String, Decodable {
        case raw
        case full
        case regular
        case small
        case thumb
    }
}

// MARK: - PhotoUser

struct PhotoUser: Decodable {
    enum CodingKeys: String, CodingKey {
        case id, username, name
        case firstName = "first_name"
        case lastName = "last_name"
        case instagramUsername = "instagram_username"
        case twitterUsername = "twitter_username"
        case portfolioURL = "portfolio_url"
        case profileImage = "profile_image"
    }
    
    let id, username, name, firstName: String?
    let lastName, instagramUsername, twitterUsername: String?
    let portfolioURL: String?
    let profileImage: [ProfilePicType.RawValue: String]
    
    enum ProfilePicType: String, Decodable {
        case small
        case medium
        case large
    }
}


