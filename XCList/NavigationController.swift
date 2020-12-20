
import UIKit

class NavigationController: UINavigationController {
   private static var fileURL: URL {
      return documentsDirectory().appendingPathComponent("root")
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      guard let listViewController = children.first as? ListViewController else { fatalError() }
      if let saved = restore() {
         listViewController.root = saved
         // Encoding the weak parent property causes a crash, so here we set parent relationship recursively after restoration
         func updateChildren(item: ListItem) {
            for child in item.children {
               child.parent = item
               updateChildren(item: child)
            }
         }
         updateChildren(item: saved)
      } else {
         listViewController.root = A319.root
      }
      
      //listViewController.root = A319.root
      //listViewController.root = Test.root
   }
}

extension NavigationController {
   private static func documentsDirectory() -> URL {
      let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
      let documentsDirectory = paths[0]
      return documentsDirectory
   }
   
   func save() {
      guard let listViewController = topViewController as? ListViewController,
            let item = listViewController.root else {
         return
      }
      func topParent(item: ListItem) -> ListItem {
         return item.parent == nil
            ? item
            : topParent(item: item.parent!)
      }
      let root = topParent(item: item)
      do {
         let encoder = JSONEncoder()
         let data = try encoder.encode(root)
         try data.write(to: Self.fileURL)
      } catch let e {
         let alertController = UIAlertController(title: "Error", message: e.localizedDescription, preferredStyle: .alert)
         let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
         alertController.addAction(defaultAction)
         present(alertController, animated: true, completion: nil)
      }
   }
   
   private func restore() -> ListItem? {
      do {
         let data = try Data(contentsOf: Self.fileURL)
         let decoder = JSONDecoder()
         let root = try decoder.decode(ListItem.self, from: data)
         return root
      } catch {
         return nil
      }
   }
}
