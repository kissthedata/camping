import 'package:flutter/material.dart';

class FilterDialog extends StatelessWidget {
  final bool showMarts;
  final bool showConvenienceStores;
  final bool showRestrooms;
  final Function(bool, bool, bool) onFilterChanged;

  FilterDialog({
    required this.showMarts,
    required this.showConvenienceStores,
    required this.showRestrooms,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    bool _showMarts = showMarts;
    bool _showConvenienceStores = showConvenienceStores;
    bool _showRestrooms = showRestrooms;

    return AlertDialog(
      title: Text('필터링'),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: Text('마트'),
                value: _showMarts,
                onChanged: (value) {
                  setState(() {
                    _showMarts = value;
                  });
                },
              ),
              SwitchListTile(
                title: Text('편의점'),
                value: _showConvenienceStores,
                onChanged: (value) {
                  setState(() {
                    _showConvenienceStores = value;
                  });
                },
              ),
              SwitchListTile(
                title: Text('화장실'),
                value: _showRestrooms,
                onChanged: (value) {
                  setState(() {
                    _showRestrooms = value;
                  });
                },
              ),
            ],
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            onFilterChanged(_showMarts, _showConvenienceStores, _showRestrooms);
            Navigator.pop(context);
          },
          child: Text('적용'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('취소'),
        ),
      ],
    );
  }
}
