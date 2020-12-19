
import Foundation

enum ListItemState {
   case pending, done
}

class ListItem {
   let title: String
   var children: [ListItem]
   
   weak var parent: ListItem?
   
   let comment: String?
   let summary: String?
   
   private var _state: ListItemState = .pending
   var state: ListItemState {
      set {
         _state = newValue
      }
      get {
         return isLeaf
            ? _state
            : children.allSatisfy { $0.state == .done } ? .done : .pending
      }
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

extension ListItem {
   var isLeaf: Bool {
      children.count == 0
   }
   
   func toggleState() {
      state = (state == .pending) ? .done : .pending
   }
   
   func addChild(_ node: ListItem) {
      self.children.append(node)
      node.parent = self
   }
}
