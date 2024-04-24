// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/presentation/screens/search/search/search_screen_bloc.dart';
import 'package:vocab_app/presentation/screens/search/search/search_screen_event.dart';
import 'package:vocab_app/presentation/widgets/others/search_field_widget.dart';
import 'package:vocab_app/utils/translate.dart';

class SearchingBar extends StatefulWidget {
  final TextEditingController searchController;

  const SearchingBar({super.key, required this.searchController});
  @override
  _SearchingBarState createState() => _SearchingBarState();
}

class _SearchingBarState extends State<SearchingBar> {
  @override
  void initState() {
    super.initState();

    widget.searchController.addListener(() {
      final keyword = widget.searchController.text;
      BlocProvider.of<SearchBloc>(context).add(KeywordChanged(keyword));
    });
  }

  void onClearSearchField() {
    if (widget.searchController.text.isNotEmpty) {
      widget.searchController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.defaultSize * 0.5,
        horizontal: SizeConfig.defaultSize,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 1,
            spreadRadius: 1,
            color: COLOR_CONST.cardShadowColor.withOpacity(0.2),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          IconButton(
            icon:
                const Icon(Icons.arrow_back_ios, color: COLOR_CONST.textColor),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: SearchFieldWidget(
              searchController: widget.searchController,
              hintText:
                  Translate.of(context).translate("search_by_product_name"),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.cancel_outlined),
            onPressed: onClearSearchField,
          ),
        ],
      ),
    );
  }
}