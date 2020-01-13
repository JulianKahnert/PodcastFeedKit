/**
 Category.swift
 PodcastFeedKit
 Copyright (c) 2020 Callum Kerr-Edwards
 */

import Foundation

/// Categories found from https://help.apple.com/itc/podcasts_connect/#/itc9267a2f12

enum Category {
    case arts
    case books
    case design
    case fashionAndBeauty
    case food
    case performingArts
    case visualArts
    
    case business
    
    case comedy
    
    case education
    
    case fiction
    case comedyFiction
    case drama
    case scienceFiction
    
    case government
    
    case history
    
    case healthAndFitness
    
    case kidsAndFamily
    
    case leisure
    
    case music
    
    case news
    
    case religionAndSpirituality
    
    case science
    
    case societyAndCulture
    
    case sports
    
    case technology
    
    case trueCrime
    
    case tvAndFilm
    case afterShows
    case filmHistory
    case filmInterviews
    case filmReviews
    case tvReviews
    
    
    public var parent: String {
        switch self {
        case .arts, .books, .design, .fashionAndBeauty, .food, .performingArts, .visualArts:
            return "Arts"
        case .business:
            return "Business"
        case .comedy:
            return "Comedy"
        case .education:
            return "Education"
        case .fiction, .comedyFiction, .drama, .scienceFiction:
            return "Fiction"
        case .government:
            return "Government"
        case .history:
            return "History"
        case .healthAndFitness:
            return "Health & Fitness"
        case .kidsAndFamily:
            return "Kids & Family"
        case .leisure:
            return "Leisure"
        case .music:
            return "Music"
        case .news:
            return "News"
        case .religionAndSpirituality:
            return "Religion & Spirituality"
        case .science:
            return "Science"
        case .societyAndCulture:
            return "Society & Culture"
        case .sports:
            return "Sports"
        case .technology:
            return "Technology"
        case .trueCrime:
            return "True Crime"
        case .tvAndFilm, .afterShows, .filmHistory, .filmInterviews, .filmReviews, .tvReviews:
            return "TV & Film"
            
        }
    }
    
    public var subcategory: String? {
        switch self {
        case .arts, .business, .comedy, .education, .fiction, .government, .history, .healthAndFitness, .kidsAndFamily, .leisure,
             .music, .news, .religionAndSpirituality, .science, .societyAndCulture, .sports, .technology, .trueCrime, .tvAndFilm:
            return nil
        case .books:
            return "Books"
        case .design:
            return "Design"
        case .fashionAndBeauty:
            return "Fashion & Beauty"
        case .food:
            return "Food"
        case .performingArts:
            return "Performing Arts"
        case .visualArts:
            return "Visual Arts"
        case .comedyFiction:
            return "Comedy Fiction"
        case .drama:
            return "Drama"
        case .scienceFiction:
            return "Science Fiction"
        case .afterShows:
            return "After Shows"
        case .filmHistory:
            return "Film History"
        case .filmInterviews:
            return "Film Interviews"
        case .filmReviews:
            return "Film Reviews"
        case .tvReviews:
            return "TV Reviews"
        }
    }
}
