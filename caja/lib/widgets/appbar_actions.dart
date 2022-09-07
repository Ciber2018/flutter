import 'package:caja/models/extra.dart';
import 'package:flutter/material.dart';
import 'package:caja/models/diet.dart';
import 'dart:async';
import 'package:caja/helpers/database_helper.dart';
import 'package:caja/helpers/global_service.dart';

class AppBarActions extends StatefulWidget {
  AppBarActions({Key? key}) : super(key: key);

  @override
  State<AppBarActions> createState() => _AppBarActionsState();
}

class _AppBarActionsState extends State<AppBarActions> {
  DatabaseHelper dbHelper = DatabaseHelper.init();
  late TextEditingController dietName;
  late TextEditingController dietAmount;
  late TextEditingController extraDescription;
  String nameLabel = 'Nombre';
  String amountLabel = 'Cantidad';
  String descriptionLabel = 'Descripcion';
  GlobalService global = GlobalService();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        // add icon, by default "3 dot" icon
        icon: Icon(Icons.more_vert),
        itemBuilder: (context) {
          return [
            PopupMenuItem<int>(
              value: 0,
              child: Text("Dieta"),
            ),
            PopupMenuItem<int>(
              value: 1,
              child: Text("Extras"),
            ),
          ];
        },
        onSelected: (value) {
          if (value == 0) {
            addDietModal(context);
          } else {
            addExtraModal(context);
          }
        });
  }

  Future<dynamic> addDietModal(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            //title: Center(child: ,) Text('Agregar Producto'),
            content: StatefulBuilder(
              builder: ((context, setState) {
                final orientation = MediaQuery.of(context).orientation;

                return Container(
                  child: orientation == Orientation.portrait
                      ? SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: <Widget>[
                              TextField(
                                controller: dietName,
                                decoration: InputDecoration(
                                    label: Text(this.nameLabel)),
                                keyboardType: TextInputType.text,
                                onChanged: (value) {
                                  if (value != '') {
                                    setState(() {
                                      nameLabel = '';
                                    });
                                  } else {
                                    setState(() {
                                      nameLabel = 'Nombre';
                                    });
                                  }
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextField(
                                controller: dietAmount,
                                decoration: InputDecoration(
                                    label: Text(this.amountLabel)),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  if (value != '') {
                                    setState(() {
                                      amountLabel = '';
                                    });
                                  } else {
                                    setState(() {
                                      amountLabel = 'Cantidad';
                                    });
                                  }
                                },
                              )
                            ],
                          ),
                        )
                      : Container(
                          // width: 400,
                          //height: 100,
                          //scrollDirection: Axis.horizontal,
                          child: Container(
                          width: 400,
                          height: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              SizedBox(
                                width: 170,
                                child: TextField(
                                  controller: dietName,
                                  decoration: InputDecoration(
                                      label: dietName.text != ''
                                          ? Text('')
                                          : Text(this.nameLabel)),
                                  keyboardType: TextInputType.text,
                                  onChanged: (value) {
                                    if (value != '') {
                                      setState(() {
                                        nameLabel = '';
                                      });
                                    } else {
                                      setState(() {
                                        nameLabel = 'Nombre';
                                      });
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 170,
                                child: TextField(
                                  controller: dietAmount,
                                  decoration: InputDecoration(
                                      label: dietAmount.text != ''
                                          ? Text('')
                                          : Text(this.amountLabel)),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    if (value != '') {
                                      setState(() {
                                        amountLabel = '';
                                      });
                                    } else {
                                      setState(() {
                                        amountLabel = 'Cantidad';
                                      });
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        )),
                );
              }),
            ),
            actions: [
              Container(
                  height: 35,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                          onPressed: () {
                            if (global.getBus() == -1) {
                              final snackbar =
                                  SnackBar(content: Text('Escoja una guagua'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackbar);
                            } else if (dietName.text == '' ||
                                dietAmount.text == '') {
                              final snackbar = SnackBar(
                                  content:
                                      Text('Campos no pueden estar vacios'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackbar);
                            } else {
                              Future<dynamic> result =
                                  dbHelper.find('diet', 'bus', global.getBus());
                              result.then((value) {
                                if (value.length == 0) {
                                  String diet =
                                      '${dietName.text}-${dietAmount.text}';
                                  Diet model = Diet(global.getBus(), diet);
                                  Future<int> result =
                                      dbHelper.add('diet', model);
                                  result.then((value) {
                                    dietName.clear();
                                    dietAmount.clear();
                                    setState(() {
                                      nameLabel = 'Nombre';
                                      amountLabel = 'Cantidad';
                                    });
                                    final snackbar = SnackBar(
                                        content: Text('Dieta Agregada'));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackbar);
                                  });
                                } else {
                                  Diet aux = Diet.fromMapObject(value[0]);
                                  print(aux.getDiet());
                                  String newDiet =
                                      '${dietName.text}-${dietAmount.text}';
                                  String diet = '${aux.getDiet()},${newDiet}';
                                  aux.setDiet(diet);
                                  Future<int> updateResult =
                                      dbHelper.update('diet', aux);
                                  updateResult.then((value) {
                                    dietName.clear();
                                    dietAmount.clear();
                                    setState(() {
                                      nameLabel = 'Nombre';
                                      amountLabel = 'Cantidad';
                                    });
                                    final snackbar = SnackBar(
                                        content: Text('Dieta Agregada'));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackbar);
                                  });
                                }
                              });
                            }
                          },
                          child: Text('Aceptar')),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            dietName.clear();
                            dietAmount.clear();
                            setState(() {
                              nameLabel = 'Nombre';
                              amountLabel = 'Cantidad';
                            });
                          },
                          child: Text('Cancelar')),
                    ],
                  ))
            ],
          );
        }).then((value) {
      //widget.valuesFromActionbar(diets, extras);
    });
  }

  Future<dynamic> addExtraModal(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            //title: Center(child: ,) Text('Agregar Producto'),
            content: StatefulBuilder(
              builder: ((context, setState) {
                final orientation = MediaQuery.of(context).orientation;
                return Container(
                  child: orientation == Orientation.portrait
                      ? SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: <Widget>[
                              TextField(
                                controller: extraDescription,
                                decoration: InputDecoration(
                                    label: extraDescription.text != ''
                                        ? Text('')
                                        : Text(this.descriptionLabel)),
                                keyboardType: TextInputType.text,
                                onChanged: (value) {
                                  if (value != '') {
                                    setState(() {
                                      descriptionLabel = '';
                                    });
                                  } else {
                                    setState(() {
                                      descriptionLabel = 'Descripcion';
                                    });
                                  }
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextField(
                                controller: dietAmount,
                                decoration: InputDecoration(
                                    label: dietAmount.text != ''
                                        ? Text('')
                                        : Text(this.amountLabel)),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  if (value != '') {
                                    setState(() {
                                      amountLabel = '';
                                    });
                                  } else {
                                    setState(() {
                                      amountLabel = 'Cantidad';
                                    });
                                  }
                                },
                              )
                            ],
                          ),
                        )
                      : Container(
                          child: Container(
                          width: 400,
                          height: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              SizedBox(
                                width: 170,
                                child: TextField(
                                  controller: extraDescription,
                                  decoration: InputDecoration(
                                      label: extraDescription.text != ''
                                          ? Text('')
                                          : Text(this.descriptionLabel)),
                                  keyboardType: TextInputType.text,
                                  onChanged: (value) {
                                    if (value != '') {
                                      setState(() {
                                        descriptionLabel = '';
                                      });
                                    } else {
                                      setState(() {
                                        descriptionLabel = 'Descripcion';
                                      });
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 170,
                                child: TextField(
                                  controller: dietAmount,
                                  decoration: InputDecoration(
                                      label: dietAmount.text != ''
                                          ? Text('')
                                          : Text(this.amountLabel)),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    if (value != '') {
                                      setState(() {
                                        amountLabel = '';
                                      });
                                    } else {
                                      setState(() {
                                        amountLabel = 'Cantidad';
                                      });
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        )),
                );
              }),
            ),
            actions: [
              Container(
                  height: 35,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                          onPressed: () {
                            if (global.getBus() == -1) {
                              final snackbar =
                                  SnackBar(content: Text('Escoja una guagua'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackbar);
                            } else if (extraDescription.text == '' ||
                                dietAmount.text == '') {
                              final snackbar = SnackBar(
                                  content:
                                      Text('Campos no pueden estar vacios'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackbar);
                            } else {
                              Future<dynamic> result = dbHelper.find(
                                  'extra', 'bus', global.getBus());
                              result.then((value) {
                                if (value.length == 0) {
                                  String extra =
                                      '${extraDescription.text}-${dietAmount.text}';
                                  Extra model = Extra(extra, global.getBus());
                                  Future<int> result =
                                      dbHelper.add('extra', model);
                                  result.then((value) {
                                    extraDescription.clear();
                                    dietAmount.clear();
                                    setState(() {
                                      descriptionLabel = 'Descripcion';
                                      amountLabel = 'Cantidad';
                                    });
                                    final snackbar = SnackBar(
                                        content: Text('Extra Agregado'));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackbar);
                                  });
                                } else {
                                  Extra aux = Extra.fromMapObject(value[0]);
                                  print(aux.getExtra());
                                  String newExtra =
                                      '${extraDescription.text}-${dietAmount.text}';
                                  String extra =
                                      '${aux.getExtra()},${newExtra}';
                                  aux.setExtra(extra);
                                  Future<int> updateResult =
                                      dbHelper.update('extra', aux);
                                  updateResult.then((value) {
                                    extraDescription.clear();
                                    dietAmount.clear();
                                    setState(() {
                                      descriptionLabel = 'Descripcion';
                                      amountLabel = 'Cantidad';
                                    });
                                    final snackbar = SnackBar(
                                        content: Text('Extra Agregado'));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackbar);
                                  });
                                }
                              });
                            }
                          },
                          child: Text('Aceptar')),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            extraDescription.clear();
                            dietAmount.clear();
                            setState(() {
                              descriptionLabel = 'Descripcion';
                              amountLabel = 'Cantidad';
                            });
                          },
                          child: Text('Cancelar')),
                    ],
                  ))
            ],
          );
        }).then((value) {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dietName = TextEditingController();
    dietAmount = TextEditingController();
    extraDescription = TextEditingController();
  }
}
