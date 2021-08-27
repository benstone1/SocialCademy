//
//  CommentRow.swift
//  CommentRow
//
//  Created by John Royal on 8/21/21.
//

import SwiftUI

struct CommentRow: View {
    let comment: Comment
    let deleteAction: DeleteAction?
    
    typealias DeleteAction = () async throws -> Void
    
    @StateObject private var deleteTask = DeleteTaskViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            metadata
            content
        }
        .padding(5)
        .swipeActions {
            if let deleteAction = deleteAction {
                deleteButton(with: deleteAction)
            }
        }
        .alert("Are you sure you want to delete this comment?", isPresented: $deleteTask.isPending, presenting: deleteTask.confirmAction) {
            Button("Delete", role: .destructive, action: $0)
        }
        .alert("Cannot Delete Comment", isPresented: $deleteTask.isError, presenting: deleteTask.error) { error in
            Text(error.localizedDescription)
        }
    }
    
    private var metadata: some View {
        HStack(alignment: .top) {
            Text(comment.author.name)
                .font(.subheadline)
                .fontWeight(.semibold)
            Spacer()
            Text(comment.displayTimestamp)
                .foregroundColor(.gray)
                .font(.caption)
        }
    }
    
    private var content: some View {
        Text(comment.content)
            .font(.headline)
            .fontWeight(.regular)
    }
    
    private func deleteButton(with deleteAction: @escaping DeleteAction) -> some View {
        Button(role: .destructive) {
            deleteTask.request(with: deleteAction)
        } label: {
            Label("Delete", systemImage: "trash")
                .labelStyle(IconOnlyLabelStyle())
        }
    }
}

private extension Comment {
    var displayTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }
}

struct CommentRow_Previews: PreviewProvider {
    static var previews: some View {
        CommentRow(comment: .preview, deleteAction: {})
    }
}