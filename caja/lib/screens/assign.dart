import 'package:caja/helpers/database_helper.dart';
import 'package:caja/models/products.dart';
import 'package:flutter/material.dart';
import 'package:caja/models/buses.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:caja/widgets/simple.dart';
import 'package:caja/models/asign.dart';
import 'dart:io';

class Assign extends StatefulWidget {
  Assign({Key? key}) : super(key: key);

  @override
  State<Assign> createState() => _AssignState();
}

class _AssignState extends State<Assign> {
  DatabaseHelper dbHelper = DatabaseHelper.init();
  List<Buses> buses = [];

  List<String> asignList = [];
  List<Products> allProducts = [];
  List<Widget> widgetList = [];
  double listSize = 0;
  bool clearText = false;
  var dropdownGuaguas;

  late List<String> letter;
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    if (Platform.isIOS) {
      listSize = media.orientation == Orientation.portrait ? 435 : 160;
    }

    if (Platform.isAndroid) {
      listSize = media.orientation == Orientation.portrait ? 600 : 160;
    }

    return Scaffold(
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.green,
            onPressed: () {
              if (dropdownGuaguas == null) {
                final snackbar =
                    SnackBar(content: Text('Escoja una guagua para asignar'));
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              } else {
                Future<bool> exist =
                    dbHelper.exist('asign', 'bus', dropdownGuaguas);
                exist.then(
                  (value) {
                    asignList = parseEmptyList(asignList);
                    if (value) {
                      Future<dynamic> asignation =
                          dbHelper.find('asign', 'bus', dropdownGuaguas);
                      asignation.then((value) {
                        Asign auxAsign = Asign.fromMapObject(value[0]);
                        auxAsign.setAsign(asignList.join(','));
                        dbHelper.update('asign', auxAsign);
                      });
                    } else {
                      dbHelper.add('asign',
                          new Asign(dropdownGuaguas, asignList.join(',')));
                    }
                    final snackbar =
                        SnackBar(content: Text('Asignacion terminada!!'));
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  },
                );
                //print(asignList.join(','));
                setState(() {
                  clearText = true;
                });
              }
            },
            child: Icon(Icons.add)),
        body: OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.landscape) {
              return Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      SizedBox(
                        height: 35,
                      ),
                      Container(
                          child: Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: DropdownButton<int>(
                          hint: buses.length == 0
                              ? Text('Sin guaguas')
                              : Text('Escoja la guagua'),
                          value: dropdownGuaguas,
                          //icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          onChanged: (newValue) {
                            //print(newValue);
                            setState(() {
                              dropdownGuaguas = newValue;
                            });
                          },
                          items: buses.map<DropdownMenuItem<int>>((Buses val) {
                            return DropdownMenuItem<int>(
                              child: Text(val.getLocation()),
                              value: val.getId(),
                            );
                          }).toList(),
                        ),
                      )),
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: ListView.builder(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          itemCount: allProducts.length,
                          itemBuilder: (context, index) {
                            return Simple(
                                data: letter,
                                id: allProducts[index].getId(),
                                name: allProducts[index].getName(),
                                empty: clearText,
                                isChanged: (value, id) {
                                  setState(() {
                                    clearText = false;
                                  });

                                  if (dropdownGuaguas == null) {
                                    setState(() {
                                      clearText = true;
                                    });
                                    final snackbar = SnackBar(
                                        content:
                                            Text('Primero escoja una guagua'));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackbar);
                                  } else {
                                    double val =
                                        value == '' ? 0 : double.parse(value);
                                    if (asignList.length > 0) {
                                      bool exist = false;
                                      for (var i = 0;
                                          i < asignList.length;
                                          i++) {
                                        List<String> splitted =
                                            asignList[i].split('-');
                                        if (int.parse(splitted[0]) == id) {
                                          splitted[1] = val.toString();
                                          asignList[i] = splitted.join('-');
                                          exist = true;
                                        }
                                      }
                                      if (!exist) {
                                        String asign = '${id}-${val}';
                                        setState(() {
                                          asignList = [...asignList, asign];
                                          letter = asignList;
                                        });
                                      }
                                    } else {
                                      String asign = '${id}-${val}';
                                      setState(() {
                                        asignList = [...asignList, asign];
                                        letter = asignList;
                                      });
                                    }
                                  }
                                });
                          })),
                ],
              );
            }
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      child: Center(
                          child: DropdownButton<int>(
                    hint: buses.length == 0
                        ? Text('Sin guaguas')
                        : Text('Escoja la guagua'),
                    value: dropdownGuaguas,
                    //icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    onChanged: (newValue) {
                      //print(newValue);
                      setState(() {
                        dropdownGuaguas = newValue;
                        //print(newValue);
                      });
                    },
                    items: buses.map<DropdownMenuItem<int>>((Buses val) {
                      return DropdownMenuItem<int>(
                        child: Text(val.getLocation()),
                        value: val.getId(),
                      );
                    }).toList(),
                  ))),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: listSize,
                    child: ListView.builder(
                        //shrinkWrap: true,
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        itemCount: allProducts.length,
                        itemBuilder: (context, index) {
                          return Simple(
                              data: letter,
                              id: allProducts[index].getId(),
                              name: allProducts[index].getName(),
                              empty: clearText,
                              isChanged: (value, id) {
                                setState(() {
                                  clearText = false;
                                });

                                if (dropdownGuaguas == null) {
                                  setState(() {
                                    clearText = true;
                                  });
                                  final snackbar = SnackBar(
                                      content:
                                          Text('Primero escoja una guagua'));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackbar);
                                } else {
                                  double val =
                                      value == '' ? 0 : double.parse(value);
                                  if (asignList.length > 0) {
                                    bool exist = false;
                                    for (var i = 0; i < asignList.length; i++) {
                                      List<String> splitted =
                                          asignList[i].split('-');
                                      if (int.parse(splitted[0]) == id) {
                                        splitted[1] = val.toString();
                                        asignList[i] = splitted.join('-');
                                        exist = true;
                                      }
                                    }
                                    if (!exist) {
                                      String asign = '${id}-${val}';
                                      setState(() {
                                        asignList = [...asignList, asign];
                                        letter = asignList;
                                      });
                                    }
                                  } else {
                                    String asign = '${id}-${val}';
                                    setState(() {
                                      asignList = [...asignList, asign];
                                      letter = asignList;
                                    });
                                  }
                                }
                              });
                        }),
                  )
                ],
              ),
            );
          },
        ));
  }

  void updateProducts() {
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
  }

  void updateBusesDropDown() {
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
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    letter = [];
    updateBusesDropDown();
    updateProducts();
  }

  List<String> parseEmptyList(List<String> list) {
    List<String> ids = [];
    if (list.length == 0) {
      allProducts.forEach((element) {
        list.add('${element.getId()}-0.0');
      });
      return list;
    }
    list.forEach((element) {
      List<String> splited = element.split('-');
      ids.add(splited[0]);
    });
    print(ids);
    allProducts.forEach((element) {
      if (!ids.contains(element.getId().toString())) {
        list.add('${element.getId()}-0.0');
      }
    });
    return list;
  }
}
