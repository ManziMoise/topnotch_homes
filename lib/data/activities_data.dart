import '../models/activity.dart';
import '../models/tourist_company.dart';

const List<Activity> allActivities = [
  // Musanze / Volcanoes
  Activity(
    id: 'a1',
    name: 'Gorilla Trekking',
    description:
        'Trek through Volcanoes National Park to observe endangered mountain gorillas in their natural habitat.',
    type: ActivityType.wildlife,
    city: 'Musanze',
    price: 1500,
    companyName: 'Rwanda Development Board',
  ),
  Activity(
    id: 'a2',
    name: 'Golden Monkey Tracking',
    description:
        'Explore bamboo forests and track playful golden monkeys, endemic to the Virunga Mountains.',
    type: ActivityType.wildlife,
    city: 'Musanze',
    price: 100,
    companyName: 'Virunga Adventures',
  ),
  Activity(
    id: 'a3',
    name: 'Mount Bisoke Hike',
    description:
        'Climb to the crater lake atop Mount Bisoke volcano at 3,711m. A challenging but rewarding day hike.',
    type: ActivityType.adventure,
    city: 'Musanze',
    price: 75,
    companyName: 'Rwanda Eco Tours',
  ),

  // Rubavu / Lake Kivu
  Activity(
    id: 'a4',
    name: 'Lake Kivu Boat Tour',
    description:
        'Scenic boat ride on Lake Kivu with stops at Napoleon Island and fishing villages.',
    type: ActivityType.water,
    city: 'Rubavu',
    price: 40,
    companyName: 'Kivu Adventures',
  ),
  Activity(
    id: 'a5',
    name: 'Kayaking on Lake Kivu',
    description:
        'Paddle through the calm waters of Lake Kivu, exploring hidden coves and beaches.',
    type: ActivityType.water,
    city: 'Rubavu',
    price: 30,
    companyName: 'Kivu Adventures',
  ),
  Activity(
    id: 'a6',
    name: 'Hot Springs Visit',
    description:
        'Relax in natural hot springs near the lake, surrounded by lush tropical vegetation.',
    type: ActivityType.nature,
    city: 'Rubavu',
    price: 15,
    companyName: 'Rwanda Eco Tours',
  ),

  // Kigali
  Activity(
    id: 'a7',
    name: 'Kigali City Tour',
    description:
        'Explore the vibrant capital: visit the Genocide Memorial, Kimironko Market, and Inema Arts Center.',
    type: ActivityType.cultural,
    city: 'Kigali',
    price: 50,
    companyName: 'Kigali City Tours',
  ),
  Activity(
    id: 'a8',
    name: 'Rwandan Cooking Class',
    description:
        'Learn to prepare traditional Rwandan dishes like brochettes, isombe, and ibihaza.',
    type: ActivityType.cultural,
    city: 'Kigali',
    price: 35,
    companyName: 'Taste of Rwanda',
  ),
  Activity(
    id: 'a9',
    name: 'Nyamirambo Walking Tour',
    description:
        'Walk through Kigali\'s most vibrant neighborhood, visiting local markets, tailors, and music spots.',
    type: ActivityType.cultural,
    city: 'Kigali',
    price: 25,
    companyName: 'Kigali City Tours',
  ),

  // Rusizi / Nyungwe
  Activity(
    id: 'a10',
    name: 'Chimpanzee Tracking',
    description:
        'Track habituated chimpanzees through the ancient Nyungwe Forest, one of Africa\'s oldest rainforests.',
    type: ActivityType.wildlife,
    city: 'Rusizi',
    price: 90,
    companyName: 'Nyungwe Park Tours',
  ),
  Activity(
    id: 'a11',
    name: 'Canopy Walkway',
    description:
        'Walk along the 200m-long suspension bridge 50m above the forest floor for breathtaking views.',
    type: ActivityType.adventure,
    city: 'Rusizi',
    price: 60,
    companyName: 'Nyungwe Park Tours',
  ),

  // Huye
  Activity(
    id: 'a12',
    name: 'National Museum Visit',
    description:
        'Explore Rwanda\'s ethnographic museum with exhibits on traditional culture, history, and art.',
    type: ActivityType.cultural,
    city: 'Huye',
    price: 10,
    companyName: 'Rwanda Museums',
  ),

  // Bugesera
  Activity(
    id: 'a13',
    name: 'Lake Rweru Fishing Trip',
    description:
        'Join local fishermen on Lake Rweru for a traditional fishing experience at sunrise.',
    type: ActivityType.water,
    city: 'Bugesera',
    price: 20,
    companyName: 'Bugesera Tours',
  ),
];

const List<TouristCompany> touristCompanies = [
  TouristCompany(
    id: 'tc1',
    name: 'Rwanda Development Board',
    city: 'Kigali',
    phone: '+250 252 576 514',
    website: 'visitrwanda.com',
    services: ['Gorilla Permits', 'National Park Access', 'Tourism Info'],
  ),
  TouristCompany(
    id: 'tc2',
    name: 'Kivu Adventures',
    city: 'Rubavu',
    phone: '+250 788 123 456',
    services: ['Boat Tours', 'Kayaking', 'Fishing Trips', 'Beach Activities'],
  ),
  TouristCompany(
    id: 'tc3',
    name: 'Virunga Adventures',
    city: 'Musanze',
    phone: '+250 788 234 567',
    services: ['Gorilla Trekking', 'Monkey Tracking', 'Volcano Hikes'],
  ),
  TouristCompany(
    id: 'tc4',
    name: 'Rwanda Eco Tours',
    city: 'Kigali',
    phone: '+250 788 345 678',
    services: ['Eco Tours', 'Hot Springs', 'Nature Walks', 'Bird Watching'],
  ),
  TouristCompany(
    id: 'tc5',
    name: 'Kigali City Tours',
    city: 'Kigali',
    phone: '+250 788 456 789',
    services: ['City Tours', 'Walking Tours', 'Cultural Experiences'],
  ),
  TouristCompany(
    id: 'tc6',
    name: 'Nyungwe Park Tours',
    city: 'Rusizi',
    phone: '+250 788 567 890',
    services: ['Chimpanzee Tracking', 'Canopy Walk', 'Forest Hikes'],
  ),
];

List<Activity> getActivitiesForCity(String city) {
  return allActivities
      .where((a) => a.city.toLowerCase() == city.toLowerCase())
      .toList();
}

List<TouristCompany> getCompaniesForCity(String city) {
  return touristCompanies
      .where((c) => c.city.toLowerCase() == city.toLowerCase())
      .toList();
}
