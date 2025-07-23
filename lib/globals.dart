import 'models/orderhistorymodel.dart';
// Global variables to be accessed in both screens

List<Map<String, String>> dishes = [
  {'name': 'Lomi', 'price': '₱75.00', 'image': 'assets/images/lomi.jpg'},
  {'name': 'Sweet & Spicy', 'price': '₱75.00', 'image': 'assets/images/sweet_and_spicy.png'},
  {'name': 'Plain', 'price': '₱75.00', 'image': 'assets/images/plain.png'},
  {'name': 'Bihon', 'price': '₱75.00', 'image': 'assets/images/Pancit_Canton_Bihon_Guisado.png'},
  {'name': 'Tapsilog', 'price': '₱75.00', 'image': 'assets/images/tapsilog.png'},
  {'name': 'Hotsilog', 'price': '₱75.00', 'image': 'assets/images/hotsilog.png'},
];

List<Map<String, String>> bilao = [
  {'name': 'Pancit Bilao', 'price': '₱250.00', 'image': 'assets/images/Pancit_Canton_Bihon_Guisado.png'},
  {'name': 'Spaghetti Bilao', 'price': '₱280.00', 'image': 'assets/images/Spaghetti.png'},
  {'name': 'Palabok Bilao', 'price': '₱300.00', 'image': 'assets/images/palabok_bilao.png'},
  {'name': 'Chami Bilao', 'price': '₱270.00', 'image': 'assets/images/chami_bilao.png'},
];

List<Map<String, String>> desserts = [
  {'name': 'Graham', 'price': '₱75.00', 'image': 'assets/images/Graham.png'},
  {'name': 'Leche Plan', 'price': '₱75.00', 'image': 'assets/images/leche-flan.png'},
  {'name': 'Graham Bar', 'price': '₱75.00', 'image': 'assets/images/graham-bar.png'},
  {'name': 'Maja Blanca', 'price': '₱75.00', 'image': 'assets/images/maja.jpg'},
];


List<Order> orders = [];
List<Order> orderHistory = [];
List<Order> reservations = [];