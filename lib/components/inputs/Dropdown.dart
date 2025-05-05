import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:medibound_ui/components/theme.dart';
import 'package:medibound_ui/components/utils/Info.dart';
import 'package:medibound_ui/medibound_ui.dart';

class MBDropdown extends StatefulWidget {
  final List<MBInfo> items;
  final MBInfo? selectedItem;
  final Function(MBInfo?) onChanged;
  final String? hintText;
  final bool showSearchBox;
  final bool isEnabled;

  const MBDropdown({
    Key? key,
    required this.items,
    this.selectedItem,
    required this.onChanged,
    this.hintText,
    this.showSearchBox = true,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  State<MBDropdown> createState() => _MBDropdownState();
}

class _MBDropdownState extends State<MBDropdown> {
  MBInfo? _currentSelectedItem;

  @override
  void initState() {
    super.initState();
    _validateSelection();
    if (_currentSelectedItem != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onChanged(_currentSelectedItem);
      });
    }
  }

  @override
  void didUpdateWidget(MBDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Check if the items list changed
    if (oldWidget.items != widget.items) {
      _validateSelection();
    }
    
    // Check if the selected item changed
    if (oldWidget.selectedItem != widget.selectedItem) {
      _currentSelectedItem = widget.selectedItem;
      _validateSelection();
    }
  }

  void _validateSelection() {
    if (widget.selectedItem == null) {
      _currentSelectedItem = null;
      return;
    }
    
    // Check if selected item exists in the items list
    bool itemExists = widget.items.any((item) => item.code == widget.selectedItem!.code);
    
    if (!itemExists) {
      // If selected item doesn't exist in the list, clear selection and notify
      _currentSelectedItem = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onChanged(null);
      });
    } else {
      _currentSelectedItem = widget.selectedItem;
    }
  }

  Color _getBackgroundColor(MBInfo item, BuildContext context) {
    final baseColor = item.color ?? FlutterFlowTheme.of(context).secondary;
    return baseColor.withOpacity(0.1);
  }

  Color _getIconColor(MBInfo item, BuildContext context) {
    return item.color ?? FlutterFlowTheme.of(context).secondary;
  }

  
  Widget _buildItemRow(MBInfo item, BuildContext context) {

    return Row(
      children: [
        if ((item.icon != null && item.icon != "") || item.color != null) ...[
          Container(
            width: 30,
            height: 30,
            decoration: item.icon != null && item.icon != "" ? BoxDecoration(
              color: _getBackgroundColor(item, context),
              borderRadius: BorderRadius.circular(5),
            ) : BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(5),
            ),
            child: item.icon != null && item.icon != ""
                ? Icon(
                    iconsMap[item.icon] ?? Icons.question_mark,
                    color: _getIconColor(item, context),
                  )
                : Center(
                    child: Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        color: _getIconColor(item, context),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item.display,
                style: FlutterFlowTheme.of(context).bodyMedium.copyWith(height: 1.1, fontWeight: FontWeight.w600),
              ),
              Text(
                item.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: FlutterFlowTheme.of(context).labelSmall.copyWith(height: 1),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownSearch<MBInfo>(
        items: widget.items,
        selectedItem: _currentSelectedItem,
        onChanged: widget.onChanged,
        enabled: widget.isEnabled,
        filterFn: (item, filter) => 
          item.display.toLowerCase().contains(filter.toLowerCase()),
        popupProps: PopupProps.menu(
          showSearchBox: widget.showSearchBox,
          fit: FlexFit.loose,
          constraints: const BoxConstraints(maxHeight: 400),
          showSelectedItems: false,
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              hintText: "Search...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: FlutterFlowTheme.of(context).alternate,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            ),
          ),
          menuProps: MenuProps(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(10),
          ),
          containerBuilder: (context, popupWidget) {
            return AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: 1.0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Material(
                    color: Colors.transparent,
                    child: popupWidget,
                  ),
                ),
              ),
            );
          },
          itemBuilder: (context, item, isSelected) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: _buildItemRow(item, context),
            );
          },
        ),
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            hintText: widget.hintText ?? "Select an option",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: FlutterFlowTheme.of(context).alternate,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            suffixIcon: const Icon(Icons.expand_more),
          ),
        ),
        dropdownBuilder: (context, item) {
          if (item == null) {
            return Text(
              widget.hintText ?? "Select an option",
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            );
          }
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: _buildItemRow(item, context),
          );
        },
      ),
    );
  }
} 