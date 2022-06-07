//
//  MovieDetailsViewModel.swift
//  movie_list_searchable_api
//
//  Created by 10683830 on 02/06/22.
//

import SwiftUI

class ViewModel: ObservableObject {
    @Published var movieItem: MovieItem = MovieItem(Title: "", Year: "", Rated: "", Released: "", Runtime: "", Genre: "", Director: "", Actors: "", Plot: "", Awards: "", Poster: "", imdbRating: "", imdbID: "")
    
//    @Published var movieItem: MovieItem
    func fetch(searchID: String) {
        
        let urlString = "https://www.omdbapi.com/?i=\(searchID)&apikey=ad354109"

        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {
            [weak self]data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let movies = try JSONDecoder().decode(MovieItem.self, from: data)
                
                DispatchQueue.main.async {
                    self?.movieItem = movies
                }
            } catch {
                print(error)
            }
        }
        task.resume()

    }
}

struct MovieDetailsViewModel: View {
    
    var starred: Bool
    var searchID: String
    @StateObject var viewModel = ViewModel()
    @Environment(\.managedObjectContext) private var managedObjectContext
    
    @State var isStarred: Bool = false

//
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Company.name, ascending: true)],
//        animation: .default)
//    private var companies: FetchedResults<Company>
    
    var body: some View {
                ScrollView(.vertical) {
                    HStack {
                        Spacer()
                        Button(action: addMovie, label: {
                            !starred && isStarred ? Label("", systemImage: "star")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                            :
                            Label("", systemImage: "star.fill")
                                .font(.largeTitle)
                                .foregroundColor(.blue)

                        })
//                        Button(action: addMovie) {
//                            Label("", systemImage: "star")
//                                .font(.largeTitle)
//                                .foregroundColor(.blue)
//                        }
                            
                    }
                    VStack {
//                        Text("Temp: \(temp)")
//                        List {
//                            ForEach(companies) { company in
//                                Text(company.title ?? "wrong text")
//                                Print(company.title ?? "wrong print")
//                            }
//                        }
                 
                        AsyncImage(url: URL(string: viewModel.movieItem.Poster ?? ""), content: { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
            //                    .frame(maxWidth: 100)
                            }, placeholder: {
                                ProgressView()
                            })

                        VStack {
                            Text(viewModel.movieItem.Genre ?? "")
                                .font(.body)
                            HStack {
//                                Text(".")
                                Text(viewModel.movieItem.Runtime ?? "")
                                Text(".")
                                Text(viewModel.movieItem.Released ?? "")
//                                Spacer()
                            }
                        }
                        
                        Text(viewModel.movieItem.Plot ?? "")
                            .italic()
                            .padding(5)
                            .background(.yellow)
                            .cornerRadius(10)
                        
                        HStack {
                            Text("Release Date: ")
                                .bold()
                                .foregroundColor(.blue)
                            Text(viewModel.movieItem.Released ?? "")
                        }
                        Text(viewModel.movieItem.Awards ?? "")
                        Text(viewModel.movieItem.Actors ?? "")
                        Text(viewModel.movieItem.imdbID ?? "")
                        Text(viewModel.movieItem.imdbRating ?? "")
                    }
                    .onAppear {
                        viewModel.fetch(searchID: searchID)
                        addMovie()
                    }
                }
                 .navigationTitle(viewModel.movieItem.Title ?? "")
//        Print(companies.first?.title ?? "")
    }
    private func addMovie() {
        
        withAnimation {
            isStarred.toggle()
            
            let newCompany = Company(context: managedObjectContext)
//            temp = viewModel.movieItem.Title
            newCompany.title = viewModel.movieItem.Title
//            newCompany.name = viewModel.movieItem.Genre
//            temp = newCompany.title ?? "errrorr"
            newCompany.imdbID = viewModel.movieItem.imdbID
            newCompany.poster = viewModel.movieItem.Poster
//            Print(newCompany.title ?? "wrong")
//            Print(viewModel.movieItem.Title ?? "wrong print in addMovie()")
//            if newCompany.title != "" {
                Print(newCompany.title ?? "Title")
                Print(newCompany.imdbID ?? "imdbID")
                PersistenceController.shared.saveContext()
//            }
        }
    }
}

struct MovieDetailsViewModel_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailsViewModel(starred: false, searchID: "tt0371746")
            .environment(\.managedObjectContext, PersistenceController.preview.viewContext)
    }
}



// tt0312528
