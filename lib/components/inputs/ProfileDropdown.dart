import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:medibound_ui/components/theme.dart';
import 'package:medibound_ui/components/utils/Profile.dart';

class MbProfileDropdown extends StatelessWidget {
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

  Widget _buildProfileImage(MBProfile profile) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(circle ? 15 : 5),
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
                style: FlutterFlowTheme.of(context).bodyMedium.copyWith(height: 1.1, fontWeight: FontWeight.w500),
              ),
              Text(
                profile.description,
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
      height: 50,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownSearch<MBProfile>(
        items: items,
        selectedItem: selectedItem,
        onChanged: onChanged,
        enabled: isEnabled,
        filterFn: (item, filter) => 
          item.display.toLowerCase().contains(filter.toLowerCase()),
        popupProps: PopupProps.menu(
          showSearchBox: showSearchBox,
          fit: FlexFit.loose,
          constraints: const BoxConstraints(maxHeight: 400),
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
            return Container(
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: popupWidget,
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
            hintText: hintText ?? "Select a profile",
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
              hintText ?? "Select a profile",
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
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