//
//  Movie.swift
//  movie_list_searchable_api
//
//  Created by 10683830 on 30/05/22.
//

import Foundation

struct MovieResponse: Decodable {
    let movies: [Movie]
    
    private enum CodingKeys: String, CodingKey {
        case movies = "Search"
    }
}

struct Movie: Decodable {
    let imdbID: String
    let title: String
    let poster: String
    let year: String
    
    private enum CodingKeys: String, CodingKey {
        case imdbID = "imdbID"
        case title = "Title"
        case poster = "Poster"
        case year = "Year"
    }
    
}
