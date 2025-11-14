import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  final String baseUrl = 'http://10.0.2.2:8080/api/products';

  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Product.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Product> createProduct(Product product, {File? image}) async {
    var request = http.MultipartRequest('POST', Uri.parse(baseUrl));
    request.fields['name'] = product.name;
    request.fields['description'] = product.description;
    request.fields['price'] = product.price.toString();
    request.fields['categoryId'] = product.category.id.toString();

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    print("Response: ${response.statusCode} - $responseBody");

    if (response.statusCode == 201) {
      return Product.fromJson(json.decode(responseBody));
    } else {
      throw Exception(
        'Failed to create product: ${response.statusCode} - $responseBody',
      );
    }
  }

  Future<Product> updateProduct(int id, Product product, {File? image}) async {
    var request = http.MultipartRequest('PUT', Uri.parse('$baseUrl/$id'));
    request.fields['name'] = product.name;
    request.fields['description'] = product.description;
    request.fields['price'] = product.price.toString();
    request.fields['categoryId'] = product.category.id.toString();

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(responseBody));
    } else {
      throw Exception(
        'Failed to update product: ${response.statusCode} - $responseBody',
      );
    }
  }

  Future<void> deleteProduct(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete product');
    }
  }
}
