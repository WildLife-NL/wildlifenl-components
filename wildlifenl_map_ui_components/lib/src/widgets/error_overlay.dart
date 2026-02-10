import 'package:flutter/material.dart';
import 'package:wildlifenl_map_ui_components/src/constants/colors.dart';
import 'package:wildlifenl_map_ui_components/src/utils/responsive_utils.dart';

/// WildLifeNL error overlay: shows one or more messages with optional title.
class ErrorOverlay extends StatelessWidget {
  final List<String> messages;
  final String? title;
  final String? instruction;

  const ErrorOverlay({
    super.key,
    required this.messages,
    this.title,
    this.instruction,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Material(
        color: Colors.black.withValues(alpha: 0.5),
        child: Center(
          child: GestureDetector(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
              constraints: BoxConstraints(maxWidth: responsive.wp(80)),
              decoration: BoxDecoration(
                color: WildLifeNLColors.lightMintGreen,
                borderRadius: BorderRadius.circular(responsive.sp(3.1)),
                border: Border.all(
                  color: Colors.red.shade700,
                  width: responsive.sp(0.2),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: responsive.hp(1.5)),
                    child: IconButton(
                      icon: Icon(
                        Icons.error_outline,
                        size: responsive.sp(4),
                        color: Colors.red.shade700,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      iconSize: responsive.sp(6),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        responsive.wp(5),
                        responsive.hp(1),
                        responsive.wp(5),
                        responsive.hp(2.5),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Builder(
                            builder: (context) {
                              final rawTitle = title;
                              String titleToShow;
                              String bodyToShow = '';

                              if (rawTitle != null && rawTitle.isNotEmpty) {
                                titleToShow = rawTitle;
                                bodyToShow = messages.join('\n');
                              } else if (messages.isNotEmpty) {
                                if (messages.first.length <= 60 &&
                                    messages.length > 1) {
                                  titleToShow = messages.first;
                                  bodyToShow = messages.sublist(1).join('\n');
                                } else if (messages.length == 1 &&
                                    messages.first.length <= 80) {
                                  titleToShow = messages.first;
                                  bodyToShow = instruction ?? '';
                                } else {
                                  titleToShow = 'Fout';
                                  bodyToShow = messages.join('\n');
                                }
                              } else {
                                titleToShow = 'Fout';
                                bodyToShow = instruction ?? '';
                              }

                              return Column(
                                children: [
                                  Text(
                                    titleToShow,
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold,
                                      fontSize: responsive.fontSize(18),
                                      color: Colors.red.shade700,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: responsive.spacing(12)),
                                  if (bodyToShow.isNotEmpty) ...[
                                    Text(
                                      bodyToShow,
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: responsive.fontSize(16),
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: responsive.spacing(8)),
                                  ],
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
