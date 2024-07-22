import 'package:flutter/material.dart';

/// 필터링 다이얼로그를 표시하기 위한 위젯
class FilterDialog extends StatefulWidget {
  final bool showMarts;
  final bool showConvenienceStores;
  final bool showGasStations;
  final Function(bool, bool, bool) onFilterChanged;

  FilterDialog({
    required this.showMarts,
    required this.showConvenienceStores,
    required this.showGasStations,
    required this.onFilterChanged,
  });

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late bool _showMarts;
  late bool _showConvenienceStores;
  late bool _showGasStations;

  @override
  void initState() {
    super.initState();
    _showMarts = widget.showMarts;
    _showConvenienceStores = widget.showConvenienceStores;
    _showGasStations = widget.showGasStations;
  }

  /// 스위치 리스트 타일을 생성하기 위한 메서드
  Widget _buildSwitchListTile(
      String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('필터링'),
      content: Column(
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
          _buildSwitchListTile('주유소', _showGasStations, (value) {
            setState(() {
              _showGasStations = value;
            });
          }),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.onFilterChanged(
                _showMarts, _showConvenienceStores, _showGasStations);
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
