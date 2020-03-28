import 'package:checkbox_grouped/src/item.dart';
import 'package:flutter/material.dart';

class CustomGroupedCheckbox<T> extends StatefulWidget {
  final String groupTitle;
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final double itemExtent;
  final List<T> values;
  final bool isMultipleSelection;

  CustomGroupedCheckbox({
    Key key,
    this.groupTitle,
    @required this.itemBuilder,
    @required this.itemCount,
    @required this.values,
    this.itemExtent = 50.0,
    this.isMultipleSelection = false,
  })  : assert(itemCount > 0),
        super(key: key);

  @override
  CustomGroupedCheckboxState createState() => CustomGroupedCheckboxState();

  static CustomGroupedCheckboxState of<T>(BuildContext context,
      {bool nullOk = false}) {
    assert(context != null);
    assert(nullOk != null);
    final CustomGroupedCheckboxState<T> result =
        context.findAncestorStateOfType<CustomGroupedCheckboxState<T>>();
    if (nullOk || result != null) return result;
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
          'CustomGroupedCheckbox.of() called with a context that does not contain an CustomGroupedCheckbox.'),
      ErrorDescription(
          'No CustomGroupedCheckbox ancestor could be found starting from the context that was passed to CustomGroupedCheckbox.of().'),
      context.describeElement('The context used was')
    ]);
  }
}

class CustomGroupedCheckboxState<T> extends State<CustomGroupedCheckbox> {
  T _itemSelected;
  List<T> _itemsSelections;
  CustomItem<T> _previous;

  List<CustomItem<T>> _items;

  SliverChildBuilderDelegate childrenDelegate;

  @override
  void initState() {
    super.initState();
    _itemsSelections = [];
    _items = [];
    widget.values.forEach((v) {
      _items.add(CustomItem(data: v, checked: false, isDisabled: false));
    });
  }

  selection(){
    if(widget.isMultipleSelection){
      return _itemSelected;
    }
    return _itemSelected;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Text(widget.groupTitle),
        ),
        SliverFixedExtentList(
          delegate: SliverChildBuilderDelegate(
                (ctx, index) {
              return _ItemWidget(
                child:  widget.itemBuilder(ctx, index),
                value: _items[index].checked,
                callback: (v){
                  setState(() {
                    onChanged(index, v);
                  });
                },
              );
            },
            childCount: widget.itemCount,
          ),
          itemExtent: widget.itemExtent,
          //itemExtent: widget.itemExtent,
        ),
      ],
    );
  }

  void onChanged(int i, bool v) {
    if (widget.isMultipleSelection) {
      if (!_itemsSelections.contains(widget.values[i])) {
        if (v) {
          _itemsSelections.add(widget.values[i]);
        }
      } else {
        if (!v) {
          _itemsSelections.remove(widget.values[i]);
        }
      }
      _items[i].checked = v;
    } else {
      if (v) {
        _items[i].checked = v;
        if (_previous != _items[i]) {
          if (_previous != null) {
            _previous.checked = false;
          } else {
            _previous = _items[i];
          }
        }
        _itemSelected = widget.values[i];
        _previous = _items[i];
      }
    }
  }
}
class _ItemWidget extends StatelessWidget{

  final Widget child;
  final Function(bool) callback;
  final bool value;
  _ItemWidget({this.child,this.callback,this.value});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          bottom: 0,
          right: 0,
          left: 0,
          child: child,
        ),
        Positioned(
          top: 0,
          bottom: 0,
          right: 15,
          child: Checkbox(
            value: value,
            onChanged: (v) {
              print(v);
              callback(v);
            },
          ),
        ),
      ],
    );
  }

}