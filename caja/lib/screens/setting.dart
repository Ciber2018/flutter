import 'package:caja/models/buses.dart';
import 'package:caja/models/setting_model.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:caja/helpers/database_helper.dart';

class Setting extends StatefulWidget {
  Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  String busPlacehorlder = 'Nueva Guagua';
  late TextEditingController busesController;
  late TextEditingController chickenIvuController;
  late TextEditingController ivuController;
  late List<SettingModel> settings;
  DatabaseHelper dbHelper = DatabaseHelper.init();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                      width: 150,
                      child: TextField(
                        decoration: InputDecoration(
                            label: Text(busPlacehorlder),
                            border: OutlineInputBorder()),
                        controller: busesController,
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: ElevatedButton(
                        onPressed: () {
                          insertBuses(busesController.text, context);
                        },
                        child: Text('Insertar')),
                  )
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Productos'),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/products_screen');
                      },
                      child: Text('Ver')),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                      width: 150,
                      child: TextField(
                        decoration: InputDecoration(
                            label: Text('Pollo IVU'),
                            border: OutlineInputBorder()),
                        controller: chickenIvuController,
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: ElevatedButton(
                        onPressed: () {
                          if (chickenIvuController.text == '') {
                            final snackbar = SnackBar(
                                content: Text('Valor vacio no permitido'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackbar);
                          } else {
                            SettingModel model = settings.firstWhere(
                                (element) =>
                                    element.getName() == 'chicken_ivu');
                            model.setValue(
                                double.parse(chickenIvuController.text));
                            Future<int> result =
                                dbHelper.update('setting', model);
                            result.then((value) {
                              final snackbar =
                                  SnackBar(content: Text('Valor actualizado'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackbar);
                              updateSettings();
                            });
                          }
                        },
                        child: Text('Editar')),
                  )
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                      width: 150,
                      child: TextField(
                        decoration: InputDecoration(
                            label: Text('IVU'), border: OutlineInputBorder()),
                        controller: ivuController,
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: ElevatedButton(
                        onPressed: () {
                          if (ivuController.text == '') {
                            final snackbar = SnackBar(
                                content: Text('Valor vacio no permitido'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackbar);
                          } else {
                            SettingModel model = settings.firstWhere(
                                (element) => element.getName() == 'ivu');
                            model.setValue(double.parse(ivuController.text));
                            Future<int> result =
                                dbHelper.update('setting', model);
                            result.then((value) {
                              final snackbar =
                                  SnackBar(content: Text('Valor actualizado'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackbar);
                              updateSettings();
                            });
                          }
                        },
                        child: Text('Editar')),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    busesController = TextEditingController();
    chickenIvuController = TextEditingController();
    ivuController = TextEditingController();
    updateSettings();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    busesController.dispose();
    chickenIvuController.dispose();
    ivuController.dispose();
  }

  String getChickenIvuValue(List<SettingModel> sett) {
    SettingModel set =
        sett.firstWhere((element) => element.name == 'chicken_ivu');

    return set.getValue().toString();
  }

  String getIvuValue(List<SettingModel> sett) {
    SettingModel set = sett.firstWhere((element) => element.name == 'ivu');
    int ivu = set.getValue().toInt();
    return ivu.toString();
  }

  void insertBuses(String location, BuildContext context) {
    if (location == '') {
      final snackbar = SnackBar(content: Text('Campo vacio no permitido'));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } else {
      final Future<Database> dbFuture = dbHelper.initDB();
      dbFuture.then((database) {
        Buses aux = Buses(location);
        Future<int> map = dbHelper.add('buses', aux);
        map.then((value) {
          busesController.clear();
          final snackbar =
              SnackBar(content: Text('Adicionada Satisfactoriamente!!'));
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
          print(value);
        });
      });
    }
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
      chickenIvuController.text = getChickenIvuValue(settings);
      ivuController.text = getIvuValue(settings);
    });
  }
}
