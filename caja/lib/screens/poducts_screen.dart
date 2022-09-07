import 'dart:io';
import 'package:caja/models/diet.dart';
import 'package:caja/models/extra.dart';
import 'package:caja/models/products.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:caja/helpers/database_helper.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

class ProductScreen extends StatefulWidget {
  ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<Products> products = [];
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController nameDialogController;
  late TextEditingController priceDialogController;
  late DatabaseHelper dbHelper = DatabaseHelper.init();
  double listSize = 0;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    if (Platform.isIOS) {
      listSize = media.orientation == Orientation.portrait ? 435 : 160;
    }

    if (Platform.isAndroid) {
      listSize = media.orientation == Orientation.portrait ? 600 : 160;
    }

    if (media.orientation == Orientation.portrait) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Productos'),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(
                        width: 130,
                        child: TextField(
                          controller: nameController,
                          decoration: InputDecoration(label: Text('Nombre')),
                        ),
                      ),
                      SizedBox(
                        width: 130,
                        child: TextField(
                          controller: priceController,
                          decoration: InputDecoration(label: Text('Precio')),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(10)),
                          child: const Icon(
                            Icons.add,
                            size: 25,
                          ),
                          onPressed: () {
                            /*double price = priceController.text == ''
                                ? 0.0
                                : double.parse(priceController.text);*/
                            insertProduct(nameController.text,
                                priceController.text, context);
                          },
                        ),
                      )
                    ],
                  ),
                ),
                listHandle(context)
              ],
            ),
          ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
      ),
      body: Row(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: SizedBox(
                    width: 130,
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(label: Text('Nombre')),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15, top: 15),
                  child: SizedBox(
                    width: 130,
                    child: TextField(
                      controller: priceController,
                      decoration: InputDecoration(label: Text('Precio')),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15, top: 25),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(10)),
                    child: const Icon(
                      Icons.add,
                      size: 25,
                    ),
                    onPressed: () {
                      /*double price = priceController.text == ''
                          ? 0.0
                          : double.parse(priceController.text);*/
                      insertProduct(
                          nameController.text, priceController.text, context);
                    },
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: 40,
          ),
          listHandLandscape(context)
        ],
      ),
    );
  }

  Widget listHandLandscape(BuildContext context) {
    if (products.length == 0) {
      return Padding(
          padding: EdgeInsets.only(top: 100, left: 25),
          child: Center(
            child: Text('Sin Productos'),
          ));
    }
    return Expanded(
      child: ListView.builder(
          itemCount: products.length,
          //shrinkWrap: true,
          itemBuilder: (context, index) {
            Products prod = products[index];
            return Card(
              elevation: 15.0,
              margin: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.blueGrey, width: 3),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      prod.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 17),
                    child: Row(
                      children: <Widget>[
                        Text('Precio: '),
                        Text(prod.price.toString())
                      ],
                    ),
                  ),
                  ButtonBar(
                    children: [
                      TextButton(
                        child: Icon(Icons.edit),
                        onPressed: () {
                          editProduct(context, prod.id);
                        },
                      ),
                      TextButton(
                        child: Icon(Icons.delete),
                        onPressed: () {
                          deleteProduct(context, prod.id);
                        },
                      )
                    ],
                  )
                ],
              ),
            );
          }),
    );
  }

  Widget listHandle(BuildContext context) {
    if (products.length == 0) {
      return Padding(
          padding: EdgeInsets.only(top: 100, left: 25),
          child: Center(
            child: Text('Sin Productos'),
          ));
    }

    return Padding(
        padding: EdgeInsets.only(top: 20),
        child: Row(
          children: <Widget>[
            Expanded(
                child: SizedBox(
              height: listSize,
              child: Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: products.length,
                  itemBuilder: (BuildContext contex, int index) {
                    final prod = products[index];
                    //return Text(prod.name);
                    return Card(
                      elevation: 15.0,
                      margin: EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.blueGrey, width: 3),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              prod.name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 17),
                            child: Row(
                              children: <Widget>[
                                Text('Precio: '),
                                Text(prod.price.toString())
                              ],
                            ),
                          ),
                          ButtonBar(
                            children: [
                              TextButton(
                                child: Icon(Icons.edit),
                                onPressed: () {
                                  editProduct(context, prod.id);
                                },
                              ),
                              TextButton(
                                child: Icon(Icons.delete),
                                onPressed: () {
                                  deleteProduct(context, prod.id);
                                },
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ))
          ],
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController();
    priceController = TextEditingController();
    nameDialogController = TextEditingController();
    priceDialogController = TextEditingController();
    all();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    priceController.dispose();
    nameDialogController.dispose();
    priceDialogController.dispose();
    dbHelper.closeDB();
  }

  void insertProduct(String name, String price, BuildContext context) {
    if (name == '' || price == '') {
      final snackbar = SnackBar(content: Text('Campo vacio no permitido'));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } else {
      final Future<Database> dbFuture = dbHelper.initDB();
      dbFuture.then((database) {
        Products aux = Products(name, double.parse(price));

        Future<int> map = dbHelper.add('products', aux);
        map.then((value) {
          nameController.clear();
          priceController.clear();
          final snackbar =
              SnackBar(content: Text('Adicionado Satisfactoriamente!!'));
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
          all();
        });
      });
    }
  }

  void all() {
    Future<List<Map<String, dynamic>>> allProducts = dbHelper.all('products');
    allProducts.then((value) {
      List<Products> auxProducts = [];
      for (var i = 0; i < value.length; i++) {
        auxProducts.add(Products.fromMapObject(value[i]));
      }
      setState(() {
        products = auxProducts;
      });
    });
  }

  Future<dynamic> editProduct(BuildContext context, int id) {
    Future<dynamic> product = dbHelper.find('products', 'id', id);
    product.then((value) {
      Products produ2 = Products.fromMapObject(value[0]);
      nameDialogController.text = produ2.getName();
      priceDialogController.text = produ2.getPrice().toString();
    });

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // title: Text('Editar Producto'),
            content: StatefulBuilder(
              builder: (context, setState) {
                final orientation = MediaQuery.of(context).orientation;
                return Container(
                  child: orientation == Orientation.portrait
                      ? SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              TextField(
                                controller: nameDialogController,
                                /*decoration:
                                    InputDecoration(label: Text('Nombre')),*/
                                keyboardType: TextInputType.text,
                              ),
                              TextField(
                                controller: priceDialogController,
                                /* decoration:
                                    InputDecoration(label: Text('Precio')),*/
                                keyboardType: TextInputType.number,
                              )
                            ],
                          ),
                        )
                      : Container(
                          width: 400,
                          height: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              SizedBox(
                                width: 170,
                                child: TextField(
                                  controller: nameDialogController,
                                  /*decoration:
                                      InputDecoration(label: Text('Nombre')),*/
                                  keyboardType: TextInputType.text,
                                ),
                              ),
                              SizedBox(
                                width: 170,
                                child: TextField(
                                  controller: priceDialogController,
                                  /*decoration:
                                      InputDecoration(label: Text('Precio')),*/
                                  keyboardType: TextInputType.number,
                                ),
                              )
                            ],
                          ),
                        ),
                );
              },
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Future<dynamic> auxProd =
                        dbHelper.find('products', 'id', id);
                    auxProd.then((value) {
                      Products prod2 = Products.fromMapObject(value[0]);
                      prod2.setName(nameDialogController.text);
                      prod2.setPrice(double.parse(priceDialogController.text));
                      Future<int> result = dbHelper.update('products', prod2);
                      result.then((value) {
                        setState(() {
                          Navigator.pop(context);
                        });
                        final snackbar = SnackBar(
                            content: Text('Actualizado Satisfactoriamente!!'));
                        ScaffoldMessenger.of(context).showSnackBar(snackbar);
                      });
                    });
                  },
                  child: Text('Aceptar')),
              TextButton(
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                  child: Text('Cerrar'))
            ],
          );
        }).then((value) {
      all();
    });
  }

  Future<dynamic> deleteProduct(BuildContext context, int id) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            //title: Text('Eliminar Producto'),
            content: SingleChildScrollView(
              child: Center(
                child: Text('Esta seguro de eliminar este producto?'),
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Future<dynamic> auxProd = dbHelper.delete('products', id);
                    auxProd.then((value) {
                      setState(() {
                        Navigator.pop(context);
                      });
                      final snackbar = SnackBar(
                          content: Text('Eliminado Satisfactoriamente!!'));
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    });
                  },
                  child: Text('Aceptar')),
              TextButton(
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                  child: Text('Cerrar'))
            ],
          );
        }).then((value) {
      all();
    });
  }
}
