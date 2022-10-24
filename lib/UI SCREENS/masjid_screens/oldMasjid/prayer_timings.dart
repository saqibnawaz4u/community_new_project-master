
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../models/masjid.dart';

class HorizontalExample extends StatefulWidget {
  HorizontalExample({Key? key}) : super(key: key);

  @override
  _HorizontalExample createState() => _HorizontalExample();
}

class _HorizontalExample extends State<HorizontalExample> {
  List<String> _list = ["Apple", "Ball", "Cat", "Dog", "Elephant"];
  List<Masjid> masjids = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ReorderableListView(
        children: masjids.map((index) =>
            ListTile(key: Key(masjids[4].capacity.toString()), title: Text("${4}"),
            subtitle: Text(masjids[4].Isha.toString()),
            )).toList(),
        onReorder: (int start, int current) {
          // dragging from top to bottom
          if (start < current) {
            int end = current - 1;
            String startItem = masjids[start].toString();
            int i = 0;
            int local = start;
            do {
              masjids[local] = masjids[++local];
              i++;
            } while (i < end - start);
            masjids[end] = startItem as Masjid;
          }
          // dragging from bottom to top
          else if (start > current) {
            String startItem = _list[start];
            for (int i = start; i > current; i--) {
              masjids[i] = masjids[i - 1];
            }
            masjids[current] = startItem as Masjid;
          }
          setState(() {});
        },
      
      ),
    );
  }

}