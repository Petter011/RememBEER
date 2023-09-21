//
//  Pictures.swift
//  Beer Tests
//
//  Created by Petter Gustafsson on 2023-08-05.
//
import SwiftUI
import PhotosUI
import Photos
import CoreData

struct PicturesView: View {
    @Environment(\.managedObjectContext) private var moc
    
    @State private var selectedImages: [UIImage] = []
    @State private var isShowingImagePicker = false
    @State private var isShowingFullScreenImage = false
    @State private var selectedImageIndex = 0
    @State private var isButtonTapped = false
    @State private var isLoadingImages = false
    
    @AppStorage("isBlurOn") private var isBlurOn = false
    @AppStorage("blurRadius") private var blurRadius = 10.0
    @State private var isFirstPictureAdded = UserDefaults.standard.bool(forKey: "isFirstPictureAdded")

    
    // Fetch images from Core Data
    @FetchRequest(entity: Picture.entity(), sortDescriptors: []) var pictures: FetchedResults<Picture>
    
    // Pagination variables
    private let batchSize = 10
    @State private var startIndex = 0
    
    let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 2), count: 4)
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("BackgroundImageBeer")
                    .resizable()
                    .edgesIgnoringSafeArea(.top)
                    .blur(radius: isBlurOn ? CGFloat(blurRadius) : 0)

                
                VStack {
                    Spacer()
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 2) {
                            ForEach(selectedImages.indices, id: \.self) { index in
                                Image(uiImage: selectedImages[index])
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .onTapGesture {
                                        selectedImageIndex = index
                                        isShowingFullScreenImage = true
                                    }
                                    .onAppear {
                                        // Load more images when reaching the end
                                        if !isLoadingImages && index == selectedImages.count - 1 && startIndex < pictures.count {
                                            loadMoreImages()
                                        }
                                    }
                            }
                        }
                        .padding()
                    }
                    
                    Button("Lägg till") {
                        isShowingImagePicker = true
                    }
                    .padding()
                    .frame(maxWidth: 120, maxHeight: 40)
                    .foregroundColor(.black)
                    .background(Color.orange)
                    .cornerRadius(15)
                    .font(.title3)
                    .shadow(radius: 40)
                    .offset(x: isButtonTapped ? -5 : 0, y: 0)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.4).repeatForever(autoreverses: true)) {
                            isButtonTapped.toggle()
                        }
                    }
                    .sheet(isPresented: $isShowingImagePicker) {
                        ImagePicker(selectedImages: $selectedImages, sourceType: .photoLibrary)
                            .onDisappear {
                                for image in selectedImages {
                                    saveImageToCoreData(image)
                                    
                                    // Set isFirstPictureAdded to true
                                        isFirstPictureAdded = true
                                        UserDefaults.standard.set(isFirstPictureAdded, forKey: "isFirstPictureAdded")

                                        // Apply blur when the first Picture is added
                                            isBlurOn = true
                                }
                                
                            }
                    }
                    .padding(.bottom, 20)
                }
                .navigationTitle("Bilder")
            }
            .onAppear {
                // Clear the selectedImages array
                selectedImages.removeAll()
                
                // Load initial batch of images
                loadImagesInRange()
            }
            .fullScreenCover(isPresented: $isShowingFullScreenImage) {
                TabView(selection: $selectedImageIndex) {
                    ForEach(selectedImages.indices, id: \.self) { index in
                        Image(uiImage: selectedImages[index])
                            .resizable()
                            .scaledToFit()
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .gesture(
                                   DragGesture()
                                       .onEnded { value in
                                           let screenWidth = UIScreen.main.bounds.width
                                           let screenHeight = UIScreen.main.bounds.height
                                           if value.translation.width < -screenWidth / 2, selectedImageIndex < selectedImages.count - 1 {
                                               selectedImageIndex += 1 // Swipe to the next image
                                           } else if value.translation.width > screenWidth / 2, selectedImageIndex > 0 {
                                               selectedImageIndex -= 1 // Swipe to the previous image
                                           } else if value.translation.height > screenHeight / 8 {
                                               isShowingFullScreenImage = false // Swipe down to close
                                           }
                                       }
                               )
                           }
                       }
                   } 
    
    // Load initial batch of images
    private func loadImagesInRange() {
        isLoadingImages = true
        
        let endIndex = min(startIndex + batchSize, pictures.count)
        for i in startIndex..<endIndex {
            if let imageData = pictures[i].imageData,
               let image = UIImage(data: imageData) {
                selectedImages.append(image)
            }
        }
        
        startIndex = endIndex
        isLoadingImages = false
    }
    
    // Load more images as the user scrolls
    private func loadMoreImages() {
        guard startIndex < pictures.count else {
            return // All images have been loaded
        }
        
        isLoadingImages = true
        
        let endIndex = min(startIndex + batchSize, pictures.count)
        for i in startIndex..<endIndex {
            if let imageData = pictures[i].imageData,
               let image = UIImage(data: imageData) {
                selectedImages.append(image)
            }
        }
        
        startIndex = endIndex
        isLoadingImages = false
    }
    
    private func saveImageToCoreData(_ image: UIImage) {
        let newPicture = Picture(context: moc)
        newPicture.id = UUID()
        newPicture.imageData = image.pngData()
        
        do {
            try moc.save()
        } catch {
            print("Error saving image: \(error.localizedDescription)")
        }
    }
}
