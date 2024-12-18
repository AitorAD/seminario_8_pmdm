import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:seminario_8_pmdm/models/product.dart';
import 'package:seminario_8_pmdm/providers/providers.dart';
import 'package:seminario_8_pmdm/ui/input_decorations.dart';

import '../services/services.dart';
import '../widgets/product_image.dart';

class ProductScreen extends StatelessWidget {
  static final routeName = 'product_screen';
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);

    return ChangeNotifierProvider(
      create: (_) => ProductFormProvider(productsService.selectedProduct),
      child: _ProductScreenBody(productsService: productsService),
    );
  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    super.key,
    required this.productsService,
  });

  final ProductsService productsService;

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (!productForm.isValidForm()) return;

          await productsService.saveOrCreateProduct(productForm.product);
        },
        child: productsService.isSaving
            ? CircularProgressIndicator(color: Colors.white)
            : Icon(Icons.save_outlined),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ProductImage(url: productForm.product.picture),
                Positioned(
                  top: 60,
                  left: 20,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_sharp,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  top: 60,
                  right: 20,
                  child: IconButton(
                    onPressed: () async {
                      await _processImage(productForm, ImageSource.camera);
                    },
                    icon: Icon(
                      Icons.camera_alt_outlined,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: IconButton(
                    onPressed: () async {
                      await _processImage(productForm, ImageSource.gallery);
                    },
                    icon: Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            _ProductForm(
              product: productsService.selectedProduct,
              productForm: productForm,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _processImage(
      ProductFormProvider productForm, ImageSource imageSource) async {
    final _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: imageSource, imageQuality: 100);

    if (pickedFile == null) {
      print('No seleccionó nada');
      return;
    }

    productsService.newPictureFile = File(pickedFile.path);

    final String? imageUrl = await productsService.uploadImage();
    print('Uploaded Image URL: $imageUrl');

    if (imageUrl != null) {
      productsService.updateSelectedProductImage(imageUrl);
      productForm.product.picture = imageUrl;
    }
  }
}

class _ProductForm extends StatelessWidget {
  final Product product;
  final ProductFormProvider productForm;
  const _ProductForm({
    super.key,
    required this.product,
    required this.productForm,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: Offset(0, 5),
                blurRadius: 5)
          ],
        ),
        child: Form(
          key: productForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              SizedBox(height: 10),
              TextFormField(
                initialValue: product.name,
                onChanged: (value) => product.name = value,
                validator: (value) {
                  if (value == null || value.length < 1) {
                    return 'El nombre es obligatorio';
                  }
                  return null;
                },
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Nombre del producto',
                  labelText: 'Nombre',
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                initialValue: '${product.price}',
                onChanged: (value) {
                  if (double.tryParse(value) == null) {
                    product.price = 0;
                  } else {
                    product.price = double.parse(value);
                  }
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^(\d+)?\.?\d{0,2}'))
                ],
                keyboardType: TextInputType.number,
                decoration: InputDecorations.authInputDecoration(
                  hintText: '150€',
                  labelText: 'Precio',
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                initialValue:
                    DateFormat('dd/MM/yyyy').format(product.registerDate),
                enabled: false,
                keyboardType: TextInputType.datetime,
                decoration: InputDecorations.authInputDecoration(
                  hintText: '01/01/2000',
                  labelText: 'Fecha de registro',
                ),
              ),
              SizedBox(height: 15),
              SwitchListTile.adaptive(
                value: product.available,
                title: Text('Disponible'),
                activeColor: Colors.indigo,
                onChanged: (value) => productForm.updateAvailabitily(value),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
