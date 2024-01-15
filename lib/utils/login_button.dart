import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget loginButton({
  required BuildContext context,
  required String text,
  required VoidCallback onPressed,
  String? svgPath,
  int? width,
  int? height,
  Color? textColor,
  Color? buttonColor,
  BorderSide? side,
}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width * 0.8,
    height: MediaQuery.of(context).size.height * 0.06,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        backgroundColor: buttonColor,
        side: side,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        children: [
          Container(
              child: svgPath != null
                  ? SvgPicture.asset(
                      svgPath,
                      width: width?.toDouble(),
                      height: height?.toDouble(),
                    )
                  : Container()),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.center, // 텍스트 가운데 정렬
              style: TextStyle(color: textColor),
            ),
          ),
        ],
      ),
    ),
  );
}
