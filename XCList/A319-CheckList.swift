// AIRBUS A319 ToLiss Normal procedures checklist (Pedro Bach)

import Foundation

fileprivate func L(_ title: String, _ summary: String? = nil, comment: String? = nil, children: [ListItem] = []) -> ListItem {
   ListItem(title, summary, comment: comment, children: children)
}

struct A319 {
   static var root: ListItem {
      return L("A319", children: [
         L("COCKPIT PREPARATION 1", children: [
            L("Parking Brake", "SET"),
            L("Engine Master 1", "OFF"),
            L("Engine Master 2", "OFF"),
            L("Ignition Selector", "NORMAL"),
            L("Landing Gear", "DOWN"),
            L("External Power", "CONNECT"),
            L("Battery 1", "ON"),
            L("Battery 2", "ON"),
            L("Doome", "BRT"),
            L("External Power", "ON"),
            L("Flaps", "UP"),
            L("Ground Spoilers", "RETRACTED"),
            L("Probe Window Heat", "AUTO"),
            L("Cross Bleed", "AUTO"),
            L("ANN LT", "TEST"),
            L("ADIRS Data Selector", "STS"),
            L("ADIRS System Selector", "1"),
            L("ADIRS1 Selector", "NAV", comment: "Wait for BAT Light OFF"),
            L("ADIRS3 Selector", "NAV", comment: "Wait for BAT Light OFF"),
            L("ADIRS2 Selector", "NAV", comment: "Wait for BAT Light OFF"),
         ]),
         L("COCKPIT PREPARATION 2", children: [
            L("Strobe Lights", "AUTO"),
            L("Nav & Logo Lights", "1"),
            L("All Other External Lights", "OFF"),
            L("Seatbelts sign", "ON"),
            L("No Smoking sign", "ON"),
            L("Emergency Lights", "ARM"),
            L("Landing Elevation", "AUTO"),
            L("PackFlow", "AS REQUIRED"),
            L("Fuel Pumps(x6)", "ON"),
            L("Apu Fire Button", "GUARD DOWN"),
            L("Apu Fire Test", "TEST"),
            L("Eng1 Fire Button", "ARM GUARD"),
            L("Eng2 Fire Button", "ARM GUARD"),
            L("Eng1 Fire Test", "TEST"),
            L("Eng2 Fire Test", "TEST"),
            L("Radio Panels(x3)", "ON"),
            L("PFD & ND Brightness", "ADJUST"),
            L("EWD & SD Brightness", "ADJUST"),
         ]),
         L("COCKPIT PREPARATION 3 (FMGS)", children: [
            L("MCDU Brightness", "ADJUST"),
            L("MCDU Aircraft Status Page", children: [
               L("Engine Type and Aircraft Type", "CHECK"),
               L("Database Validity", "CHECK")
            ]),
            L("MCDU INIT Page", children: [
               L("DEP/DEST Airport", "ENTER"),
               L("Alternate Airport", "ENTER"),
               L("Flight Number", "ENTER"),
               L("Cost Index", "ENTER"),
               L("Cruise FL", "ENTER"),
               L("Current position coordinates", "CHECK/MODIFY"),
               L("ALIGN IRS", "PRESS")
            ]),
            L("F-PLN A Page", children: [
               L("Departure Route", "SELECT/INSERT"),
               L("Airways & Route Points", "ENTER"),
               L("Arrival Destination Airport", "SELECT/INSERT"),
               L("Route Discontinuities", "CLEAR"),
               L("Alternate Flight Plan", "ENTER"),
               L("Climb Speed", "CHECK"),
               L("Descend Speed", "CHECK"),
               L("Climb & Cruise Wind", "ENTER"),
               L("Flight Plan on ND", "CHECK")
            ]),
            L("INIT B Page", children: [
               L("ZFW/ZFWCG", "INSERT"),
               L("Block Fuel", "INSERT")
            ]),
            L("PERF Page", children: [
               L("Take-off Speeds", "SET"),
               L("Flex Temperature", "INSERT"),
               L("Flap Position & THS", "INSERT")
            ]),
         ]),
         L("COCKPIT PREPARATION 4", children: [
            L("Radio Freq", "SET"),
            L("ATC Clearance", "OBTAIN"),
            L("Altimeters", "SET"),
            L("FlightControlUnit", "SET"),
            L("Flight Directors", "ON"),
            L("LS", "OFF"),
            L("Navigation Mode", "SET"),
            L("Clock", "CHECK"),
            L("ATC/TCAS Mode", "AUTO"),
            L("ATC/TCAS ALT RPTRG", "ON"),
            L("ATC/TCAS SYS", "1"),
            L("A/SKID & NW STRG Switch", "ON"),
            L("Apu Master", "ON"),
            L("Apu Start", "ON"),
            L("Apu Bleed", "ON"),
            L("Exterior Power", "OFF"),
            L("GPU Truck", "DISCONNECT")
         ]),
         L("PUSHBACK", children: [
            L("Doors", "CLOSED"),
            L("Beacon Light", "ON"),
            L("Tow Truck", "CALL"),
            L("A/SKID & NW STRG Switch", "OFF"),
            L("Parking Brake", "RELEASE"),
            L("A/SKID & NW STRG Switch", "ON"),
            L("Tow Truck", "DISMISS"),
            L("Parking Brake", "ON")
         ]),
         L("ENGINE START", children: [
            L("Ignition Selector", "START"),
            L("Engine 2 Master", "ON"),
            L("Engine 1 Master", "ON")
         ]),
         L("AFTER ENGINE START", children: [
            L("Ignition Selector", "NORMAL"),
            L("Apu Bleed", "OFF"),
            L("Ground Spoilers", "ARM"),
            L("Flaps", "TAKE OFF"),
            L("Rudder Trim", "ZERO"),
            L("Pitch Trim", "T/OFF"),
            L("Apu Master", "OFF")
         ]),
         L("TAXI", children: [
            L("Nose Light", "TAXI"),
            L("Parking Brake", "REL"),
            L("ELAPSED TIME Counter", "START"),
            L("Brakes", "CHECK"),
            L("Flight Controls", "CHECK"),
            L("FMA modes", "NAV & CLB ARMED"),
            L("PFD & ND", "NO RED FLAGS"),
            L("Terrain on ND", "AS REQUIRED"),
            L("Autobrake", "MAX"),
            L("Cabin Reay", "CHECK"),
            L("TO ConfigSwitch", "PRESS"),
            L("Anti-Ice", "AS REQUIRED")
         ]),
         L("BEFORE TAKE OFF", children: [
            L("Brake Temperature", "CHECK"),
            L("Clearance", "OBTAIN"),
            L("Engine Mode Selector", "AS REQUIRED", comment: "Set to position START/IGN, if the runway has standing water or heavy rain expected"),
            L("Aircon Packs", "AS REQUIRED", comment: "Switching off Packs is only required on short runways with Full power take-offs (NO Flex)"),
            L("Weather Radar", "ON"),
            L("Rwy Turn Off Lights", "ON"),
            L("Landing Lights", "ON"),
            L("Nose Light", "TAKE OFF")
         ]),
         L("LINED UP", children: [
            L("ATC TCAS", "ON"),
            L("Chrono", "START")
         ]),
         L("TAKE OFF", children: [
            L("Brakes", "RELEASE"),
            L("Thrust Levers", "FLEX")
         ]),
         L("AFTER TAKE OFF", children: [
            L("Positive Climb", "GEAR UP"),
            L("Ground Spoilers", "DISARM"),
            L("Autopilot AP1", "ON"),
            L("Nose Light", "OFF"),
            L("Rwy Turn Off Lights", "OFF"),
            L("Thrust Levers", "CLB"),
            L("Flaps", "UP"),
            L("Engine Mode Selector", "AS REQUIRED")
         ]),
         L("CLIMB", children: [
            L("Anti-Ice", "AS REQUIRED"),
            L("Altimeter QNH", "SET", comment: "Passing 10 thousand Feet"),
            L("Landing Lights", "OFF"),
            L("Nose Light", "OFF"),
            L("Terrain on ND", "OFF")
         ]),
         L("CRUISE", children: [
            L("Seatbelts Sign", "OFF"),
            L("Cabin Temperature", "CHECK")
         ]),
         L("BEFORE DESCENT", children: [
            L("Landing Elevation", "AUTO"),
            L("FMGS ARRIVAL PAGE", "CHECK"),
            L("FMGS APPROACH PHASE", "SET"),
            L("FMGS DESCENT WIND", "ENTER"),
            L("GPWS switch", "AS REQUIRED", comment: "If landing is expected with flaps 3, set the switch to ON"),
            L("Autobrake", "SET"),
            L("Anti Ice", "AS REQUIRED")
         ]),
         L("DESCENT", children: [
            L("FCU Altitude", "SET"),
            L("DES mode", "ENGAGE"),
            L("Terrain on ND", "AS REQUIRED", comment: "Transition Level"),
            L("Altimeters QNH", "SET", comment: "Passing 10 thousand Feet"),
            L("Landing Lights", "ON"),
            L("Pass Signs", "ON"),
            L("ND OPTION", "CSTR"),
            L("LS Buttons (x3)", "ON")
         ]),
         L("APPROACH", children: [
            L("FMGS APPROACH PHASE", "ACTIVATE"),
            L("AUTOPILOT2", "ON", comment: "ILS ESTABLISHED")
         ]),
         L("LANDING", children: [
            L("At 2000ft AGL", "FLAPS 2"),
            L("Landing Gear", "DOWN"),
            L("Ground Spoilers", "ARM"),
            L("Autobrake", "SET"),
            L("ECAM WHEEL PAGE", "ALL GREEN"),
            L("Flaps", "FULL"),
            L("ATHR mode", "SPEED"),
            L("Nose Light", "TAKE OFF"),
            L("Rwy Turn Off Lights", "ON"),
            L("Cabin Ready", "CHECK")
         ]),
         L("AFTER LANDING", children: [
            L("Autopilot", "OFF"),
            L("Landing Lights", "OFF"),
            L("Nose Light", "TAXI"),
            L("Ground Spoilers", "RETRACT"),
            L("Engine Mode Selector", "NORMAL"),
            L("Flaps", "RETRACT"),
            L("Apu Master", "ON"),
            L("Apu Start", "ON"),
            L("Weather Radar", "OFF"),
            L("Terrain on ND", "OFF"),
            L("Brake Temperature", "CHECK"),
            L("Chrono", "STOP")
         ]),
         L("PARKING", children: [
            L("Parking Brake", "ON"),
            L("Anti Ice", "OFF"),
            L("Apu Bleed", "ON"),
            L("Eng1 Master", "OFF"),
            L("Eng2 Master", "OFF"),
            L("Nose Light", "OFF"),
            L("Rwy Turn Off Lights", "OFF"),
            L("Seatbelts sign", "OFF"),
            L("Fuel Pumps(x6)", "OFF"),
            L("ELAPSED TIME Counter", "STOP"),
            L("ATC TCAS", "STANDBY")
         ]),
         L("SECURING AIRCRAFT", children: [
            L("Doors", "OPEN"),
            L("ADIRS(x3) Selectors", "OFF"),
            L("All Exterior Lights", "OFF"),
            L("Apu Bleed", "OFF"),
            L("Apu Master", "OFF"),
            L("Emergency Lights", "OFF"),
            L("NoSmoking Sign", "OFF"),
            L("Battery 1", "OFF"),
            L("Battery 2", "OFF")
         ])
      ])
   }
}
