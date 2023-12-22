




import SwiftUI
import PhotosUI
import Foundation

extension View {
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct AddBeerView: View {
    @State private var beerNote: String = ""
    @State private var beerType: String = ""
    @State private var beerName: String = ""
    @State private var beerPoints: Int16 = 0
    @State private var beerPointsOptions: [Int16] = Array(0...10)
    @State private var beerImageData: Data?
    @State private var selectedImages: [UIImage] = []
    @State private var showingImagePicker = false
    @State private var showError = false

    
    let onSave: (BeerWithImage, String) -> Void
    
    @Binding var selectedBeerType: String?
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Group {
                    TextField("Which type of beer? e.g. IPA, APA", text: $beerType)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.default)
                        .padding(.top, 10)
                        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
                            beerType = beerType.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
                        }
                    
                    TextField("Name of the beer?", text: $beerName)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.default)
                    
                    TextField("Add a Note", text: $beerNote, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.default)
                        .lineLimit(3, reservesSpace: true)
                        
                    
                    VStack{
                        VStack(alignment: .center) {
                            Text("Rating (0-10)")
                                .bold()
                                .foregroundColor(Color.black)
                                .underline()
                            Picker("Rating (0-10)", selection: $beerPoints) {
                                ForEach(beerPointsOptions, id: \.self) {
                                    Text("\($0)")
                                }
                            }
                            .pickerStyle(.wheel)
                            .onAppear {
                                beerPoints = 5
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                Button {
                    showingImagePicker.toggle()
                } label: {
                    Text("Take a picture")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: 150, maxHeight: 50)
                        .fontWeight(.bold)
                }
                .background(.linearGradient(colors: [.orange, .black], startPoint: .top, endPoint: .bottomTrailing))
                .cornerRadius(20)
                .shadow(color: .orange , radius: 5, y: 3)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white, lineWidth: 1))
                .sheet(isPresented: $showingImagePicker) {
                    ImagePicker(selectedImages: $selectedImages, sourceType: .photoLibrary)
                }
                
                if let selectedImage = selectedImages.last {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .padding(.top,10)
                }
                    
                Spacer()
                
                Button {
                    if selectedImages.isEmpty || beerType.isEmpty {
                        showError = true
                    } else {
                        if let lastImage = selectedImages.last,
                           let imageData = lastImage.jpegData(compressionQuality: 1.0) {
                            let newBeer = BeerWithImage(beerType: beerType, beerPoints: beerPoints, beerName: beerName, beerImageData: imageData, beerNote: beerNote)
                            
                            onSave(newBeer, beerType)
                            isPresented = false
                        }
                    }
                } label: {
                    Text("Save")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .frame(maxWidth: 200, maxHeight: 60)

                }
                .background(Color.orange)
                .cornerRadius(40)
                .shadow(color: .orange, radius: 5, y: 3)
                .overlay(RoundedRectangle(cornerRadius: 40).stroke(Color.black, lineWidth: 1))
            }
            .ignoresSafeArea(.keyboard)
            .navigationBarTitle("Add new beer", displayMode: .inline)
            .onTapGesture {
                self.endEditing()
            }
            .alert(isPresented: $showError) {
                Alert(
                    title: Text("Error"),
                    message: Text("You need to enter beer type and take a picture before saving."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

