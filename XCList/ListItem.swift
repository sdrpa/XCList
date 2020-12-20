// https://github.com/raywenderlich/swift-algorithm-club/tree/master/Tree
import Foundation

enum ListItemState: UInt, Codable {
   case pending, done
}

class ListItem: Codable {
   let title: String
   var children: [ListItem]
   
   weak var parent: ListItem?
   
   let comment: String?
   let summary: String?
   
   private var _state: ListItemState = .pending
   var state: ListItemState {
      set {
         _state = newValue
         for child in children {
            child.state = newValue
         }
      }
      get {
         return isLeaf
            ? _state
            : children.allSatisfy { $0.state == .done } ? .done : .pending
      }
   }
   
   private enum CodingKeys: String, CodingKey {
      case title, summary, comment, children, _state
   }
   
   init(_ title: String, _ summary: String? = nil, comment: String? = nil, children: [ListItem] = []) {
      self.title = title
      self.summary = summary
      self.comment = comment
      self.children = children
      
      for child in children {
         child.parent = self
      }
   }
}

extension ListItem: CustomDebugStringConvertible {
   var debugDescription: String {
      "\(title):\(state)"
   }
}

extension ListItem {
   var isLeaf: Bool {
      children.count == 0
   }
   
   func toggleState() {
      state = (state == .pending) ? .done : .pending
   }
}
