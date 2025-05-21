//
//  EditFriendView.swift
//  Redesign Yoohoo
//
//  Created by Amelia Morencia Irena on 15/05/25.
//

import SwiftUI

struct EditFriendView: View {
    @Bindable var friend: Buddy
    @Environment(\.dismiss) var dismiss
    
    @State private var newName: String
    @State private var newExperience: String
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var imageSource: UIImagePickerController.SourceType = .camera
    @State private var showSourceSelection = false
    
    //    @State private var newImage: UIImage?
    
    init(friend: Buddy) {
        self.friend = friend
        _newName = State(initialValue: friend.name)
        _newExperience = State(initialValue: friend.experience)
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Ubah Detail Teman")
                .font(.system(.largeTitle, design: .rounded, weight: .bold))
                .padding(.top)
            
            ZStack(alignment: .topTrailing) {
                // Foto utama (bisa selectedImage dulu, kalau gak ada load dari dokumen)
                if let newImage = selectedImage {
                    Image(uiImage: newImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 266) // 3:4 ratio
                        .clipped()
                        .mask(RoundedRectangle(cornerRadius: 20))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.black, lineWidth: 3)
                        )
                    
                } else if let oldImage = loadImageFromDocuments(fileName: friend.image) {
                    Image(uiImage: oldImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 266)
                        .clipped()
                        .mask(RoundedRectangle(cornerRadius: 20))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.black, lineWidth: 3)
                        )
                    
                } else {
                    Image(systemName: "person.crop.square")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 266) // 3:4 ratio
                        .clipped()
                        .mask(RoundedRectangle(cornerRadius: 20))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.black, lineWidth: 3)
                        )

                    
                }
                
                // Tombol retake foto kecil di pojok kanan atas
                Button {
                    showSourceSelection = true
                } label: {
                    Image(systemName: "camera.fill")
                        .padding(12)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .padding(1)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.black, lineWidth: 3)
                        )
                        .padding(.top, 12)       // Geser turun sedikit dari atas
                        .padding(.trailing, 12)
                }
            }
            
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Nama Teman:")
                    .font(.system(.title3, design: .rounded, weight: .semibold))
                    .padding(.horizontal)
                TextField("Nama", text: $newName)
                //                    .textFieldStyle(.roundedBorder)
                    .font(.system(.subheadline, design: .rounded, weight: .medium))
                    .padding(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 28)
                            .stroke(Color(.black), lineWidth: 3)
                    )
                    .padding(.horizontal)
            }
            
            VStack(alignment: .leading, spacing: 8){
                Text("Deskripsi Teman:")
                    .font(.system(.title3, design: .rounded, weight: .semibold))
                    .padding(.horizontal)
                TextEditor(text: $newExperience)
                    .frame(minHeight: 100)
                    .font(.system(.subheadline, design: .rounded, weight: .medium))
                    .padding(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 28)
                            .stroke(Color.black, lineWidth: 3)
                    )
                    .padding(.horizontal)
            }
            
            
            Spacer()
        }
        //        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Batal") {
                    dismiss()
                }
                .foregroundColor(.red)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Simpan") {
                    friend.name = newName
                    friend.experience = newExperience
                    
                    if let newPhoto = selectedImage {
                        // Simpan image ke dokumen dengan nama file baru
                        if let data = newPhoto.jpegData(compressionQuality: 0.8) {
                            let filename = UUID().uuidString + ".jpg"
                            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)
                            do {
                                try data.write(to: url)
                                friend.image = filename
                            } catch {
                                print("Gagal menyimpan foto: \(error.localizedDescription)")
                            }
                        }
                    }
                    
                    dismiss()
                }
                .fontWeight(.bold)
                
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage, sourceType: imageSource)
        }
        .confirmationDialog("Pilih Sumber Foto", isPresented: $showSourceSelection, titleVisibility: .visible) {
            Button("Ambil dari Kamera") {
                imageSource = .camera
                showImagePicker = true
            }
            Button("Pilih dari Galeri") {
                imageSource = .photoLibrary
                showImagePicker = true
            }
            Button("Batal", role: .cancel) {}
        }
        
        .onAppear {
            // Load image dari friend.image (nama file) jika ada
            if !friend.image.isEmpty {
                selectedImage = loadImageFromDocuments(fileName: friend.image)
            }
        }
    }
    
    
    func saveImageToDocuments(image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        let filename = UUID().uuidString + ".jpg"
        let url = getDocumentsDirectory().appendingPathComponent(filename)
        do {
            try data.write(to: url)
            return filename
        } catch {
            print("Gagal simpan gambar: \(error)")
            return nil
        }
    }
    
    // Fungsi load UIImage dari dokumen app berdasarkan nama file
    func loadImageFromDocuments(fileName: String) -> UIImage? {
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        if let data = try? Data(contentsOf: url) {
            return UIImage(data: data)
        }
        return nil
    }
    
    // Dapatkan URL folder dokumen app
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
