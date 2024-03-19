// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/presentation/widgets/buttons/default_button.dart';
import 'package:vocab_app/utils/translate.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:uuid/uuid.dart';

class DetailImageScreen extends StatelessWidget {
  final String imageUrl;

  const DetailImageScreen({
    super.key,
    required this.imageUrl,
  });

  void onSave(BuildContext context) async {
    var response = await Dio().get(
      imageUrl,
      options: Options(responseType: ResponseType.bytes),
    );
    await ImageGallerySaver.saveImage(
      Uint8List.fromList(response.data),
      quality: 60,
      name: const Uuid().v1(),
    );

    if (kDebugMode) {
      print("save success");
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: SizeConfig.screenHeight,
        color: Colors.black,
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          onLongPress: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return DefaultButton(
                  onPressed: () => onSave(context),
                  backgroundColor: Colors.white,
                  child: Text(
                    Translate.of(context).translate("save"),
                    style: FONT_CONST.BOLD_DEFAULT_18,
                  ),
                );
              },
            );
          },
          child: Image.network(imageUrl),
        ),
      ),
    );
  }
}
