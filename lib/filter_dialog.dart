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

  Widget _buildSwitchListTile(String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }

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
              _buildSwitchListTile('마트', _showMarts, (value) {
                setState(() {
                  _showMarts = value;
                });
              }),
              _buildSwitchListTile('편의점', _showConvenienceStores, (value) {
                setState(() {
                  _showConvenienceStores = value;
                });
              }),
              _buildSwitchListTile('화장실', _showRestrooms, (value) {
                setState(() {
                  _showRestrooms = value;
                });
              }),
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

