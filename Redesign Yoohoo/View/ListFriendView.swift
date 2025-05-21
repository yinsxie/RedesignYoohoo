//
//  ContentView.swift
//  Redesign Yoohoo
//
//  Created by Amelia Morencia Irena on 09/05/25.
//

import SwiftData
import SwiftUI


struct ListFriendView: View {
    @Environment(\.modelContext) private var context
    @State private var showAddFriend = false
    @State private var searchText = ""
    @State private var selectedSort: SortOption = .az
    @State private var showSortMenu = false
    
    
    @Query(sort: \Buddy.name, order: .forward) private var friends: [Buddy]
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var filteredAndSortedFriends: [Buddy] {
            let filtered = friends.filter { friend in
                searchText.isEmpty || friend.name.localizedCaseInsensitiveContains(searchText)
            }

            switch selectedSort {
            case .az:
                return filtered.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
            case .za:
                return filtered.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedDescending }
            case .latest:
                return filtered.sorted { $0.createdAt > $1.createdAt }
            case .earliest:
                return filtered.sorted { $0.createdAt < $1.createdAt }
            }
        }
    
    var body: some View {
        
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                Color("lightIndigo")
                    .ignoresSafeArea()
                ScrollView {
                    VStack (alignment: .leading, spacing: 8) {
                        Text("Daftar Teman")
                            .font(.system(.largeTitle, design: .rounded))
                            .fontWeight(.bold)
                            .kerning(1.24)
                        
                        Text("Jelajahi momen seru bersama teman")
                            .font(.system(.title3, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundStyle(.black.opacity(0.58))
                            .kerning(0.5)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    
                    //            searchbar
                    //            sorting
                    HStack{
                        TextField("Cari nama temanmu", text: $searchText)
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                            .padding(16)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 28))
                            .overlay(
                                RoundedRectangle(cornerRadius: 28)
                                    .stroke(Color("indigo3"), lineWidth: 3)
                            )
                            .frame(maxWidth: .infinity, maxHeight: 48)
                        Spacer()
                        
                        Button {
                            withAnimation {
                                showSortMenu.toggle()
                            }
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .font(.system(size: 48))
                                .foregroundStyle(.black)
                                .padding(10)
                                .clipShape(Circle())
                    
                        }
                        
                    }
                    
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    
                    
                    
                    
                    LazyVGrid(columns: columns, spacing: 24) {
                        if searchText.isEmpty {
                            Button {
                                showAddFriend = true
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color("indigo3"), lineWidth: 3)
                                        .frame(maxWidth: 154, maxHeight: 188)
                                    
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(Color.white)
                                        .stroke(Color("indigo3"), lineWidth: 6)
                                    
                                        .frame(width: 60, height: 60)
                                        .overlay(
                                            Image(systemName: "plus.app.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .foregroundColor(.indigo)
                                        )
                                    
                                }
                                .frame(maxWidth: 173, maxHeight: 207)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color("indigo3"), lineWidth: 3)
                                )
                            }
                        }
                        
                        ForEach(filteredAndSortedFriends) { friend in
                            FriendCardView(friend: friend)
                        }
                    }
                    
                    .padding()
                }
                
                
                if showSortMenu {
                    VStack(spacing: 0) {
                        ForEach(SortOption.allCases, id: \.self) { option in
                            Button {
                                selectedSort = option
                                showSortMenu = false
                            } label: {
                                Text(option.rawValue)
                                    .font(.system(.subheadline, design: .rounded))
                                    .foregroundColor(.black)
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                            }
                            
                            if option != SortOption.allCases.last {
                                Rectangle()
                                        .fill(Color.black)
                                        .frame(height: 3)
                            }
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.black, lineWidth: 3)
                            .background(Color.white.cornerRadius(12))
                    )
                    .frame(width: 180)
                    .padding(.trailing, 24)
                    .padding(.top, 180)
                    .zIndex(1)
                }
            }
            
        }
        .sheet(isPresented: $showAddFriend) {
            NavigationStack{
                FormView()
            }
            // sheet
            
            
        } // nav stack
    } // view
} // struct

struct FriendCardView: View {
    let friend: Buddy
    var body: some View {
        ZStack(alignment:.top) {
            
            
            if let uiImage = loadImageFromDocuments(fileName: friend.image) {
                Image(uiImage: uiImage)
                
                    .resizable()
                    .frame(width: 157, height: 188)
                    .aspectRatio(4/3, contentMode: .fill)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("indigo3"), lineWidth: 3)
                    )
                
                
                    .padding(9.5)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color("indigo3"), lineWidth: 3)
                    )
            }
            NavigationLink(destination: FriendDetailView(friend: friend)){
                HStack{
                    Text(friend.name)
                        .fontWeight(.bold)
                        .font(.system(.subheadline, design: .rounded))
                    
                    Spacer(minLength: 8)
                    Image(systemName: "chevron.right")
                        .fontWeight(.bold)
                }
                
                .font(.footnote)
                .foregroundColor(Color("indigo3"))
                .frame(width: 108, height: 30)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("indigo3"), lineWidth: 3)
                )
            }
            
            .offset(y: -18) // naik ke atas card
        }
        .frame(width: 161.25, height: 207 + 20)
        
    }
    private func loadImageFromDocuments(fileName: String) -> UIImage? {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
        return UIImage(contentsOfFile: url.path)
    }
    
}

#Preview {
    ListFriendView()
}
