// AIRBUS A319 ToLiss Normal procedures checklist (Pedro Bach)

import Foundation

fileprivate func L(_ title: String, _ summary: String? = nil, comment: String? = nil, children: [ListItem] = []) -> ListItem {
   ListItem(title, summary, comment: comment, children: children)
}

struct Test {
   static var root: ListItem {
      return L("Test", children: [
         L("COCKPIT PREPARATION 3 (FMGS)", children: [
            L("MCDU Brightness", "ADJUST"),
            L("INIT B Page", children: [
               L("ZFW/ZFWCG", "INSERT"),
            ]),
         ]),
         L("ENGINE START", children: [
            L("Ignition Selector", "START")
         ])
      ])
   }
}
