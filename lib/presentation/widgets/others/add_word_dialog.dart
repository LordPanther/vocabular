// import 'dart:async';
// import 'dart:ui';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:vocab_app/configs/router.dart';
// import 'package:vocab_app/configs/size_config.dart';
// import 'package:vocab_app/constants/color_constant.dart';
// import 'package:vocab_app/constants/font_constant.dart';
// import 'package:vocab_app/data/models/collections_model.dart';
// import 'package:vocab_app/data/models/daily_word_model.dart';
// import 'package:vocab_app/data/repository/app_repository.dart';
// import 'package:vocab_app/data/repository/collections_repository/collections_repo.dart';
// import 'package:vocab_app/presentation/widgets/buttons/record_button.dart';
// import 'package:vocab_app/presentation/widgets/others/dropdown_list.dart';
// import 'package:vocab_app/utils/snackbar.dart';
// import 'package:vocab_app/utils/translate.dart';

// class AddWordDialog extends StatefulWidget {
//   const AddWordDialog({super.key});

//   @override
//   State<AddWordDialog> createState() => _AddWordDialogState();
// }

// class _AddWordDialogState extends State<AddWordDialog> {
//   CollectionsRepository collectionsRepository =
//       AppRepository.collectionsRepository;
//   late List<String> dropdownCollection;
//   final TextEditingController word = TextEditingController();
//   final TextEditingController definition = TextEditingController();
//   String? collection;
//   bool isChecked = false;
//   double _progress = 0.0;
//   bool _isLoading = false;
//   late Timer _timer;

//   @override
//   void initState() {
//     dropdownCollection = [];
//     fetchCollections();
//     super.initState();
//   }

//   void _startLoading() {
//     _isLoading = true;
//     _progress = 0.0;
//     const duration = Duration(minutes: 1); // Set duration to one minute
//     const steps = 60; // 60 steps for one minute

//     _timer = Timer.periodic(
//       duration ~/ steps, // Calculate the interval for each step
//       (timer) {
//         setState(
//           () {
//             _progress += 1 / steps; // Increment progress by a small fraction
//             if (_progress >= 1.0) {
//               _stopLoading();
//             }
//           },
//         );
//       },
//     );
//   }

//   void _stopLoading() {
//     _timer.cancel();
//     _isLoading = false;
//     _progress = 0.0;
//   }

//   Future<void> fetchCollections() async {
//     var collectionData = await collectionsRepository.fetchCollections();
//     List<CollectionModel> passedCollections = collectionData.collections;

//     setState(() {
//       dropdownCollection =
//           passedCollections.map((collection) => collection.name).toList();
//     });
//   }

//   bool get isWordPopulated => word.text.isNotEmpty;
//   bool get isDefinitionPopulated => definition.text.isNotEmpty;

//   void onAddWord() async {
//     if (isWordPopulated && isDefinitionPopulated && collection != null) {
//       var newWord = WordModel(
//         id: collection!,
//         definition: definition.text,
//         word: word.text,
//       );
//       var newCollection = CollectionModel(name: collection!);
//       await collectionsRepository.addNewWord(newCollection, newWord, isChecked);
//       Navigator.of(context).popAndPushNamed(AppRouter.HOME);
//     } else {
//       if (!isWordPopulated) {
//         UtilSnackBar.showSnackBarContent(context,
//             content: "Please add a word first...");
//       }
//       if (!isDefinitionPopulated) {
//         UtilSnackBar.showSnackBarContent(context,
//             content: "Please add a definition first...");
//       }
//       if (collection == null) {
//         UtilSnackBar.showSnackBarContent(context,
//             content: "Please select a collection...");
//       }
//     }
//   }

//   void record() {
//     setState(() {
//       _isLoading = !_isLoading; // Toggle _isLoading state
//       _isLoading
//           ? _startLoading()
//           : _stopLoading(); // Start or stop loading accordingly
//     });
//   }

