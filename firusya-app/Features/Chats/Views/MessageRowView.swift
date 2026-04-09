import SwiftUI

struct MessageRowView: View {
    let message: Message

    private var isIncoming: Bool {
        message.direction == .incoming
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            if isIncoming {
                bubble
                Spacer(minLength: 56)
            } else {
                Spacer(minLength: 56)
                bubble
            }
        }
    }

    private var bubble: some View {
        HStack(alignment: .bottom, spacing: 8) {
            Text(message.text)
                .font(.system(size: 17))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)

            Text(message.createdAt, style: .time)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.secondary)
                .padding(.bottom, 1)

            if !isIncoming {
                Image(systemName: message.deliveryState == .read ? "checkmark.circle.fill" : "checkmark")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(message.deliveryState == .read ? Color.blue : Color.secondary)
                    .padding(.bottom, 1)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(isIncoming ? Color.white : Color(red: 0.86, green: 0.97, blue: 0.77))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: .black.opacity(0.07), radius: 1.5, x: 0, y: 1)
        .frame(maxWidth: 300, alignment: .trailing)
    }
}

#Preview {
    VStack(spacing: 12) {
        MessageRowView(
            message: Message(
                chat: Chat(contact: Contact(id: UUID(uuidString: "10000000-0000-0000-0000-000000000001")!, displayName: "Alex", subtitle: nil)),
                text: "Привет! Это входящее сообщение в стиле Telegram.",
                direction: .incoming,
                deliveryState: .delivered
            )
        )

        MessageRowView(
            message: Message(
                chat: Chat(contact: Contact(id: UUID(uuidString: "10000000-0000-0000-0000-000000000002")!, displayName: "Alex", subtitle: nil)),
                text: "Да, выглядит очень похоже. Отлично!",
                direction: .outgoing,
                deliveryState: .read
            )
        )
    }
    .padding()
    .background(Color(red: 0.84, green: 0.94, blue: 1.0))
}
