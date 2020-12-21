
import UIKit

struct ImageName {
   static let selectAll = "text.badge.plus"
   static let deselectAll = "text.badge.minus"
}

final class ListViewController: UIViewController {
   @IBOutlet weak var tableView: UITableView!
   @IBOutlet weak var progressView: UIProgressView!
   
   var root: ListItem? {
      didSet {
         title = root?.title
         addRightBarButtonItem()
      }
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      // A click on parent item pushes children's view controller onto the navigation stack, once we pop the children's view controller (go back) we need to refresh the parent table view since some of the children might have changed its state
      updateProgress()
      tableView.reloadData()
   }
}

extension ListViewController {
   private func updateProgress() {
      guard let root = root else { fatalError() }
      let doneCount = root.children.filter { $0.state == .done }.count
      progressView.progress = Float(doneCount) / Float(root.children.count)
   }
   
   private func selectAllChildren(of parent: ListItem) {
      for child in parent.children {
         child.state = .done
      }
      updateProgress()
      tableView.reloadData()
   }
   
   private func deselectAllChildren(of parent: ListItem) {
      for child in parent.children {
         child.state = .pending
      }
      updateProgress()
      tableView.reloadData()
   }
   
   @objc private func resetAction(_ sender: UIBarButtonItem) {
      root?.state = .pending
      updateProgress()
      tableView.reloadData()
   }
   
   @objc private func selectAllAction(_ sender: UIBarButtonItem) {
      guard let root = root else { fatalError() }
      selectAllChildren(of: root)
   }
   
   @objc private func deselectAllAction(_ sender: UIBarButtonItem) {
      guard let root = root else { fatalError() }
      deselectAllChildren(of: root)
   }

   private func addRightBarButtonItem() {
      if root?.parent == nil {
         let rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetAction(_:)))
         navigationItem.rightBarButtonItem = rightBarButtonItem
         return
      }
      // Don't allow Select All for roots containing parent children. Select All is allowed only when all children are leafs
      if let children = root?.children {
         let parentCount = children.filter { !$0.isLeaf }.count
         if parentCount > 0 {
            return
         }
      }
      let deselectAll = UIBarButtonItem(image: UIImage(systemName: ImageName.deselectAll), style: .plain, target: self, action: #selector(deselectAllAction(_:)))
      let selectAll = UIBarButtonItem(image: UIImage(systemName: ImageName.selectAll), style: .plain, target: self, action: #selector(selectAllAction(_:)))
      navigationItem.rightBarButtonItems = [selectAll, deselectAll]
   }
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return root?.children.count ?? 0
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      func attributedString(_ string: String, struckthrough: Bool) -> NSAttributedString {
         let attributedString = NSMutableAttributedString(string: string)
         let attributedRange = NSMakeRange(0, attributedString.length)
         if struckthrough {
            //attributedString.addAttribute(.strikethroughStyle, value: 2, range: attributedRange)
            attributedString.addAttribute(.foregroundColor, value: UIColor.lightGray, range: attributedRange)
         }
         return attributedString
      }
      
      func parentCell(item: ListItem) -> ListViewParentCell {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ListViewParentCell.self)", for: indexPath) as? ListViewParentCell else { fatalError() }
         
         //cell.stateImageView.isHidden = true
         cell.stateImageView.image = (item.state == .pending)
            ? UIImage(systemName: "circle")
            : UIImage(systemName: "checkmark.circle")
         cell.titleLabel.attributedText = attributedString(item.title, struckthrough: item.state == .done)
         cell.commentLabel.attributedText = attributedString(item.comment ?? "", struckthrough: item.state == .done)
         let doneCount = item.children.filter { $0.state == .done }.count
         cell.summaryLabel.attributedText = attributedString("\(doneCount)/\(item.children.count)", struckthrough: item.state == .done)
         return cell
      }
      
      func leafCell(item: ListItem) -> ListViewLeafCell {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ListViewLeafCell.self)", for: indexPath) as? ListViewLeafCell else { fatalError() }
         
         cell.stateImageView.isHidden = true
         cell.stateImageView.image = (item.state == .pending)
            ? UIImage(systemName: "circle")
            : UIImage(systemName: "checkmark.circle")
         cell.titleLabel.attributedText = attributedString(item.title, struckthrough: item.state == .done)
         cell.commentLabel.attributedText = attributedString(item.comment ?? "", struckthrough: item.state == .done)
         cell.summaryLabel.attributedText = attributedString(item.summary ?? "", struckthrough: item.state == .done)
         return cell
      }
      
      guard let item = root?.children[indexPath.row] else { fatalError() }
      return item.isLeaf
         ? leafCell(item: item)
         : parentCell(item: item)
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      guard let item = root?.children[indexPath.row] else { fatalError() }
      if item.isLeaf {
         item.toggleState()
         updateProgress()
         tableView.reloadRows(at: [indexPath], with: .automatic)
      } else {
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         guard let nextViewController = storyboard.instantiateViewController(withIdentifier: "\(ListViewController.self)") as? ListViewController else { fatalError() }
         
         nextViewController.root = item
         navigationController?.pushViewController(nextViewController, animated: true)
      }
   }
   
   func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
      guard let item = root?.children[indexPath.row] else { fatalError() }
      let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: { () -> UIViewController? in
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         guard let viewController = storyboard.instantiateViewController(withIdentifier: "\(ListViewController.self)") as? ListViewController else { fatalError() }
         viewController.root = item
         return viewController
      }) { _ -> UIMenu? in
         let selectAll = UIAction(title: "Select All", image: UIImage(systemName: ImageName.selectAll)) { [weak self] _ in
            self?.selectAllChildren(of: item)
         }
         let delectAll = UIAction(title: "Deselect All", image: UIImage(systemName: ImageName.deselectAll)) { [weak self] _ in
            self?.deselectAllChildren(of: item)
         }
         return UIMenu(title: "", children: [selectAll, delectAll])
      }
      return configuration
   }
   
   func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
      animator.addCompletion { [weak self] in
         if let viewController = animator.previewViewController {
            //self?.show(viewController, sender: self)
            self?.navigationController?.pushViewController(viewController, animated: true)
         }
      }
   }
}
