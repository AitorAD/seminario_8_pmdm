import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seminario_8_pmdm/models/product.dart';
import 'package:seminario_8_pmdm/screens/screens.dart';
import 'package:seminario_8_pmdm/services/services.dart';
import 'package:seminario_8_pmdm/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  static final routeName = 'home_screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);

    return productsService.isLoading
        ? LoadingScreen()
        : Scaffold(
            appBar: AppBar(
              title: Text('Productos'),
              actions: [
                IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () {
                    authService.logout();
                    Navigator.pushReplacementNamed(
                      context,
                      LogInScreen.routeName,
                    );
                  },
                ),
              ],
            ),
            body: ListView.builder(
              itemCount: productsService.products.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(productsService.products[index].id.toString()),
                  direction: DismissDirection.horizontal,
                  onDismissed: (direction) async {
                    final isDeleted = await productsService.deleteProduct(
                      productsService.products[index],
                    );

                    final message = isDeleted
                        ? 'Producto eliminado con éxito'
                        : 'Error al eliminar el producto';

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(message)),
                    );
                  },
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("¿Eliminar producto?"),
                          content: Text(
                              "¿Estás seguro de que deseas eliminar este producto?"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text("Cancelar"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: Text("Eliminar"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  background: backgroundDismiss(Alignment.centerLeft),
                  secondaryBackground: backgroundDismiss(Alignment.centerRight),
                  child: GestureDetector(
                    onTap: () {
                      productsService.selectedProduct =
                          productsService.products[index].copy();
                      Navigator.pushNamed(context, ProductScreen.routeName);
                    },
                    child:
                        ProductCard(product: productsService.products[index]),
                  ),
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                productsService.selectedProduct = Product(
                    available: false,
                    name: '',
                    price: 0.0,
                    registerDate: DateTime.now());

                Navigator.pushNamed(context, ProductScreen.routeName);
              },
            ),
          );
  }

  Container backgroundDismiss(Alignment alignment) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      alignment: alignment,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Icon(Icons.delete, color: Colors.white, size: 38),
    );
  }
}
