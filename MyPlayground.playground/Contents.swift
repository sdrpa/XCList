import Cocoa

func clearFromFirstColumnToEOL(_ string: String) -> String {
   let lines = string
      .components(separatedBy: .newlines)
      .map { line -> String in
         if !line.contains(":") { return line + "\n" }
         guard let index = line.firstIndex(of: ":") else { fatalError() }
         let substring = line[string.startIndex..<index]
         return String(substring) + "\n"
      }
   return lines.joined()
}

func appendPrefixAndSuffixToEachLine(_ string: String) -> String {
   let lines = string.components(separatedBy: .newlines).map { "L(\"" + $0 + "\"),\n" }
   return lines.dropLast().joined()
}

let string =
"""
sw_item:Doors|OPEN
sw_item:ADIRS(x3) Selectors|OFF:(ckpt/oh/irs1/anim:0)&&(ckpt/oh/irs2/anim:0)&&(ckpt/oh/irs3/anim:0)
sw_item:All Exterior Lights|OFF
sw_item:Apu Bleed|OFF:AirbusFBW/APUBleedSwitch:0
sw_item:Apu Master|OFF:sim/cockpit/engine/APU_switch:0
sw_item:Emergency Lights|OFF:ckpt/oh/emerExitLight/anim:1
sw_item:NoSmoking sign|OFF:ckpt/oh/nosmoking/anim:0
sw_item:Battery 1|OFF:sim/cockpit2/electrical/battery_on[0]:0
sw_item:Battery 2|OFF:sim/cockpit2/electrical/battery_on[1]:0
"""

let stage0 = string.replacingOccurrences(of: "sw_item:", with: "")
let stage1 = stage0.replacingOccurrences(of: "|", with: "\", \"")
let stage2 = clearFromFirstColumnToEOL(stage1)
let stage3 = appendPrefixAndSuffixToEachLine(stage2)
print(stage3)
