import 'package:flutter/cupertino.dart';

import '../common/custom_state_group.dart';
import '../common/utilities.dart';

/// CustomStateGroup to manage custom selection grouped
///
/// [isMultipleSelection] : (bool) enable multiple selection  in grouped checkbox (default:false).
///
/// [initSelectedItem] : (List) A Initialize list of values that will be selected in group.
class CustomGroupController {
  late CustomStateGroup _customStateGroup;

  final List<dynamic> initSelectedItem;
  final bool isMultipleSelection;
  final List<CustomListener> _listeners = [];
  final int? maxSelections;
  final int minSelections;
  ValueNotifier<String?> errorValue = ValueNotifier(null);

  dynamic get selectedItem => _customStateGroup.selection();

  CustomGroupController({
    this.isMultipleSelection = false,
    dynamic initSelectedItem,
    this.maxSelections,
    this.minSelections = 0,
  })  : assert(!(initSelectedItem is List), "shouldn't be a List"),
        this.initSelectedItem =
            initSelectedItem != null ? [initSelectedItem] : [];

  CustomGroupController.multiple({
    this.initSelectedItem = const [],
    this.maxSelections,
    this.minSelections = 0,
  }) : this.isMultipleSelection = true;

  void init(CustomStateGroup stateGroup) {
    this._customStateGroup = stateGroup;
    _listeners.forEach((element) {
      _addListener(element);
    });
  }

  /// add listener : to get  data changed directly
  void listen(void Function(dynamic) listener) {
    try {
      _addListener(listener);
    } catch (e) {
      _listeners.add(listener);
    }
  }

  void _addListener(CustomListener element) {
    if (!isMultipleSelection) {
      _customStateGroup.selectedListen(element);
    } else {
      _customStateGroup.selectionsListen(element);
    }
  }

  /// enabledItems : to make items enabled
  ///
  /// [items] : (list) list of items that will be enabled
  void enabledItems(List<dynamic> items) =>
      _customStateGroup.enabledItemsByValues(items);

  /// enabledItems : to disabled specific  items by they values
  ///
  /// [items] : (list) list of items that will be disabled
  void disabledItems(List<dynamic> items) =>
      _customStateGroup.disabledItemsByValues(items);


  void clearSelection(){
    _customStateGroup.reset();
  }
}
