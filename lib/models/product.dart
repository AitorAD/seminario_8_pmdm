import 'dart:convert';

import 'package:intl/intl.dart';

class Product {
  String? id;
  bool available;
  String name;
  String? picture;
  double price;
  DateTime registerDate;

  Product({
    this.id,
    required this.available,
    required this.name,
    this.picture,
    required this.price,
    required this.registerDate,
  });

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        available: json["available"] ?? false,
        name: json["name"] ?? 'None',
        picture: json["picture"],
        price: json["price"]?.toDouble() ?? 0.0,
        registerDate: DateFormat('dd/MM/yyyy').parse(json["registerDate"]) ??
            DateTime.now(),
      );

  Map<String, dynamic> toMap() => {
        "available": available,
        "name": name,
        "picture": picture,
        "price": price,
        "registerDate": DateFormat('dd/MM/yyyy').format(registerDate),
      };

  @override
  String toString() {
    return 'id: $id, available: $name, available: $available, picture: $picture, price: $price';
  }

  Product copy() => Product(
        available: this.available,
        name: this.name,
        picture: this.picture,
        price: this.price,
        id: this.id,
        registerDate: this.registerDate,
      );
}
