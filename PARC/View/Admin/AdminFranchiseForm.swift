//
//  AdminFranchiseForm.swift
//  PARC
//
//  Created by Ayman Ali on 06/11/2023.
//

import SwiftUI

// This view is responsible for handling all form interactions when an admin wants to create franchises
struct AdminFranchiseForm: View {
    @State var name = ""
    @State var logo = ""
    @State var description = ""
    @State var no_of_franchises = ""
    @State var mom_revenue = ""
    @State var startup_capital = ""
    @State var month_rev_18 = ""
    @State var ebitda_estimate = ""
    @State var is_description_valid = false
    @State var show_logo_image_picker = false
    @State var show_display_image_picker = false
    @State var logo_image: UIImage?
    @Binding var franchise_form_shown: Bool
    @Binding var franchise_data: [DropdownMenuOption]
    @State var logo_path = ""
    @State var display_path = ""
    var valid_form_inputs: Bool {
        name.count>0 && description.count>0 && no_of_franchises.count>0 && mom_revenue.count>0 && startup_capital.count>0 && month_rev_18.count>0 && ebitda_estimate.count>0 && logo_image != nil
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                Color(.white).ignoresSafeArea()
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        HStack {
                            Text("Create Franchise")
                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.065))
                                .padding(.bottom, -5).padding(.top, 10)
                            Spacer()
                        }
                        
                        Divider()
                            .frame(height: 1)
                            .overlay(.black)
                            .padding(.bottom, 5)
                        
                        HStack {
                            Text("Name").font(Font.custom("Nunito-Bold", size: 18))
                                .padding(.bottom, -5).padding(.leading,2.5)
                            
                            Spacer()
                        }
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.black, lineWidth: 1.25)
                                )
                                .frame(width: max(0, geometry.size.width - 45), height: 50)
                            
                            TextField("", text: $name, prompt: Text("McDonald's").foregroundColor(.gray).font(Font.custom("Nunito-Medium", size: 16))).padding().frame(width: max(0, geometry.size.width-40), height: 50)
                                .foregroundColor(.black)
                                .cornerRadius(5)
                                .font(Font.custom("Nunito-SemiBold", size: 16))
                        }
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("Logo")
                                    
                                    if let image = self.logo_image {
                                        Text("✅")
                                            .onAppear {
                                                logo_path = CreateDB().upload_logo_image(image: image, folder: "logo_images")
                                            }
                                    }
                                    Spacer()
                                }
                                .padding(.top, 5).padding(.bottom, -5).padding(.leading,2.5)
                                .font(Font.custom("Nunito-Bold", size: 18))
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(Color.white)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(Color.black, lineWidth: 1.25)
                                        )
                                        .frame(width: max(0, geometry.size.width - 45), height: 50)
                                    
                                    Button(action: { show_logo_image_picker.toggle() }) {
                                        HStack {
                                            Text("Upload")
                                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.05))
                                        }
                                        .frame(width: max(0, geometry.size.width - 45), height: 50)
                                        .cornerRadius(5)
                                    }
                                }
                                .padding(.leading, 2.5)
                            }
                            
                        HStack {
                            Text("Description").font(Font.custom("Nunito-Bold", size: 18))
                                .padding(.top, 5).padding(.bottom, -5).padding(.leading,2.5)
                            Spacer()
                        }
                        
                        ZStack(alignment: .topLeading) {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.black, lineWidth: 1.25)
                                )
                                .frame(width: max(0, geometry.size.width-45), height: 100)
                            
                            TextEditor(text: $description)
                                .padding([.horizontal, .bottom], 12).padding(.top, 5)
                                .frame(width: max(0, geometry.size.width-45), height: 100)
                                .scrollContentBackground(.hidden)
                                .cornerRadius(5)
                                .font(Font.custom("Nunito-SemiBold", size: 16))
                                .onChange(of: self.description, perform: { value in
                                    withAnimation(.easeOut(duration: 0.2)) {
                                        validateDescriptionCount(value: value)
                                    }
                                    
                                    if value.count > 180 {
                                        self.description = String(value.prefix(180))
                                    }
                                })
                            
                            if description.count == 0 {
                                Text("This is a great franchise")
                                    .foregroundColor(.gray)
                                    .font(Font.custom("Nunito-Medium", size: 16))
                                    .padding([.top, .leading], 15)
                            }
                            
                            if is_description_valid {
                                VStack {
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        
                                        if description.count >= 150 {
                                            Text("\(180 - description.count)")
                                                .foregroundColor(.red)
                                                .font(Font.custom("Nunito-Medium", size: min(geometry.size.width, geometry.size.height) * 0.035))
                                        } else {
                                            Text("\(180 - description.count)")
                                                .foregroundColor(.black)
                                                .font(Font.custom("Nunito-Medium", size: min(geometry.size.width, geometry.size.height) * 0.035))
                                        }
                                    }
                                    .padding(.trailing, 10)
                                }
                                .frame(width: max(0, geometry.size.width-45), height: 130)
                            }
                        }
                        
                        HStack {
                            Text("Total No of Franchises").font(Font.custom("Nunito-Bold", size: 18))
                                .padding(.top, 5).padding(.bottom, -5).padding(.leading,2.5)
                            Spacer()
                        }
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.black, lineWidth: 1.25)
                                )
                                .frame(width: max(0, geometry.size.width - 45), height: 50)
                            
                            TextField("", text: $no_of_franchises, prompt: Text("150").foregroundColor(.gray).font(Font.custom("Nunito-Medium", size: 16))).padding().frame(width: max(0, geometry.size.width-40), height: 50)
                                .foregroundColor(.black)
                                .autocorrectionDisabled(true)
                                .autocapitalization(.none)
                                .font(Font.custom("Nunito-SemiBold", size: 16))
                                .keyboardType(.numberPad)
                        }
                        
                        HStack {
                            Text("Avg Franchise MoM Revenue (£)").font(Font.custom("Nunito-Bold", size: 18))
                                .padding(.top, 10).padding(.bottom, -5).padding(.leading,2.5)
                            Spacer()
                        }
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.black, lineWidth: 1.25)
                                )
                                .frame(width: max(0, geometry.size.width - 45), height: 50)
                            
                            TextField("", text: $mom_revenue, prompt: Text("25000").foregroundColor(.gray).font(Font.custom("Nunito-Medium", size: 16))).padding().frame(width: max(0, geometry.size.width-40), height: 50)
                                .foregroundColor(.black)
                                .autocorrectionDisabled(true)
                                .autocapitalization(.none)
                                .font(Font.custom("Nunito-SemiBold", size: 16))
                                .keyboardType(.numberPad)
                        }
                        
                        HStack {
                            Text("Avg Startup Capital (£)").font(Font.custom("Nunito-Bold", size: 18))
                                .padding(.top, 10).padding(.bottom, -5).padding(.leading,2.5)
                            Spacer()
                        }
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.black, lineWidth: 1.25)
                                )
                                .frame(width: max(0, geometry.size.width - 45), height: 50)
                            
                            TextField("", text: $startup_capital, prompt: Text("15000000").foregroundColor(.gray).font(Font.custom("Nunito-Medium", size: 16))).padding().frame(width: max(0, geometry.size.width-40), height: 50)
                                .foregroundColor(.black)
                                .autocorrectionDisabled(true)
                                .autocapitalization(.none)
                                .font(Font.custom("Nunito-SemiBold", size: 16))
                                .keyboardType(.numberPad)
                        }
                        
                        HStack {
                            Text("Avg Revenue after 18 months (£)").font(Font.custom("Nunito-Bold", size: 18))
                                .padding(.top, 10).padding(.bottom, -5).padding(.leading,2.5)
                            Spacer()
                        }
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.black, lineWidth: 1.25)
                                )
                                .frame(width: max(0, geometry.size.width - 45), height: 50)
                            
                            TextField("", text: $month_rev_18, prompt: Text("450000").foregroundColor(.gray).font(Font.custom("Nunito-Medium", size: 16))).padding().frame(width: max(0, geometry.size.width-40), height: 50)
                                .foregroundColor(.black)
                                .autocorrectionDisabled(true)
                                .autocapitalization(.none)
                                .font(Font.custom("Nunito-SemiBold", size: 16))
                                .keyboardType(.numberPad)
                        }
                        
                        HStack {
                            Text("EBITDA Estimate (%)").font(Font.custom("Nunito-Bold", size: 18))
                                .padding(.top, 10).padding(.bottom, -5).padding(.leading,2.5)
                            Spacer()
                        }
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.black, lineWidth: 1.25)
                                )
                                .frame(width: max(0, geometry.size.width - 45), height: 50)
                            
                            TextField("", text: $ebitda_estimate, prompt: Text("28").foregroundColor(.gray).font(Font.custom("Nunito-Medium", size: 16))).padding().frame(width: max(0, geometry.size.width-40), height: 50)
                                .foregroundColor(.black)
                                .autocorrectionDisabled(true)
                                .autocapitalization(.none)
                                .font(Font.custom("Nunito-SemiBold", size: 16))
                                .keyboardType(.numberPad)
                        }
                        
                        Spacer()
                        
                        // Action to confirm a franchise's creation
                        Button(action: {
                            DispatchQueue.global(qos: .userInteractive).async {
                                self.franchise_data.append(DropdownMenuOption(option: self.name))
                                
                                CreateDB().createFranchise(name: self.name, logo: logo_path, description: self.description, no_of_franchises: self.no_of_franchises, avg_franchise_mom_revenues: self.mom_revenue, avg_startup_capital: self.startup_capital, avg_revenue_18_months: self.month_rev_18, ebitda_estimate: self.ebitda_estimate) { response in
                                    
                                    if response == "Franchise Created" {
                                        franchise_form_shown.toggle()
                                    }
                                }
                            }
                        }) {
                            HStack {
                                Text("Submit")
                                    .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.06))
                            }
                            .frame(width: max(0, geometry.size.width-45), height: 55)
                            .background(Color("Secondary"))
                            .foregroundColor(Color.white)
                            .cornerRadius(5)
                            .padding(.bottom)
                        }
                        .disabled(valid_form_inputs ? false : true)
                        .opacity(valid_form_inputs ? 1 : 0.75)
                    }
                    .foregroundColor(.black)
                }
                .frame(width: max(0, geometry.size.width-40), height: max(0, geometry.size.height))
            }
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .sheet(isPresented: $show_logo_image_picker) {
                ImagePicker(image: $logo_image)
            }
            .padding(.top, 30)
        }
    }
    
    func validateDescriptionCount(value: String) {
        if value.count > 0 {
            is_description_valid = true
        } else {
            is_description_valid = false
        }
    }
}

#Preview {
    AdminFranchiseForm(franchise_form_shown: .constant(true), franchise_data: .constant([]))
}
