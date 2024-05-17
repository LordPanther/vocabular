// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:vocab_app/presentation/widgets/buttons/record_button.dart';

// class DefinitionButton extends StatefulWidget {
//   final Function(bool isRecording) onRecordingChange;
//   final Function(bool isGenerating) onGeneratingChange;
//   final Key recordButtonState;
//   final User user;
//   const DefinitionButton({
//     super.key,
//     required this.onGeneratingChange,
//     required this.onRecordingChange,
//     required this.recordButtonState,
//     required this.user,
//   });

//   @override
//   State<DefinitionButton> createState() => _DefinitionButtonStateState();
// }

// class _DefinitionButtonStateState extends State<DefinitionButton> {
//   bool _isRecording = false;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         _isGenerating
//             ? Container(
//                 width: 40,
//                 height: 40,
//                 padding: const EdgeInsets.all(10),
//                 child: const CircularProgressIndicator(),
//               )
//             : RecordButton(
//                 key: widget.recordButtonState,
//                 user: widget.user,
//                 isRecording: (bool value) {
//                   setState(() {
//                     _isRecording = value;
//                   });
//                 },
//               ),
//       ],
//     );
//   }
// }