//   @override
//   void dispose() {
//     word.dispose();
//     definition.dispose();
//     if (_timer.isActive) _timer.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       backgroundColor: Colors.white70.withOpacity(0.8),
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(5))),
//       content: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             _buildHeaderText("Add new word..."),
//             SizedBox(height: SizeConfig.defaultSize * 5),
//             _buildTextFieldWord(),
//             SizedBox(height: SizeConfig.defaultSize * 3),
//             _buildTextFieldDefinition(),
//             SizedBox(height: SizeConfig.defaultSize * 0.7),
//             _recordingIndicator(),
//             SizedBox(height: SizeConfig.defaultSize * 3),
//             _buildCollectionDropdown(),
//             SizedBox(height: SizeConfig.defaultSize * 3),
//             _buildCheckbox(),
//             SizedBox(height: SizeConfig.defaultSize * 5),
//             _buildButtonProcessAction(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeaderText(String userOption) {
//     return Center(
//       child: Text(
//         userOption,
//         style: FONT_CONST.BOLD_DEFAULT_18,
//       ),
//     );
//   }

//   Widget _buildTextFieldWord() {
//     return TextFormField(
//       style: TextStyle(
//         color: COLOR_CONST.textColor,
//         fontSize: SizeConfig.defaultSize * 1.6,
//       ),
//       cursorColor: COLOR_CONST.textColor,
//       textInputAction: TextInputAction.next,
//       controller: word,
//       autovalidateMode: AutovalidateMode.always,
//       keyboardType: TextInputType.text,
//       decoration: InputDecoration(
//         labelText: Translate.of(context).translate('add_word'),
//         labelStyle: const TextStyle(color: COLOR_CONST.textColor),
//         focusedBorder: const OutlineInputBorder(
//           borderSide: BorderSide(
//             color: COLOR_CONST.textColor,
//           ),
//         ),
//         enabledBorder: const OutlineInputBorder(
//           borderSide: BorderSide(color: COLOR_CONST.textColor),
//         ),
//       ),
//     );
//   }

//   Widget _buildCollectionDropdown() {
//     if (dropdownCollection.isEmpty) {
//       return const CircularProgressIndicator(); // Show loading indicator
//     } else {
//       return DropdownSelectionList(
//         items: dropdownCollection,
//         onItemSelected: (String? selectedItem) {
//           setState(() {
//             collection = selectedItem;
//           });
//         },
//       );
//     }
//   }

//   Widget _buildTextFieldDefinition() {
//     return Stack(
//       children: [
//         TextFormField(
//           style: TextStyle(
//             color: COLOR_CONST.textColor,
//             fontSize: SizeConfig.defaultSize * 1.6,
//           ),
//           maxLines: 4,
//           cursorColor: COLOR_CONST.textColor,
//           textInputAction: TextInputAction.next,
//           controller: definition,
//           autovalidateMode: AutovalidateMode.always,
//           keyboardType: TextInputType.multiline,
//           decoration: InputDecoration(
//             labelText: Translate.of(context).translate('add_definition'),
//             labelStyle: const TextStyle(color: COLOR_CONST.textColor),
//             focusedBorder: const OutlineInputBorder(
//               borderSide: BorderSide(color: COLOR_CONST.textColor),
//             ),
//             enabledBorder: const OutlineInputBorder(
//               borderSide: BorderSide(color: COLOR_CONST.textColor),
//             ),
//           ),
//         ),
//         Positioned(
//           bottom: 5,
//           right: 5,
//           child: RecordButton(
//             isRecording: _isLoading,
//             onTap: record,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _recordingIndicator() {
//     if (_isLoading) {
//       return LinearProgressIndicator(
//         value: _progress,
//         backgroundColor: COLOR_CONST.backgroundColor,
//         valueColor:
//             const AlwaysStoppedAnimation<Color>(COLOR_CONST.primaryColor),
//       );
//     } else {
//       return const SizedBox(); // Return an empty widget when not recording
//     }
//   }

//   Widget _buildCheckbox() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Checkbox(
//           value: isChecked,
//           onChanged: (bool? value) {
//             setState(() {
//               isChecked = value!;
//             });
//           },
//         ),
//         const SizedBox(width: 10),
//         const Expanded(
//           child: Text(
//             "Share this word with other users for free?",
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildButtonProcessAction() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         IconButton(
//           onPressed: () =>
//               Navigator.of(context).popAndPushNamed(AppRouter.HOME),
//           icon: const Icon(CupertinoIcons.arrow_left),
//         ),
//         IconButton(
//           onPressed: onAddWord,
//           icon: const Icon(CupertinoIcons.arrow_right),
//         ),
//       ],
//     );
//   }
// }
