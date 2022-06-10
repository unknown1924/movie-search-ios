//
//  StarredViewModel.swift
//  movie_list_searchable_api
//
//  Created by 10683830 on 06/06/22.
//

import SwiftUI

struct StarredViewModel: View {
    
    @Environment(\.managedObjectContext) private var managedObjectContext
    
    @FetchRequest(sortDescriptors: []) var companies: FetchedResults<MovieData>
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    
                    Button(action: {
                        withAnimation {
                            let temp = MovieData(context: managedObjectContext)
                            temp.title = "Iron Man"
                            temp.imdbID = "tt0371746"
                            PersistenceController.shared.saveContext()
                        }
                    }, label: {
                        Label("", systemImage: "plus.circle.fill")
                            .font(.title)
                            .foregroundColor(.green)
                    })
                    
                    Button(action: {
                        companies.forEach(managedObjectContext.delete)
                    }, label: {
                        Label("", systemImage: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.red)
                    })
                    
                }
                List {
                    ForEach(companies, id: \.self) { company in
                        
                        NavigationLink(destination: MovieDetailsViewModel(starred: true, searchID: company.imdbID ?? "")) {
                            HStack {
                                AsyncImage(url: URL(string: company.poster ?? "https://m.media-amazon.com/images/M/MV5BMTczNTI2ODUwOF5BMl5BanBnXkFtZTcwMTU0NTIzMw@@._V1_SX300.jpg")
                                           , content: { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: 100)
                                        .cornerRadius(10)
                                }, placeholder: {
                                    ProgressView()
                                })
                                
                                Text(" \(company.title ?? "")")
                                    .bold()
                            }
                        }
                    }
                    .onDelete(perform: deleteMovie)
                }
            }
            .navigationTitle("Favourites")
        }
    }
    
    
    private func deleteMovie(offsets: IndexSet) {
        withAnimation {
            offsets.map { companies[$0]}.forEach(managedObjectContext.delete)
            PersistenceController.shared.saveContext()
        }
    }
}

struct StarredViewModel_Previews: PreviewProvider {
    static var previews: some View {
        StarredViewModel()
            .environment(\.managedObjectContext, PersistenceController.shared.viewContext)
    }
}
