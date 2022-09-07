import 'package:caja/models/asign.dart';
import 'package:caja/models/delivery_model.dart';
import 'package:caja/models/diet.dart';
import 'package:caja/models/extra.dart';
import 'package:caja/models/setting_model.dart';
import 'package:caja/screens/assign.dart';
import 'package:caja/screens/delivery.dart';
import 'package:flutter/material.dart';
import 'package:caja/helpers/database_helper.dart';
import 'dart:async';
import 'package:caja/models/buses.dart';
import 'package:caja/helpers/global_service.dart';
import 'package:flutter/rendering.dart';
import 'package:sqflite/sqflite.dart';
import 'package:caja/models/products.dart';

class Box extends StatefulWidget {
  Box({Key? key}) : super(key: key);

  @override
  State<Box> createState() => _BoxState();
}

class _BoxState extends State<Box> {
  DatabaseHelper dbHelper = DatabaseHelper.init();
  List<Buses> buses = [];
  List<Products> allProducts = [];

  var dropdownGuaguas;
  String total = '';

  List<String> assign = [];
  List<String> delivery = [];
  List<String> diets = [];
  List<String> extras = [];

  List<Asign> allAsigns = [];
  List<DeliveryModel> allDeliverys = [];

  late List<SettingModel> settings;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.landscape) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                        child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: DropdownButton<int>(
                        hint: buses.length == 0
                            ? Text('Sin guaguas')
                            : Text('Escoja la guagua'),
                        value: dropdownGuaguas,
                        //icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        onChanged: (newValue) {
                          setState(() {
                            dropdownGuaguas = newValue;
                          });
                          updateAssign(dropdownGuaguas);
                          updateDelivery(dropdownGuaguas);
                          updateDiets(dropdownGuaguas);
                          updateExtras(dropdownGuaguas);
                        },
                        items: buses.map<DropdownMenuItem<int>>((Buses val) {
                          return DropdownMenuItem<int>(
                            child: Text(val.getLocation()),
                            value: val.getId(),
                          );
                        }).toList(),
                      ),
                    ))
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Text(
                            'Asignacion',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        DataTable(
                            columns: createColumns(),
                            rows: createAssigRows(assign)),
                        SizedBox(
                          height: 40,
                        ),
                        Center(
                          child: Text(
                            'Entrega',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        DataTable(
                            columns: createColumns(),
                            rows: createDeliveryRows(delivery)),
                        SizedBox(
                          height: 40,
                        ),
                        Center(
                          child: Text(
                            'Dietas',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        DataTable(
                            columns: createDietColumns(),
                            rows: createDietRows()),
                        SizedBox(
                          height: 40,
                        ),
                        Text('Total: ${total}',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 5,
                ),
                SizedBox(
                    width: double.maxFinite,
                    child: Center(
                        child: DropdownButton<int>(
                      hint: buses.length == 0
                          ? Text('Sin guaguas')
                          : Text('Escoja la guagua'),
                      value: dropdownGuaguas,
                      //icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      onChanged: (newValue) {
                        setState(() {
                          dropdownGuaguas = newValue;
                        });
                        updateAssign(dropdownGuaguas);
                        updateDelivery(dropdownGuaguas);
                        updateDiets(dropdownGuaguas);
                        updateExtras(dropdownGuaguas);
                        calculate(dropdownGuaguas);
                      },
                      items: buses.map<DropdownMenuItem<int>>((Buses val) {
                        return DropdownMenuItem<int>(
                          child: Text(val.getLocation()),
                          value: val.getId(),
                        );
                      }).toList(),
                    ))),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: Text(
                    'Asignacion',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                DataTable(
                    columns: createColumns(), rows: createAssigRows(assign)),
                SizedBox(
                  height: 40,
                ),
                Center(
                  child: Text(
                    'Entrega',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                DataTable(
                    columns: createColumns(),
                    rows: createDeliveryRows(delivery)),
                SizedBox(
                  height: 40,
                ),
                Center(
                  child: Text(
                    'Dietas',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                DataTable(columns: createDietColumns(), rows: createDietRows()),
                SizedBox(
                  height: 40,
                ),
                Center(
                  child: Text(
                    'Extras',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                DataTable(
                    columns: createExtraColumns(), rows: createExtraRows()),
                SizedBox(
                  height: 40,
                ),
                Text('Total: ${total}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
              ],
            ),
          );
        },
      ),
    );
  }

  void updateAssign(int bus) {
    Future<dynamic> result = dbHelper.find('asign', 'bus', bus);
    result.then((value) {
      if (value.length > 0) {
        Asign auxAssign = Asign.fromMapObject(value[0]);
        setState(() {
          assign = auxAssign.getAsign().split(',');
        });
      } else {
        setState(() {
          assign = [];
        });
      }
    });
  }

  void updateDelivery(int bus) {
    Future<dynamic> result = dbHelper.find('delivery', 'bus', bus);
    result.then((value) {
      if (value.length > 0) {
        DeliveryModel auxDelivery = DeliveryModel.fromMapObject(value[0]);
        setState(() {
          delivery = auxDelivery.getDelivery().split(',');
        });
      } else {
        setState(() {
          delivery = [];
        });
      }
    });
  }

  void updateDiets(int bus) {
    Future<dynamic> result = dbHelper.find('diet', 'bus', bus);
    result.then((value) {
      if (value.length > 0) {
        Diet auxDiet = Diet.fromMapObject(value[0]);
        setState(() {
          diets = auxDiet.getDiet().split(',');
        });
      } else {
        setState(() {
          diets = [];
        });
      }
    });
  }

  void updateExtras(int bus) {
    Future<dynamic> result = dbHelper.find('extra', 'bus', bus);
    result.then((value) {
      if (value.length > 0) {
        Extra auxExta = Extra.fromMapObject(value[0]);
        setState(() {
          extras = auxExta.getExtra().split(',');
        });
      } else {
        setState(() {
          extras = [];
        });
      }
    });
  }

  void calculate(int bus) {
    double totalAmount = 0;
    Asign asign = allAsigns.length > 0
        ? allAsigns.firstWhere(
            (element) => element.getBus() == bus,
            orElse: () => Asign.empty(),
          )
        : Asign.empty();

    DeliveryModel deliveryModel = allDeliverys.length > 0
        ? allDeliverys.firstWhere(
            (element) => element.getBus() == bus,
            orElse: () => DeliveryModel.empty(),
          )
        : DeliveryModel.empty();

    if (asign.getAsign() == '' && deliveryModel.getDelivery() == '') {
      setState(() {
        this.total = '0';
      });
    } else {
      List<String> auxAsign = asign.getAsign().split(',');
      List<String> auxDelivery = deliveryModel.getDelivery().split(',');
      allProducts.forEach((element) {
        int id = element.getId();
        String asignation = auxAsign.firstWhere(
          (item) => checkMatch(item.split('-'), id),
          orElse: () => '',
        );
        String deliv = auxDelivery.firstWhere(
            (element) => checkMatch(element.split('-'), id),
            orElse: () => '');

        totalAmount += getValue(asignation.split('-'), deliv.split('-'));
        //getValue(asignation.split('-'), deliv.split('-'));
      });

      setState(() {
        total = totalAmount.toString();
      });
    }
  }

  bool checkMatch(List<String> item, int id) {
    return int.parse(item[0]) == id;
  }

  double getValue(List<String> item1, List<String> item2) {
    return double.parse(item1[1]) - double.parse(item2[1]);
  }

  List<DataColumn> createColumns() {
    return [
      DataColumn(label: Text('Producto')),
      DataColumn(label: Text('Cantidad')),
    ];
  }

  List<DataColumn> createDietColumns() {
    return [
      DataColumn(label: Text('Nombre')),
      DataColumn(label: Text('Cantidad')),
    ];
  }

  List<DataColumn> createExtraColumns() {
    return [
      DataColumn(label: Text('Descripcion')),
      DataColumn(label: Text('Cantidad')),
    ];
  }

  List<DataRow> createDietRows() {
    List<DataRow> rows = [];
    if (diets.length > 0) {
      for (var i = 0; i < diets.length; i++) {
        List<String> diet = diets[i].split('-');
        rows.add(DataRow(cells: [
          DataCell(Center(
            child: Text(diet[0]),
          )),
          DataCell(Center(
            child: Text(diet[1]),
          )),
        ]));
      }
      return rows;
    }
    return rows;
  }

  List<DataRow> createAssigRows(List<String> asign) {
    List<DataRow> rows = [];
    if (asign.length > 0) {
      for (var i = 0; i < asign.length; i++) {
        List<String> prod = asign[i].split('-');
        Products product = allProducts
            .firstWhere((element) => element.id == int.parse(prod[0]));
        // double total = double.parse(prod[1]) * product.getPrice();
        rows.add(DataRow(cells: [
          DataCell(Center(
            child: Text(
              product.getName(),
            ),
          )),
          DataCell(Center(
            child: Text(prod[1]),
          )),
          // DataCell(Text(total.toString()))
        ]));
      }
      return rows;
    }
    return rows;
  }

  List<DataRow> createExtraRows() {
    List<DataRow> rows = [];
    if (extras.length > 0) {
      for (var i = 0; i < extras.length; i++) {
        List<String> diet = extras[i].split('-');
        rows.add(DataRow(cells: [
          DataCell(Center(
            child: Text(diet[0]),
          )),
          DataCell(Center(
            child: Text(diet[1]),
          )),
        ]));
      }
      return rows;
    }
    return rows;
  }

  List<DataRow> createDeliveryRows(List<String> delivery) {
    List<DataRow> rows = [];
    if (delivery.length > 0) {
      for (var i = 0; i < delivery.length; i++) {
        List<String> prod = delivery[i].split('-');
        Products product = allProducts
            .firstWhere((element) => element.id == int.parse(prod[0]));
        // double total = double.parse(prod[1]) * product.getPrice();
        rows.add(DataRow(cells: [
          DataCell(Center(
            child: Text(product.getName()),
          )),
          DataCell(Center(
            child: Text(prod[1]),
          )),
          // DataCell(Text(total.toString()))
        ]));
      }
      return rows;
    }
    return rows;
  }

  void updateProducts() {
    final Future<Database> dbFuture = dbHelper.initDB();
    dbFuture.then((database) {
      Future<List<Map<String, dynamic>>> map = dbHelper.all('products');
      map.then((value) {
        List<Products> auxList = [];
        for (var i = 0; i < value.length; i++) {
          auxList.add(Products.fromMapObject(value[i]));
        }
        setState(() {
          allProducts = auxList;
        });
      });
    });
  }

  void updateBusesDropDown() {
    final Future<Database> dbFuture = dbHelper.initDB();
    dbFuture.then((database) {
      Future<List<Map<String, dynamic>>> map = dbHelper.all('buses');
      map.then((value) {
        List<Buses> auxBuses = [];
        for (var i = 0; i < value.length; i++) {
          auxBuses.add(Buses.fromMapObject(value[i]));
        }
        setState(() {
          buses = auxBuses;
        });
      });
    });
  }

  void updateSettings() {
    List<SettingModel> aux = [];
    Future<List<Map<String, dynamic>>> allSettings = dbHelper.all('setting');
    allSettings.then((value) {
      value.forEach((element) {
        aux.add(SettingModel.fromMapObject(element));
      });
      setState(() {
        settings = aux;
      });
    });
  }

  void updateAllAsigns() {
    List<Asign> aux = [];
    Future<List<Map<String, dynamic>>> result = dbHelper.all('asign');
    result.then((value) {
      if (value.length > 0) {
        value.forEach((element) {
          aux.add(Asign.fromMapObject(element));
        });
      }
      setState(() {
        allAsigns = aux;
      });
    });
  }

  void updateAllDeliverys() {
    List<DeliveryModel> aux = [];
    Future<List<Map<String, dynamic>>> result = dbHelper.all('delivery');
    result.then((value) {
      if (value.length > 0) {
        value.forEach((element) {
          aux.add(DeliveryModel.fromMapObject(element));
        });
      }
      setState(() {
        allDeliverys = aux;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateBusesDropDown();
    updateProducts();
    updateSettings();
    updateAllAsigns();
    updateAllDeliverys();
  }
}
