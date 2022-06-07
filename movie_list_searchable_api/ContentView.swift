//
//  ContentView.swift
//  movie_list_searchable_api
//
//  Created by 10683830 on 30/05/22.
//

import SwiftUI

extension View {
    func Print(_ vars: Any...) -> some View {
        for v in vars { print(v) }
        return EmptyView()
    }
}

struct ContentView: View {
    
    //    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var movieListVM = MovieListViewModel()
    @State private var searchText: String = ""
    
    //    @FetchRequest(
    //        sortDescriptors: [NSSortDescriptor(keyPath: \Company.name, ascending: true)],
    //        animation: .default)
    //    private var companies: FetchedResults<Company>
    //
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: StarredViewModel()) {
                    Text("Favourites")
                }
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
                            Text(movie.title)
                        }
                    }
                }.listStyle(.plain)
                    .searchable(text: $searchText)
                    .onChange(of: searchText) { value in
                        Task {
                            if !value.isEmpty &&  value.count > 2 {
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
    //    func addText() {
    //        withAnimation {
    //            let newCompany = Company(context: viewContext)
    //            newCompany.name = searchText
    //            PersistenceController.shared.saveContext()
    ////            companyName = ""
    //        }
    //    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        //            .environment(\.managedObjectContext, PersistenceController.preview.viewContext)
    }
}
