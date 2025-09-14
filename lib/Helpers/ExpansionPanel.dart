import 'package:flutter/material.dart';

class CustomExpansionPanel extends StatefulWidget {
  final IconData icon;
  final String title;
  final List<TableRow> rows;

  const CustomExpansionPanel({
    super.key,
    required this.icon,
    required this.title,
    required this.rows,
  });

  @override
  State<CustomExpansionPanel> createState() => _CustomExpansionPanelState();
}

class _CustomExpansionPanelState extends State<CustomExpansionPanel> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      children: [
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              leading: Icon(widget.icon, color: const Color(0xff1b3a6b)),
              title: Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
              },
              children: widget.rows,
            ),
          ),
          isExpanded: _isExpanded,
          canTapOnHeader: true,
        ),
      ],
    );
  }
}
