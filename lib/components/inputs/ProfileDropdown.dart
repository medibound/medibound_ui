import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:medibound_ui/components/theme.dart';
import 'package:medibound_ui/components/utils/Profile.dart';

class MbProfileDropdown extends StatefulWidget {
  final List<MBProfile> items;
  final MBProfile? selectedItem;
  final Function(MBProfile?) onChanged;
  final String? hintText;
  final bool showSearchBox;
  final bool isEnabled;
  final bool circle;

  const MbProfileDropdown({
    Key? key,
    required this.items,
    this.selectedItem,
    required this.onChanged,
    this.hintText,
    this.showSearchBox = true,
    this.isEnabled = true,
    this.circle = false,
  }) : super(key: key);

  @override
  State<MbProfileDropdown> createState() => _MbProfileDropdownState();
}

class _MbProfileDropdownState extends State<MbProfileDropdown> {
  MBProfile? _currentSelectedItem;

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
  void didUpdateWidget(MbProfileDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Check if the items list changed (length or content)
    bool itemsChanged = oldWidget.items.length != widget.items.length;
    
    if (!itemsChanged && oldWidget.selectedItem != null) {
      // If lengths match but selected item was removed, we still need to check
      itemsChanged = !widget.items.any((item) => item.uid == oldWidget.selectedItem!.uid);
    }
    
    if (itemsChanged) {
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
    bool itemExists = widget.items.any((item) => item.uid == widget.selectedItem!.uid);
    
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

  Widget _buildProfileImage(MBProfile profile) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.circle ? 15 : 5),
        image: DecorationImage(
          image: NetworkImage(profile.photoUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildItemRow(MBProfile profile, BuildContext context) {
    return Row(
      children: [
        _buildProfileImage(profile),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                profile.display,
                style: FlutterFlowTheme.of(context).bodyMedium.copyWith(height: 1.1, fontWeight: FontWeight.w600),
              ),
              Text(
                profile.description,
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
    // Validate selection every time the widget builds
    _validateSelection();
    
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownSearch<MBProfile>(
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
            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // Handle item selection (built-in in the dropdown_search)
                },
                hoverColor: FlutterFlowTheme.of(context).primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? FlutterFlowTheme.of(context).primary.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: _buildItemRow(item, context),
                ),
              ),
            );
          },
        ),
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            hintText: widget.hintText ?? "Select a profile",
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
              widget.hintText ?? "Select a profile",
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