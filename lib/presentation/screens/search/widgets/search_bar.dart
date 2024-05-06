// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
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
  String _keyword = "";
  @override
  void initState() {
    super.initState();

    widget.searchController.addListener(() {
      setState(() {
        _keyword = widget.searchController.text;
      });
      BlocProvider.of<SearchBloc>(context).add(KeywordChanged(_keyword));
    });
  }

  void onClearSearchField() {
    if (_keyword.isNotEmpty) {
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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            // IconButton(
            //   icon: const Icon(Icons.arrow_back_ios,
            //       color: COLOR_CONST.textColor),
            //   onPressed: () => Navigator.pop(context),
            // ),
            Expanded(
              child: SearchFieldWidget(
                searchController: widget.searchController,
                hintText: Translate.of(context).translate("search"),
              ),
            ),
            if (_keyword.isNotEmpty)
              IconButton(
                icon: const Icon(CupertinoIcons.clear),
                onPressed: onClearSearchField,
              ),
          ],
        ),
      ),
    );
  }
}
