
import 'dart:collection';

import 'package:flutter/cupertino.dart';

import '../models/event.dart';

class SearchEvents extends ChangeNotifier {
  final List<Event> _myEvents = [];

  String _searchString = "";

  UnmodifiableListView<Event> get events => _searchString.isEmpty
      ? UnmodifiableListView(_myEvents)
      : UnmodifiableListView(
      _myEvents.where((event) => event.name!.contains(_searchString)));

  void changeSearchString(String searchString) {
    _searchString = searchString;
    print(_searchString);
    notifyListeners();
  }
}