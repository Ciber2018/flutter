import 'package:caja/models/diet.dart';
import 'package:caja/models/extra.dart';
import 'package:caja/screens/assigreport.dart';
import 'package:caja/screens/box.dart';
import 'package:caja/screens/delivery.dart';
import 'package:caja/screens/setting.dart';
import 'package:flutter/material.dart';
import 'package:caja/widgets/myheaderdrawer.dart';
import 'package:caja/widgets/appbar_actions.dart';
import 'package:caja/screens/assign.dart';
import 'package:multilevel_drawer/multilevel_drawer.dart';
import 'package:caja/helpers/global_service.dart';
import 'package:caja/helpers/database_helper.dart';
import 'dart:async';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var currentPage;
  bool assignSelected = false;
  bool settingSelected = false;
  String appBarText = 'Sistema';
  DatabaseHelper dbHelper = DatabaseHelper.init();
  Widget drawerBody = Container(
    child: Center(
      child: Text('inicial'),
    ),
  );

  GlobalService global = GlobalService();

  @override
  Widget build(BuildContext context) {
    /*switch (currentPage) {
      case 'Assign':
        drawerBody = Assign();
        setState(() {
          appBarText = 'Asignar';
        });
        break;
      case 'Setting':
        drawerBody = Setting();
        setState(() {
          appBarText = 'Configuracion';
        });
        break;
      case 'Entrega':
        drawerBody = Delivery();
        setState(() {
          appBarText = 'Entrega';
        });
        break;
      case 'AssignReport':
        drawerBody = AssignReport();
        setState(() {
          appBarText = 'Reporte Asignados';
        });
        break;
      case 'Box':
        drawerBody = Box();
        setState(() {
          appBarText = 'Caja';
        });
        break;
      default:
        break;
    }*/
    return Scaffold(
        appBar: AppBar(
          title: Text(this.appBarText),
          actions: appBarText != 'Entrega' ? [] : [AppBarActions()],
        ),
        body: Container(
          child: drawerBody,
        ),
        drawer: MultiLevelDrawer(header: MyHeaderDrawer(), children: [
          MLMenuItem(
            leading: Image(image: AssetImage('assets/img/add_icon.png')),
            content: Text("  Asignar"),
            onClick: () {
              setState(() {
                appBarText = 'Asignar';
                drawerBody = Assign();
              });
              Navigator.pop(context);
            },
          ),
          MLMenuItem(
            leading: Image(image: AssetImage('assets/img/bus_icon.png')),
            content: Text("  Entrega"),
            onClick: () {
              setState(() {
                appBarText = 'Entrega';
                drawerBody = Delivery();
                global.reset();
              });
              Navigator.pop(context);
            },
          ),
          MLMenuItem(
              leading: Image(
                  image: AssetImage(
                      'assets/img/report_icon.png')), //Icon(Icons.summarize),
              trailing: Icon(Icons.arrow_right),
              content: Text(
                "  Reportes",
              ),
              subMenuItems: [
                MLSubmenu(
                    onClick: () {
                      setState(() {
                        appBarText = 'Reporte Asignaciones';
                        drawerBody = AssignReport();
                      });
                      Navigator.pop(context);
                    },
                    submenuContent: Text("Asignaciones")),
              ],
              onClick: () {}),
          MLMenuItem(
            leading: Image(
                image: AssetImage(
                    'assets/img/inventory_icon.png')), //Icon(Icons.inventory),
            content: Text("  Caja"),
            onClick: () {
              setState(() {
                appBarText = 'Caja';
                drawerBody = Box();
              });
              Navigator.pop(context);
            },
          ),
          MLMenuItem(
            leading: Image(image: AssetImage('assets/img/setting_icon.png')),
            content: Text("  Configuracion"),
            onClick: () {
              setState(() {
                appBarText = 'Configuracion';
                drawerBody = Setting();
              });
              Navigator.pop(context);
            },
          )
        ])

        /*Drawer(
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  MyHeaderDrawer(),
                  Container(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          menuItem(1, 'Asignar', Icon(Icons.add),
                              currentPage == 'Assign' ? true : false),
                          menuItem(2, 'Entrega', Icon(Icons.directions_bus),
                              currentPage == 'Entrega' ? true : false),
                          menuItem(
                              3,
                              'Reporte de Asignaciones',
                              Icon(Icons.summarize),
                              currentPage == 'AssignReport' ? true : false),
                          menuItem(4, 'Cuadre de Caja', Icon(Icons.inventory),
                              currentPage == 'Box' ? true : false),
                          Divider(),
                          menuItem(5, 'Configuracion', Icon(Icons.settings),
                              currentPage == 'Setting' ? true : false),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )*/
        );
  }

  Widget menuItem(int id, String text, Icon icon, bool selected) {
    return Material(
        color: selected ? Colors.grey[300] : Colors.transparent,
        child: Padding(
          padding: EdgeInsets.only(top: 15),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
              setState(() {
                switch (id) {
                  case 1:
                    currentPage = 'Assign';
                    break;
                  case 2:
                    currentPage = 'Entrega';
                    break;
                  case 3:
                    currentPage = 'AssignReport';
                    break;
                  case 4:
                    currentPage = 'Box';
                    break;
                  case 5:
                    currentPage = 'Setting';
                    break;
                  default:
                    break;
                }
              });
            },
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  /*Expanded(child: icon),
                  Expanded(
                      child: Text(
                    text,
                  ))*/
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: icon,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 25),
                    child: Text(text),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper.initDB();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    dbHelper.closeDB();
  }
}
