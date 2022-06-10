//
//  searchTab.swift
//  movie_list_searchable_api
//
//  Created by 10683830 on 07/06/22.
//
import Foundation

import SwiftUI



//extension View {
//
//    func Print(_ vars: Any...) -> some View {
//
//        for v in vars { print(v) }
//
//        return EmptyView()
//
//    }
//
//}
//


struct SearchTab : View{
    
    @StateObject private var movieListVM = MovieListViewModel()
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationView {
            
            VStack {
                
                List(movieListVM.movies, id: \.imdbId) {
                    
                    movie in
                    
                    NavigationLink(destination: MovieDetailsViewModel(starred: false, searchID: movie.imdbId)) {
                        
                        HStack {
                            
                            AsyncImage(url: movie.poster
                                       
                                       , content: { image in
                                
                                image.resizable()
                                
                                    .aspectRatio(contentMode: .fit)
                                
                                    .frame(maxWidth: 50)
                                
                            }, placeholder: {
                                
                                ProgressView()
                                
                            })
                            
                            VStack {
                                HStack {
                                    Text(movie.title)
                                        .padding(.top)
                                    Spacer()
                                }
                                HStack {
                                    Text(movie.year)
                                        .padding(.bottom)
                                        .font(.footnote)
                                        .foregroundColor(.orange)
                                    Spacer()
                                }
                                    Spacer()
                            }
                        }
                        
                    }
                    
                }.listStyle(.plain)
                
                    .searchable(text: $searchText)
                
                    .onChange(of: searchText) { value in
                        
                        Task {
                            
                            if !value.isEmpty &&  value.count > 1 {
                                
                                await movieListVM.search(name: value)
                                
                            } else {
                                
                                movieListVM.movies.removeAll()
                            }
                            
                        }
                        
                    }
                    .navigationTitle("Movies")

            }
            
        }
        
    }
}
