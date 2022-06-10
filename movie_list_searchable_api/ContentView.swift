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

    var body :some View{

        TabView{
            withAnimation {
                SearchTab()

                    .tabItem{
                        VStack{
                            Image(systemName: "magnifyingglass")
                            Text("Search")
                        }
                    }.tag(0)

            }
            withAnimation {
                StarredViewModel()

                    .tabItem{

                        VStack{

                            Image(systemName: "star.fill")

                            Text("Favourites")

                        }

                    }

                    .tag(1)
            }

        }

    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
