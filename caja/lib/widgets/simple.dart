import 'package:flutter/material.dart';
import 'package:caja/models/asign.dart';

class Simple extends StatefulWidget {
  int id;
  String name;
  List<String> data;
  bool empty;
  final Function(String, int) isChanged;

  Simple(
      {Key? key,
      required this.id,
      required this.name,
      required this.isChanged,
      required this.empty,
      required this.data})
      : super(key: key);

  @override
  State<Simple> createState() => _SimpleState();
}

class _SimpleState extends State<Simple> {
  late TextEditingController cont;
  late List<String> array;
  @override
  Widget build(BuildContext context) {
    if (widget.empty) {
      cont.clear();
    }

    return Padding(
        padding: EdgeInsets.only(top: 25),
        child: Row(
          key: ValueKey(widget.id),
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
                width:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? 260
                        : 260,
                child: TextField(
                  onChanged: (value) {
                    widget.isChanged(value, widget.id);
                  },
                  controller: cont,
                  decoration: InputDecoration(
                      label: Text(widget.name.toString()),
                      border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                )),
          ],
        ));
  }

  void updateAfterRotation(List<String> param) {
    List<String> aux = [];
    for (var i = 0; i < param.length; i++) {
      aux = param[i].split('-');
      if (int.parse(aux[0]) == widget.id) {
        cont.text = aux[1] == 0 ? '' : aux[1];
      }
    }
  }

  @override
  void initState() {
    super.initState();
    cont = new TextEditingController();
    updateAfterRotation(widget.data);
  }

  @override
  void dispose() {
    super.dispose();
    cont.dispose();
  }
}
