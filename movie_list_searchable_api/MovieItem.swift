//
//  MovieItem.swift
//  movie_list_searchable_api
//
//  Created by 10683830 on 02/06/22.
//
// https://www.omdbapi.com/?i=tt0371746&apikey=ad354109

import Foundation

struct MovieItem: Decodable {
    let Title: String?
    let Year: String?
    let Rated: String?
    let Released: String?
    let Runtime: String?
    let Genre: String?
    let Director: String?
    let Actors: String?
    let Plot: String?
    let Awards: String?
    let Poster: String?
    let imdbRating: String?
    let imdbID: String?
}
