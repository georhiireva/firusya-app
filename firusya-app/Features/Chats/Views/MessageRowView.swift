//
//  MessageRowView.swift
//  firusia
//
//  Created by Рева Георгий Александрович on 16.03.2026.
//
import SwiftUI

struct MessageRowView: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.direction == MessageDirection.incoming.rawValue {
                bubble
                Spacer(minLength: 48)
            } else {
                Spacer(minLength: 48)
                bubble
            }
            
        }.border(.red)
        .overlay(alignment: .bottomTrailing) {
            Text(message.createdAt, style: .time)
                .font(.caption)
                .padding(.bottom, 2)
                .padding(.trailing, 10)
                .foregroundColor(.secondary)

        }
    }
    
    private var bubble: some View {
        VStack(alignment: .trailing, spacing: 4) {
            Text(message.text)
                .font(.body)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.leading)
                .border(.yellow)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(message.text)
                .font(.body)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.leading)
                .border(.yellow)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .frame(maxWidth: 280, alignment: .leading)
        .background(bubbleBackground)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .border(.blue, width: 2.0)
    }
    
    private var bubbleBackground: some View {
        Group {
            if message.direction == MessageDirection.incoming.rawValue {
                Color.gray.opacity(0.22)
            } else {
                Color.green.opacity(0.22)
            }
        }
    }
}

#Preview {
    let message = Message(
        chatId: "String",
        senderPeerId: "String",
        recipientPeerId: "String",
        text: "String",
        direction: .outgoing,
        deliveryState: .read
        
    )
    MessageRowView(message: message)
}
