//
//  ExpandingDatePicker.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 2/28/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import SwiftUI

/**
Description:
Type: SwiftUI View Class
Functionality: Creates an expanding date picker class that switches between a compact form for displaying currently selected date, and an expanding form that allows a user to change the selected date with a date picker
*/
struct ExpandingDatePicker: View {
    
    // State switch that controls whether the view is in expanded form
    @State var expanded = false
    
    // Reference to parent's date variable
    @Binding var date: Date
    
    // Date Formatter
    var formatter: DateFormatter
    {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
    
    // SwiftUI view constructor
    var body: some View {
        
        VStack
        {
            Button(action: {self.expanded.toggle()})
            {
                HStack
                {
                    if (expanded)
                    {
                        Image(systemName: "arrowtriangle.up.circle.fill")
                            .padding(.leading)
                        Text(formatter.string(from: date))
                            .foregroundColor(.secondary)
                    }
                    else
                    {
                        Image(systemName: "arrowtriangle.down.circle.fill")
                        .padding(.leading)
                        Text(formatter.string(from: date))
                            .foregroundColor(.primary)
                    }
                    
                    
                    Spacer()
                }
            }
            if (expanded)
            {
                DatePicker("", selection: $date, displayedComponents: .hourAndMinute)
                .labelsHidden()
                .frame(width: 250, height: 120)
                .padding(20)
            }
        }
        .padding(10)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        
    }
}

struct ExpandingDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        ExpandingDatePicker(date: .constant(Date()))
    }
}
