import 'package:flutter/material.dart';
import 'package:caja/models/products.dart';
import 'dart:async';
import 'package:caja/helpers/database_helper.dart';
import 'package:caja/models/asign.dart';
import 'package:caja/models/buses.dart';
import 'dart:io';

class AssignReport extends StatefulWidget {
  AssignReport({Key? key}) : super(key: key);

  @override
  State<AssignReport> createState() => _AssignReportState();
}

class _AssignReportState extends State<AssignReport> {
  DatabaseHelper dbHelper = DatabaseHelper.init();

  Asign asignation = Asign.empty();
  List<Buses> allBuses = [];
  var busIndex;
  var productIndex;
  double listSize = 0;
  bool isEmpty = false;
  List<Products> products = [];

  late TextEditingController amountController;
  late TextEditingController newAmountController;
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    if (Platform.isIOS) {
      listSize = media.orientation == Orientation.portrait ? 435 : 280;
    }

    if (Platform.isAndroid) {
      listSize = media.orientation == Orientation.portrait ? 600 : 260;
    }

    if (media.orientation == Orientation.portrait) {
      return SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                DropdownButton<int>(
                  hint: allBuses.length == 0
                      ? Text('Sin guaguas')
                      : Text('Escoja la guagua'),
                  value: busIndex,
                  //icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  onChanged: (newValue) {
                    setState(() {
                      busIndex = newValue;
                    });
                    if (newValue != null) {
                      updateAsigns(newValue);
                    }
                  },
                  items: allBuses.map<DropdownMenuItem<int>>((Buses val) {
                    return DropdownMenuItem<int>(
                      child: Text(val.getLocation()),
                      value: val.getId(),
                    );
                  }).toList(),
                ),
                /*ElevatedButton(
                  onPressed: () {
                    if (busIndex == null) {
                      final snackbar =
                          SnackBar(content: Text('Escoja una guagua'));
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    } else {
                      addProductModal(context);
                    }
                  },
                  child: Icon(Icons.add),
                ),*/
                ElevatedButton(
                  onPressed: () {
                    if (busIndex == null) {
                      final snackbar =
                          SnackBar(content: Text('Escoja una guagua'));
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    } else {
                      Future<bool> exist =
                          dbHelper.exist('asign', 'bus', busIndex);
                      exist.then((value) {
                        if (value) {
                          deleteAsignModal(context, busIndex);
                        } else {
                          final snackbar = SnackBar(
                              content:
                                  Text('No tiene asignaciones para eliminar'));
                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
                        }
                      });
                    }
                  },
                  child: Icon(Icons.delete),
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                )
              ],
            ),
          ),
          listAsigns(context, isEmpty, asignation)
        ],
      ));
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          /*SingleChildScrollView(
            child:*/
          Column(
            children: <Widget>[
              SizedBox(
                height: 12,
              ),
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    DropdownButton<int>(
                      hint: allBuses.length == 0
                          ? Text('Sin guaguas')
                          : Text('Escoja la guagua'),
                      value: busIndex,
                      elevation: 16,
                      onChanged: (newValue) {
                        setState(() {
                          busIndex = newValue;
                        });
                        if (newValue != null) {
                          updateAsigns(newValue);
                        }
                      },
                      items: allBuses.map<DropdownMenuItem<int>>((Buses val) {
                        return DropdownMenuItem<int>(
                          child: Text(val.getLocation()),
                          value: val.getId(),
                        );
                      }).toList(),
                    ),
                    /*ElevatedButton(
                      onPressed: () {
                        if (busIndex == null) {
                          final snackbar =
                              SnackBar(content: Text('Escoja una guagua'));
                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
                        } else {
                          addProductModal(context);
                        }
                      },
                      child: Icon(Icons.add),
                    ),*/
                    ElevatedButton(
                      onPressed: () {
                        if (busIndex == null) {
                          final snackbar =
                              SnackBar(content: Text('Escoja una guagua'));
                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
                        } else {
                          Future<bool> exist =
                              dbHelper.exist('asign', 'bus', busIndex);
                          exist.then((value) {
                            if (value) {
                              deleteAsignModal(context, busIndex);
                            } else {
                              final snackbar = SnackBar(
                                  content: Text(
                                      'No tiene asignaciones para eliminar'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackbar);
                            }
                          });
                        }
                      },
                      child: Icon(Icons.delete),
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                    )
                  ],
                ),
              ),
            ],
          ),
          // ),
          SizedBox(
            width: 350,
            child: listAsigns(context, isEmpty, asignation),
          )
        ],
      ),
    );
  }

  void updateAsigns(int bus) {
    Future<bool> asignExist = dbHelper.exist('asign', 'bus', bus);
    asignExist.then((value) {
      if (value) {
        Future<dynamic> asign = dbHelper.find('asign', 'bus', bus);
        asign.then((value) {
          asignation = Asign.fromMapObject(value[0]);
          setState(() {
            isEmpty = false;
          });
        });
      } else {
        setState(() {
          isEmpty = true;
        });
      }
    });
  }

  void updateBuses() {
    Future<List<Map<String, dynamic>>> busesList = dbHelper.all('buses');
    busesList.then((value) {
      if (value.length > 0) {
        List<Buses> auxList = [];
        for (var i = 0; i < value.length; i++) {
          Buses bus = Buses.fromMapObject(value[i]);
          auxList.add(bus);
        }
        setState(() {
          allBuses = auxList;
        });
      }
    });
  }

  void updateProducts() {
    Future<List<Map<String, dynamic>>> all = dbHelper.all('products');
    all.then((value) {
      List<Products> aux = [];
      for (var i = 0; i < value.length; i++) {
        aux = [...aux, Products.fromMapObject(value[i])];
      }
      setState(() {
        products = aux;
      });
    });
  }

  String getProductName(int productId) {
    Products prod =
        products.firstWhere((element) => element.getId() == productId);
    return prod.getName();
  }

  Future<dynamic> addProductModal(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            //title: Text('Agregar Producto'),
            content: StatefulBuilder(
              builder: ((context, setState) {
                final orientation = MediaQuery.of(context).orientation;
                return Container(
                    child: orientation == Orientation.portrait
                        ? SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: <Widget>[
                                DropdownButton<int>(
                                  hint: products.length == 0
                                      ? Text('Sin productos')
                                      : Text('Escoja un producto'),
                                  value: productIndex,
                                  //icon: const Icon(Icons.arrow_downward),
                                  elevation: 16,
                                  onChanged: (newValue) {
                                    setState(() {
                                      productIndex = newValue;
                                    });
                                  },
                                  items: products.map<DropdownMenuItem<int>>(
                                      (Products val) {
                                    return DropdownMenuItem<int>(
                                      child: Text(val.getName()),
                                      value: val.getId(),
                                    );
                                  }).toList(),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 170,
                                      child: TextField(
                                        controller: amountController,
                                        decoration: InputDecoration(
                                            label: Text('Cantidad')),
                                        keyboardType: TextInputType.number,
                                      ),
                                    )
                                  ],
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
                                DropdownButton<int>(
                                  hint: products.length == 0
                                      ? Text('Sin productos')
                                      : Text('Escoja un producto'),
                                  value: productIndex,
                                  //icon: const Icon(Icons.arrow_downward),
                                  elevation: 16,
                                  onChanged: (newValue) {
                                    setState(() {
                                      productIndex = newValue;
                                    });
                                  },
                                  items: products.map<DropdownMenuItem<int>>(
                                      (Products val) {
                                    return DropdownMenuItem<int>(
                                      child: Text(val.getName()),
                                      value: val.getId(),
                                    );
                                  }).toList(),
                                ),
                                SizedBox(
                                  width: 170,
                                  child: TextField(
                                    controller: amountController,
                                    decoration: InputDecoration(
                                        label: Text('Cantidad')),
                                    keyboardType: TextInputType.number,
                                  ),
                                )
                              ],
                            ),
                          ));
              }),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Future<bool> asignExist =
                        dbHelper.exist('asign', 'bus', busIndex);
                    asignExist.then((value) {
                      if (value) {
                        Future<dynamic> aux =
                            dbHelper.find('asign', 'bus', busIndex);
                        aux.then((value) {
                          String newAsign =
                              '${productIndex}-${amountController.text}';
                          Asign asg = Asign.fromMapObject(value[0]);
                          asg.setAsign('${asg.getAsign()},${newAsign}');
                          Future<int> result = dbHelper.update('asign', asg);
                          result.then((value) {
                            //Navigator.pop(context);
                            amountController.clear();
                            setState(() {
                              productIndex = null;
                            });
                            final snackbar =
                                SnackBar(content: Text('Producto Agregado!!'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackbar);
                          });
                        });
                      } else {
                        String newAsign =
                            '${productIndex}-${amountController.text}';
                        Asign asg = new Asign(busIndex, newAsign);

                        Future<int> result = dbHelper.add('asign', asg);
                        result.then((value) {
                          //Navigator.pop(context);
                          amountController.clear();
                          final snackbar =
                              SnackBar(content: Text('Producto Agregado!!'));
                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
                        });
                      }
                    });
                  },
                  child: Text('Aceptar')),
              TextButton(
                  onPressed: () {
                    amountController.clear();
                    Navigator.pop(context);
                    setState(() {
                      productIndex = null;
                    });
                  },
                  child: Text('Cerrar'))
            ],
          );
        }).then((value) {
      updateAsigns(busIndex);
    });
  }

  Future<dynamic> deleteAsignModal(BuildContext context, int bus) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SingleChildScrollView(
                child: Container(
              child: Center(
                child: Text('Desea borrar esta asignacion?'),
              ),
            )),
            actions: [
              TextButton(
                  onPressed: () {
                    Future<dynamic> currentAsign =
                        dbHelper.find('asign', 'bus', bus);
                    currentAsign.then((value) {
                      Asign aux = Asign.fromMapObject(value[0]);
                      Future<int> result =
                          dbHelper.delete('asign', aux.getId());
                      result.then((value) {
                        Navigator.pop(context);
                        final snackbar =
                            SnackBar(content: Text('Asignacion Eliminada'));
                        ScaffoldMessenger.of(context).showSnackBar(snackbar);
                      });
                    });
                  },
                  child: Text('Si')),
              TextButton(
                  onPressed: () {
                    amountController.clear();
                    Navigator.pop(context);
                    setState(() {
                      productIndex = null;
                    });
                  },
                  child: Text('No'))
            ],
          );
        }).then((value) {
      updateAsigns(busIndex);
    });
  }

  Widget listAsigns(BuildContext context, bool empty, Asign asg) {
    if (busIndex != null) {
      if (empty) {
        return Padding(
            padding: MediaQuery.of(context).orientation == Orientation.portrait
                ? EdgeInsets.only(top: 100)
                : EdgeInsets.only(top: 20),
            child: Center(
              child: Text('No tiene asignaciones'),
            ));
      }

      List<String> list = asg.getAsign().split(',');
      String name;
      return Padding(
          padding: MediaQuery.of(context).orientation == Orientation.portrait
              ? EdgeInsets.only(top: 50)
              : EdgeInsets.only(top: 10),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: SizedBox(
                height: listSize,
                child: Container(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: list.length,
                    itemBuilder: (BuildContext contex, int index) {
                      final asignItem = list[index];
                      List<String> asignItemArray = asignItem.split('-');
                      name = getProductName(int.parse(asignItemArray[0]));
                      return Card(
                        elevation: 15.0,
                        margin: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.blueGrey, width: 3),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                name,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 17),
                              child: Row(
                                children: <Widget>[
                                  //Text(asignItem),
                                  Text('Cantidad: ${asignItemArray[1]}')
                                ],
                              ),
                            ),
                            ButtonBar(
                              children: [
                                TextButton(
                                  child: Text('Adicionar'),
                                  onPressed: () {
                                    editAsignationProduct(asignItemArray[0],
                                        index, list, asg, '+');
                                  },
                                ),
                                TextButton(
                                  child: Text('Quitar'),
                                  onPressed: () {
                                    editAsignationProduct(asignItemArray[0],
                                        index, list, asg, '-');
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
    return SizedBox();
  }

  Future<dynamic> editAsignationProduct(String prodId, int position,
      List<String> paramList, Asign model, String operationType) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // title: Text('Editar Cantidad'),
            content: SingleChildScrollView(
              child: Center(
                child: SizedBox(
                  width: 170,
                  child: TextField(
                    decoration: InputDecoration(label: Text('Nueva Cantidad')),
                    controller: newAmountController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    List<String> asg = paramList[position].split('-');
                    double newAmount = operationType == '+'
                        ? double.parse(asg[1]) +
                            double.parse(newAmountController.text)
                        : double.parse(asg[1]) -
                            double.parse(newAmountController.text);

                    paramList[position] =
                        '${prodId}-${newAmount > 0 ? newAmount : 0}';
                    model.setAsign(paramList.join(','));
                    Future<int> result = dbHelper.update('asign', model);
                    result.then((value) {
                      Navigator.pop(context);
                      newAmountController.clear();
                      final snackbar =
                          SnackBar(content: Text('Actualizacion Terminada!!'));
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    });
                  },
                  child: Text('Aceptar')),
              TextButton(
                  onPressed: () {
                    newAmountController.clear();
                    Navigator.pop(context);
                  },
                  child: Text('Cerrar'))
            ],
          );
        }).then((value) {
      updateAsigns(busIndex);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    amountController = new TextEditingController();
    newAmountController = new TextEditingController();
    updateBuses();
    updateProducts();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    amountController.dispose();
    newAmountController.dispose();
  }
}
