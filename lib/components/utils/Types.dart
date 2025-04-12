import 'package:medibound_ui/medibound_ui.dart';


List<MBInfo> mBOrganizationTypes = [
  MBInfo(
    display: "Manufacturer",
    description: "Production and assembly of physical goods or devices",
    code: "OT01",
    color: getMBColorByName("Slate"),
    icon: "factory",
  ),
  MBInfo(
    display: "Software Development",
    description: "Creating and maintaining software applications and systems",
    code: "OT02",
    color: getMBColorByName("Slate"),
    icon: "code",
  ),
  MBInfo(
    display: "Health and Wellness",
    description: "Physical and mental well-being, often through products, services, or programs",
    code: "OT03",
    color: getMBColorByName("Slate"),
    icon: "health_and_safety",
  ),
  MBInfo(
    display: "Fitness and Sports",
    description: "Athletic performance, exercise equipment, sports training, or related services",
    code: "OT04",
    color: getMBColorByName("Slate"),
    icon: "sports",
  ),
  MBInfo(
    display: "Research and Development",
    description: "Innovation, experimentation, and the development of new technologies or products",
    code: "OT05",
    color: getMBColorByName("Slate"),
    icon: "science",
  ),
  MBInfo(
    display: "Security and Privacy",
    description: "Protection of data, devices, or physical environments through advanced security measures",
    code: "OT06",
    color: getMBColorByName("Slate"),
    icon: "security",
  ),
  MBInfo(
    display: "Fashion and Design",
    description: "Apparel, accessories, and aesthetic-focused design solutions",
    code: "OT07",
    color: getMBColorByName("Slate"),
    icon: "design_services",
  ),
  MBInfo(
    display: "Retail and Distribution",
    description: "Sale, delivery, and logistics of products to end-users or other businesses",
    code: "OT08",
    color: getMBColorByName("Slate"),
    icon: "shopping_cart",
  ),
  MBInfo(
    display: "Education",
    description: "Learning, teaching, and knowledge dissemination through programs, tools, or platforms",
    code: "OT09",
    color: getMBColorByName("Slate"),
    icon: "school",
  ),
];

// Suggested code may be subject to a license. Learn more: ~LicenseLog:3557610469.
List<MBInfo> mBDeviceTypes = [
  MBInfo(
    display: "Health Rings",
    description: "Wearables",
    code: "DT01",
    color: getMBColorByName("Slate"),
    icon: "heart_broken",
  ),
  MBInfo(
    display: "Smart Watches",
    description: "Wearables",
    code: "DT02",
    color: getMBColorByName("Slate"),
    icon: "watch",
  ),
  MBInfo(
    display: "Fitness Bands",
    description: "Wearables",
    code: "DT03",
    color: getMBColorByName("Slate"),
    icon: "fitness_center",
  ),
  MBInfo(
    display: "Smart Glasses",
    description: "Wearables",
    code: "DT04",
    color: getMBColorByName("Slate"),
    icon: "remove_red_eye",
  ),
  MBInfo(
    display: "Activity Trackers",
    description: "Wearables",
    code: "DT05",
    color: getMBColorByName("Slate"),
    icon: "activity",
  ),
  MBInfo(
    display: "Sleep Monitors",
    description: "Wearables",
    code: "DT06",
    color: getMBColorByName("Slate"),
    icon: "bedtime",
  ),
  MBInfo(
    display: "Heart Rate Monitors",
    description: "Wearables",
    code: "DT07",
    color: getMBColorByName("Slate"),
    icon: "favorite",
  ),
  MBInfo(
    display: "Smart Clothing",
    description: "Wearables",
    code: "DT08",
    color: getMBColorByName("Slate"),
    icon: "checkroom",
  ),
  MBInfo(
    display: "GPS Trackers",
    description: "Wearables",
    code: "DT09",
    color: getMBColorByName("Slate"),
    icon: "gps_fixed",
  ),
  MBInfo(
    display: "UV Sensors",
    description: "Wearables",
    code: "DT10",
    color: getMBColorByName("Slate"),
    icon: "wb_sunny",
  ),
  MBInfo(
    display: "Other",
    description: "Other",
    code: "OTHER",
    color: getMBColorByName("Slate"),
    icon: "more_horiz",
  ),
];

List<MBInfo> mBPatientStatus = [
  MBInfo(
    display: "Invited",
    description: "Patient has been invited but not yet linked their account",
    code: "invited",
    color: getMBColorByName("Slate"),
    icon: "person_add",
  ),
  MBInfo(
    display: "Linked",
    description: "Patient has successfully linked their account",
    code: "linked",
    color: getMBColorByName("Health"),
    icon: "link",
  ),
];

List<MBInfo> mBDeviceStatus = [
  MBInfo(
    display: "Idle",
    description: "Device is powered on but not actively collecting data",
    code: "idle",
    color: getMBColorByName("Slate"),
    icon: "power_settings_new",
  ),
  MBInfo(
    display: "Ready",
    description: "Device is ready to start collecting data",
    code: "ready",
    color: getMBColorByName("Health"),
    icon: "check_circle",
  ),
  MBInfo(
    display: "Running",
    description: "Device is actively collecting data",
    code: "running",
    color: getMBColorByName("Munsell"),
    icon: "play_circle",
  ),
  MBInfo(
    display: "Stopped",
    description: "Device has stopped collecting data",
    code: "stopped",
    color: getMBColorByName("Crayola"),
    icon: "stop_circle",
  ),
  MBInfo(
    display: "Reset",
    description: "Device is resetting",
    code: "reset",
    color: getMBColorByName("Amber"),
    icon: "restart_alt",
  ),
  MBInfo(
    display: "Offline",
    description: "Device is not connected",
    code: "offline",
    color: getMBColorByName("Slate"),
    icon: "cloud_off",
  ),
];

List<MBInfo> mBRegistrationStatus = [
  MBInfo(
    display: "Registered",
    description: "Device is registered and ready to use",
    code: "registered",
    color: getMBColorByName("Health"),
    icon: "verified",
  ),
  MBInfo(
    display: "Needs to Register",
    description: "Device needs to be registered before use",
    code: "unregistered",
    color: getMBColorByName("Crayola"),
    icon: "warning",
  ),
];