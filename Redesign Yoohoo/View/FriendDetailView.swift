import SwiftUI

struct FriendDetailView: View {
    @Bindable var friend: Buddy
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context

    @State private var showMenu = false
    @State private var showDeleteAlert = false
    @State private var showSaveSuccessAlert = false
    @State private var showSaveErrorAlert = false
    
    @State private var isEditing = false

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color("lightIndigo")
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 40) {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.backward.circle")
                                .resizable()
                                .foregroundStyle(.black)
                                .frame(width: 48, height: 48)
                        }

                        Spacer()

                        Button {
                            withAnimation {
                                showMenu.toggle()
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .resizable()
                                .foregroundStyle(.black)
                                .frame(width: 48, height: 48)
                        }
                    }
                    .padding(.horizontal, 32)

                    if let uiImage = loadImageFromDocuments(fileName: friend.image) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 336, height: 448)
                            .clipped()
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(.black, lineWidth: 3)
                            )
                    } else {
                        Image(systemName: friend.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 336, height: 448)
                            .foregroundColor(.gray)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray, lineWidth: 3)
                            )
                    }

                    VStack(spacing: 8) {
                        Text(friend.name)
                            .font(.system(.title, design: .rounded))
                            .foregroundStyle(Color("indigo3"))
                            .kerning(0.5)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .center)

                        Text(friend.experience)
                            .font(.system(.title3, design: .rounded))
                            .kerning(0.2)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxWidth: 337)
                }
            }

            // Menu Dropdown
            if showMenu {
                Color.black.opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showMenu = false
                        }
                    }

                VStack(alignment: .leading, spacing: 0) {
                    Button{
                        showMenu = false
                        isEditing = true
                    } label: {
                        Text("Ubah detail")
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .foregroundStyle(.black)
                            .font(.system(.title3, design: .rounded))
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    .contentShape(Rectangle())

                    Rectangle()
                            .fill(Color.black)
                            .frame(height: 3)

                    Button{
                        saveImageToPhotoLibrary()
                        showMenu = false
                    } label: {
                        Text("Unduh gambar")
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .foregroundStyle(.black)
                            .font(.system(.title3, design: .rounded))
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    .contentShape(Rectangle())

                    Rectangle()
                            .fill(Color.black)
                            .frame(height: 6)

                    Button(role: .destructive) {
                        showMenu = false
                        showDeleteAlert = true
                    } label: {
                        Text("Hapus")
                            .font(.system(.title3, design: .rounded))
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                           
                        
                    }
                    .contentShape(Rectangle())
                }
                .background(Color.white)
                .cornerRadius(16)
                .shadow(radius: 10)
                .frame(maxWidth: 245, alignment: .topTrailing)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.black, lineWidth: 3)
                    )
                .transition(.opacity)
                .padding(.trailing, 32) // sesuaikan dengan posisi tombol
                .padding(.top, 64)
            }
        }
        
        .navigationBarBackButtonHidden(true)
        
        // edit friend
        .navigationDestination(isPresented: $isEditing){
            EditFriendView(friend:friend)
        }
        .alert("Hapus Teman ini?", isPresented: $showDeleteAlert) {
            Button("Batal", role: .cancel) {}
            Button("Hapus", role: .destructive) {
                context.delete(friend)
                        dismiss()
            }
        } message: {
            Text("Tindakan ini tidak bisa dibatalkan.")
        }
        
        .alert("Berhasil", isPresented: $showSaveSuccessAlert) {
                    Button("Oke", role: .cancel) {}
                } message: {
                    Text("Gambar telah disimpan ke galeri.")
                }
                .alert("Gagal Menyimpan", isPresented: $showSaveErrorAlert) {
                    Button("Oke", role: .cancel) {}
                } message: {
                    Text("Terjadi kesalahan saat menyimpan gambar.")
                }
        
    }

    private func loadImageFromDocuments(fileName: String) -> UIImage? {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(fileName)
        return UIImage(contentsOfFile: url.path)
    }
    
    private func saveImageToPhotoLibrary() {
        if let uiImage = loadImageFromDocuments(fileName: friend.image) {
            let imageSaver = ImageSaver()
            imageSaver.successHandler = {
                showSaveSuccessAlert = true
            }
            imageSaver.errorHandler = {
                showSaveErrorAlert = true
            }
            imageSaver.writeToPhotoAlbum(image: uiImage)
        }
    }


}


#Preview {
    let dummyBuddy = Buddy(name: "Luna Salsabiila", image: "person.fill", experience: "Teman dekat dari kampus yang aktif dan ceria")
    FriendDetailView(friend: dummyBuddy)
}
