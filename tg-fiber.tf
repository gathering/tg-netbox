locals {
  device_types = [
    { name = "fiberpatch 2 * 6 par", manufacturer = "Generic", part_number = "", u_height = 1, is_full_depth = false, slug = "fiberpatch-2-6-par" },
    { name = "fiberpatch 24 par", manufacturer = "Generic", part_number = "", u_height = 1, is_full_depth = false, slug = "fiberpatch-24-par" },
    { name = "fiberpatch 6 par", manufacturer = "Generic", part_number = "", u_height = 1, is_full_depth = false, slug = "fiberpatch-6-par" }
  ]
  devices = [
    { name = "log-patch", status = "active", site = "Vikingskipet", location = "log", role = "Patch Panel", manufacturer = "Generic", device_type = "fiberpatch-2-6-par" },
    { name = "noc-to-north-patch", status = "active", site = "Vikingskipet", location = "noc", role = "Patch Panel", manufacturer = "Generic", device_type = "fiberpatch-6-par" },
    { name = "noc-to-roof-patch", status = "active", site = "Vikingskipet", location = "noc", role = "Patch Panel", manufacturer = "Generic", device_type = "fiberpatch-24-par" },
    { name = "noc-to-tele-patch", status = "active", site = "Vikingskipet", location = "noc", role = "Patch Panel", manufacturer = "Generic", device_type = "fiberpatch-24-par" },
    { name = "north-patch", status = "active", site = "Vikingskipet", location = "north", role = "Patch Panel", manufacturer = "Generic", device_type = "fiberpatch-2-6-par" },
    { name = "reception-to-tele-patch", status = "active", site = "Vikingskipet", location = "reception", role = "Patch Panel", manufacturer = "Generic", device_type = "fiberpatch-6-par" },
    { name = "roof-north-to-roof-south-patch", status = "active", site = "Vikingskipet", location = "roof-north", role = "Patch Panel", manufacturer = "Generic", device_type = "fiberpatch-24-par" },
    { name = "roof-south-to-roof-north-patch", status = "active", site = "Vikingskipet", location = "roof-south", role = "Patch Panel", manufacturer = "Generic", device_type = "fiberpatch-24-par" },
    { name = "roof-to-noc-patch", status = "active", site = "Vikingskipet", location = "roof-south", role = "Patch Panel", manufacturer = "Generic", device_type = "fiberpatch-24-par" },
    { name = "south-patch", status = "active", site = "Vikingskipet", location = "south", role = "Patch Panel", manufacturer = "Generic", device_type = "fiberpatch-2-6-par" },
    { name = "stand-to-tele-patch", status = "active", site = "Vikingskipet", location = "stand-altibox", role = "Patch Panel", manufacturer = "Generic", device_type = "fiberpatch-6-par" },
    { name = "swing-patch", status = "active", site = "Vikingskipet", location = "swing", role = "Patch Panel", manufacturer = "Generic", device_type = "fiberpatch-2-6-par" },
    { name = "tele-patch", status = "active", site = "Vikingskipet", location = "tele", role = "Patch Panel", manufacturer = "Generic", device_type = "fiberpatch-6-par" },
    { name = "tele-to-noc-patch", status = "active", site = "Vikingskipet", location = "tele", role = "Patch Panel", manufacturer = "Generic", device_type = "fiberpatch-24-par" },
    { name = "vrimle-patch", status = "active", site = "Vikingskipet", location = "vrimle", role = "Patch Panel", manufacturer = "Generic", device_type = "fiberpatch-6-par" }
  ]
  rear_ports = [
    { name = "G12-1", device = "log-patch", type = "splice", description = "to swing", positions = 6 },
    { name = "G12-2", device = "log-patch", type = "splice", description = "to south", positions = 6 },
    { name = "G12-3", device = "log-patch", type = "splice", description = "", positions = 6 },
    { name = "G12", device = "noc-to-north-patch", type = "splice", description = "", positions = 6 },
    { name = "G48", device = "noc-to-roof-patch", type = "splice", description = "", positions = 24 },
    { name = "G48", device = "noc-to-tele-patch", type = "splice", description = "", positions = 24 },
    { name = "G12-1", device = "north-patch", type = "splice", description = "to noc", positions = 6 },
    { name = "G12-2", device = "north-patch", type = "splice", description = "to swing", positions = 6 },
    { name = "G12", device = "reception-to-tele-patch", type = "splice", description = "", positions = 6 },
    { name = "G48", device = "roof-north-to-roof-south-patch", type = "splice", description = "", positions = 24 },
    { name = "G48", device = "roof-south-to-roof-north-patch", type = "splice", description = "", positions = 24 },
    { name = "G48", device = "roof-to-noc-patch", type = "splice", description = "", positions = 24 },
    { name = "G12-1", device = "south-patch", type = "splice", description = "to tele", positions = 6 },
    { name = "G12-2", device = "south-patch", type = "splice", description = "to log", positions = 6 },
    { name = "G12", device = "stand-to-tele-patch", type = "splice", description = "", positions = 6 },
    { name = "G12-1", device = "swing-patch", type = "splice", description = "to north", positions = 6 },
    { name = "G12-2", device = "swing-patch", type = "splice", description = "to log", positions = 6 },
    { name = "G12", device = "tele-patch", type = "splice", description = "to south", positions = 6 },
    { name = "G24-1", device = "tele-patch", type = "splice", description = "to reception", positions = 6 },
    { name = "G24-2", device = "tele-patch", type = "splice", description = "to stand", positions = 6 },
    { name = "telenor", device = "tele-patch", type = "splice", description = "Telenor", positions = 5 },
    { name = "G48", device = "tele-to-noc-patch", type = "splice", description = "", positions = 24 },
    { name = "G12", device = "vrimle-patch", type = "splice", description = "", positions = 6 }
  ]
  front_ports = [
    { name = "port1", device = "log-patch", type = "sc-upc", rear_port = "G12-1", rear_port_position = 1, description = "to swing" },
    { name = "port2", device = "log-patch", type = "sc-upc", rear_port = "G12-1", rear_port_position = 2, description = "to swing" },
    { name = "port3", device = "log-patch", type = "sc-upc", rear_port = "G12-1", rear_port_position = 3, description = "to swing" },
    { name = "port4", device = "log-patch", type = "sc-upc", rear_port = "G12-1", rear_port_position = 4, description = "to swing" },
    { name = "port5", device = "log-patch", type = "sc-upc", rear_port = "G12-1", rear_port_position = 5, description = "to swing" },
    { name = "port6", device = "log-patch", type = "sc-upc", rear_port = "G12-1", rear_port_position = 6, description = "to swing" },
    { name = "port10", device = "log-patch", type = "sc-upc", rear_port = "G12-3", rear_port_position = 1, description = "to vrimle" },
    { name = "port11", device = "log-patch", type = "sc-upc", rear_port = "G12-3", rear_port_position = 2, description = "to vrimle" },
    { name = "port12", device = "log-patch", type = "sc-upc", rear_port = "G12-3", rear_port_position = 3, description = "to vrimle" },
    { name = "port13", device = "log-patch", type = "sc-upc", rear_port = "G12-3", rear_port_position = 4, description = "to vrimle" },
    { name = "port14", device = "log-patch", type = "sc-upc", rear_port = "G12-3", rear_port_position = 5, description = "to vrimle" },
    { name = "port15", device = "log-patch", type = "sc-upc", rear_port = "G12-3", rear_port_position = 6, description = "to vrimle" },
    { name = "port19", device = "log-patch", type = "sc-upc", rear_port = "G12-2", rear_port_position = 1, description = "to south" },
    { name = "port20", device = "log-patch", type = "sc-upc", rear_port = "G12-2", rear_port_position = 2, description = "to south" },
    { name = "port21", device = "log-patch", type = "sc-upc", rear_port = "G12-2", rear_port_position = 3, description = "to south" },
    { name = "port22", device = "log-patch", type = "sc-upc", rear_port = "G12-2", rear_port_position = 4, description = "to south" },
    { name = "port23", device = "log-patch", type = "sc-upc", rear_port = "G12-2", rear_port_position = 5, description = "to south" },
    { name = "port24", device = "log-patch", type = "sc-upc", rear_port = "G12-2", rear_port_position = 6, description = "to south" },
    { name = "port1", device = "noc-to-north-patch", type = "sc-upc", rear_port = "G12", rear_port_position = 1, description = "" },
    { name = "port2", device = "noc-to-north-patch", type = "sc-upc", rear_port = "G12", rear_port_position = 2, description = "" },
    { name = "port3", device = "noc-to-north-patch", type = "sc-upc", rear_port = "G12", rear_port_position = 3, description = "" },
    { name = "port4", device = "noc-to-north-patch", type = "sc-upc", rear_port = "G12", rear_port_position = 4, description = "" },
    { name = "port5", device = "noc-to-north-patch", type = "sc-upc", rear_port = "G12", rear_port_position = 5, description = "" },
    { name = "port6", device = "noc-to-north-patch", type = "sc-upc", rear_port = "G12", rear_port_position = 6, description = "" },
    { name = "port1", device = "noc-to-roof-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 1, description = "" },
    { name = "port2", device = "noc-to-roof-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 2, description = "" },
    { name = "port3", device = "noc-to-roof-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 3, description = "" },
    { name = "port4", device = "noc-to-roof-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 4, description = "" },
    { name = "port5", device = "noc-to-roof-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 5, description = "" },
    { name = "port6", device = "noc-to-roof-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 6, description = "" },
    { name = "port7", device = "noc-to-roof-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 7, description = "" },
    { name = "port8", device = "noc-to-roof-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 8, description = "" },
    { name = "port9", device = "noc-to-roof-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 9, description = "" },
    { name = "port10", device = "noc-to-roof-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 10, description = "" },
    { name = "port11", device = "noc-to-roof-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 11, description = "" },
    { name = "port12", device = "noc-to-roof-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 12, description = "" },
    { name = "port13", device = "noc-to-roof-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 13, description = "" },
    { name = "port14", device = "noc-to-roof-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 14, description = "" },
    { name = "port15", device = "noc-to-roof-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 15, description = "" },
    { name = "port16", device = "noc-to-roof-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 16, description = "" },
    { name = "port17", device = "noc-to-roof-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 17, description = "" },
    { name = "port18", device = "noc-to-roof-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 18, description = "" },
    { name = "port19", device = "noc-to-roof-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 19, description = "" },
    { name = "port20", device = "noc-to-roof-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 20, description = "" },
    { name = "port21", device = "noc-to-roof-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 21, description = "" },
    { name = "port22", device = "noc-to-roof-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 22, description = "" },
    { name = "port23", device = "noc-to-roof-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 23, description = "" },
    { name = "port24", device = "noc-to-roof-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 24, description = "" },
    { name = "port1", device = "noc-to-tele-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 1, description = "" },
    { name = "port2", device = "noc-to-tele-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 2, description = "" },
    { name = "port3", device = "noc-to-tele-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 3, description = "" },
    { name = "port4", device = "noc-to-tele-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 4, description = "" },
    { name = "port5", device = "noc-to-tele-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 5, description = "" },
    { name = "port6", device = "noc-to-tele-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 6, description = "" },
    { name = "port7", device = "noc-to-tele-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 7, description = "" },
    { name = "port8", device = "noc-to-tele-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 8, description = "" },
    { name = "port9", device = "noc-to-tele-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 9, description = "" },
    { name = "port10", device = "noc-to-tele-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 10, description = "" },
    { name = "port11", device = "noc-to-tele-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 11, description = "" },
    { name = "port12", device = "noc-to-tele-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 12, description = "" },
    { name = "port13", device = "noc-to-tele-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 13, description = "" },
    { name = "port14", device = "noc-to-tele-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 14, description = "" },
    { name = "port15", device = "noc-to-tele-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 15, description = "" },
    { name = "port16", device = "noc-to-tele-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 16, description = "" },
    { name = "port17", device = "noc-to-tele-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 17, description = "" },
    { name = "port18", device = "noc-to-tele-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 18, description = "" },
    { name = "port19", device = "noc-to-tele-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 19, description = "" },
    { name = "port20", device = "noc-to-tele-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 20, description = "" },
    { name = "port21", device = "noc-to-tele-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 21, description = "" },
    { name = "port22", device = "noc-to-tele-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 22, description = "" },
    { name = "port23", device = "noc-to-tele-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 23, description = "" },
    { name = "port24", device = "noc-to-tele-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 24, description = "" },
    { name = "port1", device = "north-patch", type = "sc-upc", rear_port = "G12-1", rear_port_position = 1, description = "to noc" },
    { name = "port2", device = "north-patch", type = "sc-upc", rear_port = "G12-1", rear_port_position = 2, description = "to noc" },
    { name = "port3", device = "north-patch", type = "sc-upc", rear_port = "G12-1", rear_port_position = 3, description = "to noc" },
    { name = "port4", device = "north-patch", type = "sc-upc", rear_port = "G12-1", rear_port_position = 4, description = "to noc" },
    { name = "port5", device = "north-patch", type = "sc-upc", rear_port = "G12-1", rear_port_position = 5, description = "to noc" },
    { name = "port6", device = "north-patch", type = "sc-upc", rear_port = "G12-1", rear_port_position = 6, description = "to noc" },
    { name = "port19", device = "north-patch", type = "sc-upc", rear_port = "G12-2", rear_port_position = 1, description = "to swing" },
    { name = "port20", device = "north-patch", type = "sc-upc", rear_port = "G12-2", rear_port_position = 2, description = "to swing" },
    { name = "port21", device = "north-patch", type = "sc-upc", rear_port = "G12-2", rear_port_position = 3, description = "to swing" },
    { name = "port22", device = "north-patch", type = "sc-upc", rear_port = "G12-2", rear_port_position = 4, description = "to swing" },
    { name = "port23", device = "north-patch", type = "sc-upc", rear_port = "G12-2", rear_port_position = 5, description = "to swing" },
    { name = "port24", device = "north-patch", type = "sc-upc", rear_port = "G12-2", rear_port_position = 6, description = "to swing" },
    { name = "port1", device = "reception-to-tele-patch", type = "sc-upc", rear_port = "G12", rear_port_position = 1, description = "" },
    { name = "port2", device = "reception-to-tele-patch", type = "sc-upc", rear_port = "G12", rear_port_position = 2, description = "" },
    { name = "port3", device = "reception-to-tele-patch", type = "sc-upc", rear_port = "G12", rear_port_position = 3, description = "" },
    { name = "port4", device = "reception-to-tele-patch", type = "sc-upc", rear_port = "G12", rear_port_position = 4, description = "" },
    { name = "port5", device = "reception-to-tele-patch", type = "sc-upc", rear_port = "G12", rear_port_position = 5, description = "" },
    { name = "port6", device = "reception-to-tele-patch", type = "sc-upc", rear_port = "G12", rear_port_position = 6, description = "" },
    { name = "port1", device = "roof-north-to-roof-south-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 1, description = "" },
    { name = "port2", device = "roof-north-to-roof-south-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 2, description = "" },
    { name = "port3", device = "roof-north-to-roof-south-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 3, description = "" },
    { name = "port4", device = "roof-north-to-roof-south-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 4, description = "" },
    { name = "port5", device = "roof-north-to-roof-south-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 5, description = "" },
    { name = "port6", device = "roof-north-to-roof-south-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 6, description = "" },
    { name = "port7", device = "roof-north-to-roof-south-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 7, description = "" },
    { name = "port8", device = "roof-north-to-roof-south-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 8, description = "" },
    { name = "port9", device = "roof-north-to-roof-south-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 9, description = "" },
    { name = "port10", device = "roof-north-to-roof-south-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 10, description = "" },
    { name = "port11", device = "roof-north-to-roof-south-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 11, description = "" },
    { name = "port12", device = "roof-north-to-roof-south-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 12, description = "" },
    { name = "port13", device = "roof-north-to-roof-south-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 13, description = "" },
    { name = "port14", device = "roof-north-to-roof-south-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 14, description = "" },
    { name = "port15", device = "roof-north-to-roof-south-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 15, description = "" },
    { name = "port16", device = "roof-north-to-roof-south-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 16, description = "" },
    { name = "port17", device = "roof-north-to-roof-south-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 17, description = "" },
    { name = "port18", device = "roof-north-to-roof-south-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 18, description = "" },
    { name = "port19", device = "roof-north-to-roof-south-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 19, description = "" },
    { name = "port20", device = "roof-north-to-roof-south-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 20, description = "" },
    { name = "port21", device = "roof-north-to-roof-south-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 21, description = "" },
    { name = "port22", device = "roof-north-to-roof-south-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 22, description = "" },
    { name = "port23", device = "roof-north-to-roof-south-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 23, description = "" },
    { name = "port24", device = "roof-north-to-roof-south-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 24, description = "" },
    { name = "port1", device = "roof-south-to-roof-north-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 1, description = "" },
    { name = "port2", device = "roof-south-to-roof-north-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 2, description = "" },
    { name = "port3", device = "roof-south-to-roof-north-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 3, description = "" },
    { name = "port4", device = "roof-south-to-roof-north-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 4, description = "" },
    { name = "port5", device = "roof-south-to-roof-north-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 5, description = "" },
    { name = "port6", device = "roof-south-to-roof-north-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 6, description = "" },
    { name = "port7", device = "roof-south-to-roof-north-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 7, description = "" },
    { name = "port8", device = "roof-south-to-roof-north-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 8, description = "" },
    { name = "port9", device = "roof-south-to-roof-north-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 9, description = "" },
    { name = "port10", device = "roof-south-to-roof-north-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 10, description = "" },
    { name = "port11", device = "roof-south-to-roof-north-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 11, description = "" },
    { name = "port12", device = "roof-south-to-roof-north-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 12, description = "" },
    { name = "port13", device = "roof-south-to-roof-north-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 13, description = "" },
    { name = "port14", device = "roof-south-to-roof-north-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 14, description = "" },
    { name = "port15", device = "roof-south-to-roof-north-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 15, description = "" },
    { name = "port16", device = "roof-south-to-roof-north-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 16, description = "" },
    { name = "port17", device = "roof-south-to-roof-north-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 17, description = "" },
    { name = "port18", device = "roof-south-to-roof-north-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 18, description = "" },
    { name = "port19", device = "roof-south-to-roof-north-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 19, description = "" },
    { name = "port20", device = "roof-south-to-roof-north-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 20, description = "" },
    { name = "port21", device = "roof-south-to-roof-north-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 21, description = "" },
    { name = "port22", device = "roof-south-to-roof-north-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 22, description = "" },
    { name = "port23", device = "roof-south-to-roof-north-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 23, description = "" },
    { name = "port24", device = "roof-south-to-roof-north-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 24, description = "" },
    { name = "port1", device = "roof-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 1, description = "" },
    { name = "port2", device = "roof-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 2, description = "" },
    { name = "port3", device = "roof-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 3, description = "" },
    { name = "port4", device = "roof-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 4, description = "" },
    { name = "port5", device = "roof-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 5, description = "" },
    { name = "port6", device = "roof-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 6, description = "" },
    { name = "port7", device = "roof-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 7, description = "" },
    { name = "port8", device = "roof-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 8, description = "" },
    { name = "port9", device = "roof-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 9, description = "" },
    { name = "port10", device = "roof-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 10, description = "" },
    { name = "port11", device = "roof-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 11, description = "" },
    { name = "port12", device = "roof-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 12, description = "" },
    { name = "port13", device = "roof-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 13, description = "" },
    { name = "port14", device = "roof-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 14, description = "" },
    { name = "port15", device = "roof-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 15, description = "" },
    { name = "port16", device = "roof-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 16, description = "" },
    { name = "port17", device = "roof-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 17, description = "" },
    { name = "port18", device = "roof-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 18, description = "" },
    { name = "port19", device = "roof-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 19, description = "" },
    { name = "port20", device = "roof-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 20, description = "" },
    { name = "port21", device = "roof-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 21, description = "" },
    { name = "port22", device = "roof-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 22, description = "" },
    { name = "port23", device = "roof-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 23, description = "" },
    { name = "port24", device = "roof-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 24, description = "" },
    { name = "port1", device = "south-patch", type = "sc-upc", rear_port = "G12-1", rear_port_position = 1, description = "to tele" },
    { name = "port2", device = "south-patch", type = "sc-upc", rear_port = "G12-1", rear_port_position = 2, description = "to tele" },
    { name = "port3", device = "south-patch", type = "sc-upc", rear_port = "G12-1", rear_port_position = 3, description = "to tele" },
    { name = "port4", device = "south-patch", type = "sc-upc", rear_port = "G12-1", rear_port_position = 4, description = "to tele" },
    { name = "port5", device = "south-patch", type = "sc-upc", rear_port = "G12-1", rear_port_position = 5, description = "to tele" },
    { name = "port6", device = "south-patch", type = "sc-upc", rear_port = "G12-1", rear_port_position = 6, description = "to tele" },
    { name = "port19", device = "south-patch", type = "sc-upc", rear_port = "G12-2", rear_port_position = 1, description = "to log" },
    { name = "port20", device = "south-patch", type = "sc-upc", rear_port = "G12-2", rear_port_position = 2, description = "to log" },
    { name = "port21", device = "south-patch", type = "sc-upc", rear_port = "G12-2", rear_port_position = 3, description = "to log" },
    { name = "port22", device = "south-patch", type = "sc-upc", rear_port = "G12-2", rear_port_position = 4, description = "to log" },
    { name = "port23", device = "south-patch", type = "sc-upc", rear_port = "G12-2", rear_port_position = 5, description = "to log" },
    { name = "port24", device = "south-patch", type = "sc-upc", rear_port = "G12-2", rear_port_position = 6, description = "to log" },
    { name = "port1", device = "stand-to-tele-patch", type = "sc-upc", rear_port = "G12", rear_port_position = 1, description = "" },
    { name = "port2", device = "stand-to-tele-patch", type = "sc-upc", rear_port = "G12", rear_port_position = 2, description = "" },
    { name = "port3", device = "stand-to-tele-patch", type = "sc-upc", rear_port = "G12", rear_port_position = 3, description = "" },
    { name = "port4", device = "stand-to-tele-patch", type = "sc-upc", rear_port = "G12", rear_port_position = 4, description = "" },
    { name = "port5", device = "stand-to-tele-patch", type = "sc-upc", rear_port = "G12", rear_port_position = 5, description = "" },
    { name = "port6", device = "stand-to-tele-patch", type = "sc-upc", rear_port = "G12", rear_port_position = 6, description = "" },
    { name = "port1", device = "swing-patch", type = "sc-upc", rear_port = "G12-1", rear_port_position = 1, description = "to north" },
    { name = "port2", device = "swing-patch", type = "sc-upc", rear_port = "G12-1", rear_port_position = 2, description = "to north" },
    { name = "port3", device = "swing-patch", type = "sc-upc", rear_port = "G12-1", rear_port_position = 3, description = "to north" },
    { name = "port4", device = "swing-patch", type = "sc-upc", rear_port = "G12-1", rear_port_position = 4, description = "to north" },
    { name = "port5", device = "swing-patch", type = "sc-upc", rear_port = "G12-1", rear_port_position = 5, description = "to north" },
    { name = "port6", device = "swing-patch", type = "sc-upc", rear_port = "G12-1", rear_port_position = 6, description = "to north" },
    { name = "port19", device = "swing-patch", type = "sc-upc", rear_port = "G12-2", rear_port_position = 1, description = "to log" },
    { name = "port20", device = "swing-patch", type = "sc-upc", rear_port = "G12-2", rear_port_position = 2, description = "to log" },
    { name = "port21", device = "swing-patch", type = "sc-upc", rear_port = "G12-2", rear_port_position = 3, description = "to log" },
    { name = "port22", device = "swing-patch", type = "sc-upc", rear_port = "G12-2", rear_port_position = 4, description = "to log" },
    { name = "port23", device = "swing-patch", type = "sc-upc", rear_port = "G12-2", rear_port_position = 5, description = "to log" },
    { name = "port24", device = "swing-patch", type = "sc-upc", rear_port = "G12-2", rear_port_position = 6, description = "to log" },
    { name = "port1", device = "tele-patch", type = "sc-upc", rear_port = "G12", rear_port_position = 1, description = "to south" },
    { name = "port2", device = "tele-patch", type = "sc-upc", rear_port = "G12", rear_port_position = 2, description = "to south" },
    { name = "port3", device = "tele-patch", type = "sc-upc", rear_port = "G12", rear_port_position = 3, description = "to south" },
    { name = "port4", device = "tele-patch", type = "sc-upc", rear_port = "G12", rear_port_position = 4, description = "to south" },
    { name = "port5", device = "tele-patch", type = "sc-upc", rear_port = "G12", rear_port_position = 5, description = "to south" },
    { name = "port6", device = "tele-patch", type = "sc-upc", rear_port = "G12", rear_port_position = 6, description = "to south" },
    { name = "port8", device = "tele-patch", type = "sc-upc", rear_port = "G24-1", rear_port_position = 1, description = "to reception" },
    { name = "port9", device = "tele-patch", type = "sc-upc", rear_port = "G24-1", rear_port_position = 2, description = "to reception" },
    { name = "port10", device = "tele-patch", type = "sc-upc", rear_port = "G24-1", rear_port_position = 3, description = "to reception" },
    { name = "port11", device = "tele-patch", type = "sc-upc", rear_port = "G24-1", rear_port_position = 4, description = "to reception" },
    { name = "port12", device = "tele-patch", type = "sc-upc", rear_port = "G24-1", rear_port_position = 5, description = "to reception" },
    { name = "port13", device = "tele-patch", type = "sc-upc", rear_port = "G24-1", rear_port_position = 6, description = "to reception" },
    { name = "port14", device = "tele-patch", type = "sc-upc", rear_port = "G24-2", rear_port_position = 1, description = "to stand" },
    { name = "port15", device = "tele-patch", type = "sc-upc", rear_port = "G24-2", rear_port_position = 2, description = "to stand" },
    { name = "port16", device = "tele-patch", type = "sc-upc", rear_port = "G24-2", rear_port_position = 3, description = "to stand" },
    { name = "port17", device = "tele-patch", type = "sc-upc", rear_port = "G24-2", rear_port_position = 4, description = "to stand" },
    { name = "port18", device = "tele-patch", type = "sc-upc", rear_port = "G24-2", rear_port_position = 5, description = "to stand" },
    { name = "port19", device = "tele-patch", type = "sc-upc", rear_port = "G24-2", rear_port_position = 6, description = "to stand" },
    { name = "port20", device = "tele-patch", type = "sc-upc", rear_port = "telenor", rear_port_position = 1, description = "Telenor" },
    { name = "port21", device = "tele-patch", type = "sc-upc", rear_port = "telenor", rear_port_position = 2, description = "Telenor" },
    { name = "port22", device = "tele-patch", type = "sc-upc", rear_port = "telenor", rear_port_position = 3, description = "Telenor" },
    { name = "port23", device = "tele-patch", type = "sc-upc", rear_port = "telenor", rear_port_position = 4, description = "Telenor" },
    { name = "port24", device = "tele-patch", type = "sc-upc", rear_port = "telenor", rear_port_position = 5, description = "Telenor" },
    { name = "port1", device = "tele-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 1, description = "" },
    { name = "port2", device = "tele-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 2, description = "" },
    { name = "port3", device = "tele-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 3, description = "" },
    { name = "port4", device = "tele-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 4, description = "" },
    { name = "port5", device = "tele-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 5, description = "" },
    { name = "port6", device = "tele-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 6, description = "" },
    { name = "port7", device = "tele-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 7, description = "" },
    { name = "port8", device = "tele-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 8, description = "" },
    { name = "port9", device = "tele-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 9, description = "" },
    { name = "port10", device = "tele-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 10, description = "" },
    { name = "port11", device = "tele-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 11, description = "" },
    { name = "port12", device = "tele-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 12, description = "" },
    { name = "port13", device = "tele-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 13, description = "" },
    { name = "port14", device = "tele-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 14, description = "" },
    { name = "port15", device = "tele-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 15, description = "" },
    { name = "port16", device = "tele-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 16, description = "" },
    { name = "port17", device = "tele-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 17, description = "" },
    { name = "port18", device = "tele-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 18, description = "" },
    { name = "port19", device = "tele-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 19, description = "" },
    { name = "port20", device = "tele-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 20, description = "" },
    { name = "port21", device = "tele-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 21, description = "" },
    { name = "port22", device = "tele-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 22, description = "" },
    { name = "port23", device = "tele-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 23, description = "" },
    { name = "port24", device = "tele-to-noc-patch", type = "sc-upc", rear_port = "G48", rear_port_position = 24, description = "" },
    { name = "port1", device = "vrimle-patch", type = "sc-upc", rear_port = "G12", rear_port_position = 1, description = "" },
    { name = "port2", device = "vrimle-patch", type = "sc-upc", rear_port = "G12", rear_port_position = 2, description = "" },
    { name = "port3", device = "vrimle-patch", type = "sc-upc", rear_port = "G12", rear_port_position = 3, description = "" },
    { name = "port4", device = "vrimle-patch", type = "sc-upc", rear_port = "G12", rear_port_position = 4, description = "" },
    { name = "port5", device = "vrimle-patch", type = "sc-upc", rear_port = "G12", rear_port_position = 5, description = "" },
    { name = "port6", device = "vrimle-patch", type = "sc-upc", rear_port = "G12", rear_port_position = 6, description = "" }
  ]
  cables = [
    { side_a_device = "tele-to-noc-patch", side_a_name = "G48", side_a_type = "dcim.rearport", side_b_device = "noc-to-tele-patch", side_b_name = "G48", side_b_type = "dcim.rearport", status = "connected", type = "smf", length = 100, length_unit = "m", color = "ffeb3b", description = "TG-fiber", tags = ["tg-fiber"] },
    { side_a_device = "noc-to-north-patch", side_a_name = "G12", side_a_type = "dcim.rearport", side_b_device = "north-patch", side_b_name = "G12-1", side_b_type = "dcim.rearport", status = "connected", type = "smf", length = 190, length_unit = "m", color = "ffeb3b", description = "TG-fiber", tags = ["tg-fiber"] },
    { side_a_device = "north-patch", side_a_name = "G12-2", side_a_type = "dcim.rearport", side_b_device = "swing-patch", side_b_name = "G12-1", side_b_type = "dcim.rearport", status = "connected", type = "smf", length = 100, length_unit = "m", color = "ffeb3b", description = "TG-fiber", tags = ["tg-fiber"] },
    { side_a_device = "swing-patch", side_a_name = "G12-2", side_a_type = "dcim.rearport", side_b_device = "log-patch", side_b_name = "G12-1", side_b_type = "dcim.rearport", status = "connected", type = "smf", length = 80, length_unit = "m", color = "ffeb3b", description = "TG-fiber", tags = ["tg-fiber"] },
    { side_a_device = "log-patch", side_a_name = "G12-2", side_a_type = "dcim.rearport", side_b_device = "south-patch", side_b_name = "G12-2", side_b_type = "dcim.rearport", status = "connected", type = "smf", length = 60, length_unit = "m", color = "ffeb3b", description = "TG-fiber", tags = ["tg-fiber"] },
    { side_a_device = "south-patch", side_a_name = "G12-1", side_a_type = "dcim.rearport", side_b_device = "tele-patch", side_b_name = "G12", side_b_type = "dcim.rearport", status = "connected", type = "smf", length = 70, length_unit = "m", color = "ffeb3b", description = "TG-fiber", tags = ["tg-fiber"] },
    { side_a_device = "roof-to-noc-patch", side_a_name = "G48", side_a_type = "dcim.rearport", side_b_device = "noc-to-roof-patch", side_b_name = "G48", side_b_type = "dcim.rearport", status = "connected", type = "smf", length = 100, length_unit = "m", color = "ffeb3b", description = "TG-fiber", tags = ["tg-fiber"] },
    { side_a_device = "tele-patch", side_a_name = "G24-1", side_a_type = "dcim.rearport", side_b_device = "reception-to-tele-patch", side_b_name = "G12", side_b_type = "dcim.rearport", status = "connected", type = "smf", length = 180, length_unit = "m", color = "ffeb3b", description = "TG-fiber", tags = ["tg-fiber"] },
    { side_a_device = "stand-to-tele-patch", side_a_name = "G12", side_a_type = "dcim.rearport", side_b_device = "tele-patch", side_b_name = "G24-2", side_b_type = "dcim.rearport", status = "connected", type = "smf", length = 0, length_unit = "m", color = "ffeb3b", description = "TG-fiber", tags = ["tg-fiber"] },
    { side_a_device = "roof-north-to-roof-south-patch", side_a_name = "G48", side_a_type = "dcim.rearport", side_b_device = "roof-south-to-roof-north-patch", side_b_name = "G48", side_b_type = "dcim.rearport", status = "connected", type = "smf", length = 70, length_unit = "m", color = "ffeb3b", description = "TG-fiber", tags = ["tg-fiber"] },
    { side_a_device = "log-patch", side_a_name = "G12-3", side_a_type = "dcim.rearport", side_b_device = "vrimle-patch", side_b_name = "G12", side_b_type = "dcim.rearport", status = "connected", type = "smf", length = 50, length_unit = "m", color = "ffeb3b", description = "TG-fiber", tags = ["tg-fiber"] }
  ]    
}

resource "netbox_device_type" "device_types" {
  for_each = { for device_type in local.device_types : device_type.slug => device_type }
  model = each.value.name
  manufacturer_id = netbox_manufacturer.manufacturers[lower(each.value.manufacturer)].id
  part_number  = each.value.part_number
  u_height     = each.value.u_height
  is_full_depth = each.value.is_full_depth
  slug         = each.value.slug
}

resource "netbox_device" "devices" {
  for_each = { for device in local.devices : device.name => device }
  name       = each.value.name
  status     = each.value.status
  site_id    = netbox_site.the_ship.id
  location_id = netbox_location.locations[each.value.location].id
  role_id = netbox_device_role.roles[replace(lower(each.value.role), " ", "-")].id
  device_type_id = netbox_device_type.device_types[each.value.device_type].id
}

resource "netbox_device_rear_port" "rear_ports" {
  for_each = { for rear_ports in local.rear_ports : "${rear_ports.device}-${rear_ports.name}" => rear_ports }
  device_id   = netbox_device.devices[each.value.device].id
  name        = each.value.name
  type        = each.value.type
  description = each.value.description
  positions   = each.value.positions
}

resource "netbox_device_front_port" "front_ports" {
  for_each = { for front_ports in local.front_ports : "${front_ports.device}-${front_ports.name}" => front_ports }
  device_id   = netbox_device.devices[each.value.device].id
  name        = each.value.name
  type        = each.value.type
  rear_port_id = netbox_device_rear_port.rear_ports["${each.value.device}-${each.value.rear_port}"].id
  rear_port_position = each.value.rear_port_position
  description = each.value.description
}

resource "netbox_cable" "cables" {
  for_each = { for cable in local.cables : "${cable.side_a_device}-${cable.side_a_name}-to-${cable.side_b_device}-${cable.side_b_name}" => cable }
  a_termination {
    object_type = each.value.side_a_type
    object_id   = netbox_device_rear_port.rear_ports["${each.value.side_a_device}-${each.value.side_a_name}"].id
  }
  b_termination {
    object_type = each.value.side_b_type
    object_id   = netbox_device_rear_port.rear_ports["${each.value.side_b_device}-${each.value.side_b_name}"].id
  }
  status          = each.value.status
  type            = each.value.type
  length          = each.value.length
  length_unit     = each.value.length_unit
  color_hex       = each.value.color
  description     = each.value.description
}