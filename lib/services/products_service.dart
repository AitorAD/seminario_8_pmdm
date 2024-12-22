import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:seminario_8_pmdm/models/product.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier {
  final String _baseUrl = 'seminario-7-default-rtdb.firebaseio.com';
  final storage = const FlutterSecureStorage();

  final List<Product> products = [];
  bool isLoading = true;
  bool isSaving = false;
  late Product selectedProduct;
  File? newPictureFile;

  ProductsService() {
    this.loadProducts();
  }

  Future<List<Product>> loadProducts() async {
    this.isLoading = true;
    notifyListeners();

    final token = await storage.read(key: 'token') ?? '';

    final url = Uri.https(_baseUrl, '/products.json', {
      'auth': token,
    });
    final resp = await http.get(url);

    print('respuesta load: ${resp.body}');
    final Map<String, dynamic> productsMap = jsonDecode(resp.body);

    productsMap.forEach((key, value) {
      final tempProduct = Product.fromMap(value);
      tempProduct.id = key;
      this.products.add(tempProduct);
    });

    this.isLoading = false;
    notifyListeners();

    print(this.products[0]);
    return this.products;
  }

  Future<String> updateProduct(Product product) async {
    final url = Uri.https(_baseUrl, '/products/${product.id}.json', {
      'auth': await storage.read(key: 'token') ?? '',
    });
    final resp = await http.put(url, body: product.toJson());
    final decodedData = resp.body;

    print(decodedData);

    final index = products.indexWhere((element) => element.id == product.id);
    products[index] = product;

    return product.id!;
  }

  Future<String> createProduct(Product product) async {
    final url = Uri.https(_baseUrl, '/products.json', {
      'auth': await storage.read(key: 'token') ?? '',
    });
    final resp = await http.post(url, body: product.toJson());
    final decodedData = json.decode(resp.body);

    product.id = decodedData['name'];

    this.products.add(product);

    return product.id!;
  }

  Future<bool> deleteProduct(Product product) async {
    final url = Uri.https(_baseUrl, '/products/${product.id}.json', {
      'auth': await storage.read(key: 'token') ?? '',
    });
    final resp = await http.delete(url, body: product.toJson());

    if (resp.statusCode == 200) {
      this.products.remove(product);
      return true;
    }
    return false;
  }

  Future saveOrCreateProduct(Product product) async {
    isSaving = true;
    notifyListeners();

    if (product.id == null) {
      await createProduct(product);
    } else {
      await this.updateProduct(product);
    }
    isSaving = false;
    notifyListeners();
  }

  void updateSelectedProductImage(String path) {
    selectedProduct.picture = path;
    newPictureFile = File.fromUri(Uri(path: path));
    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (newPictureFile == null) return null;

    isSaving = true;
    notifyListeners();
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/drxrreaev/image/upload?upload_preset=preset');

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file =
        await http.MultipartFile.fromPath('file', newPictureFile!.path);

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Ha habido un error');
      print(resp.body);
      return null;
    }

    newPictureFile = null;
    final decodedData = json.decode(resp.body);
    return decodedData['secure_url'];
  }
}
