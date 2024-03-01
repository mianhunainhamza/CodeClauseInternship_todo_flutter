import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:todo_app_getx/app/core/utils/extensions.dart';
import 'package:todo_app_getx/app/core/values/colors.dart';
import 'package:todo_app_getx/app/data/models/task.dart';
import 'package:todo_app_getx/app/modules/home/controller.dart';
import 'package:todo_app_getx/app/widgets/icon.dart';

import '../../../utils/colors.dart';

class AddCard extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  AddCard({super.key});

  @override
  Widget build(BuildContext context) {
    final icons = getIcons();
    var cardWidth = Get.width - 12.0.wp;
    return Container(
      width: cardWidth / 2,
      height: cardWidth / 2,
      margin: EdgeInsets.all(3.0.wp),
      child: GestureDetector(
        onTap: () async {
          await showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: RichText(
                  text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Task',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),TextSpan(
                          text: ' Type',
                          style: TextStyle(
                            color: yellowDark,
                            fontSize: 14.0.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ]
                  ),
                ),
                content: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.0.wp),
                  child: Form(
                    key: homeCtrl.formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.0.wp),
                          child: CupertinoTextField(
                            controller: homeCtrl.formEditCtrl,
                            placeholder: 'Title',
                            decoration: BoxDecoration(
                              border: Border.all(color: CupertinoColors.systemGrey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.0.wp),
                          child: Wrap(
                            spacing: 2.0.wp,
                            children: icons
                                .map(
                                  (element) => Obx(
                                    () {
                                  final index = icons.indexOf(element);
                                  return ChoiceChip(
                                    selectedColor: CupertinoColors.systemGrey5,
                                    pressElevation: 4,
                                    backgroundColor: CupertinoColors.white,
                                    label: element,
                                    selected: homeCtrl.chipIndex.value == index,
                                    onSelected: (bool selected) {
                                      homeCtrl.chipIndex.value =
                                      selected ? index : 0;
                                    },
                                  );
                                },
                              ),
                            )
                                .toList(),
                          ),
                        ),
                        CupertinoButton(
                          onPressed: () {
                            if (homeCtrl.formKey.currentState!.validate()) {
                              int icon =
                                  icons[homeCtrl.chipIndex.value].icon!.codePoint;
                              String color =
                              icons[homeCtrl.chipIndex.value].color!.toHex();
                              var task = Task(
                                  title: homeCtrl.formEditCtrl.text,
                                  icon: icon,
                                  color: color);
                              Get.back();
                              homeCtrl.addTask(task)
                                  ? EasyLoading.showSuccess('Task Created')
                                  : EasyLoading.showError('Task Already Exists');

                              homeCtrl.formEditCtrl.clear();
                              homeCtrl.changeChipIndex(0);
                            }
                          },
                          color: yellow,
                          borderRadius: BorderRadius.circular(20),
                          padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 15),
                          child:const Text("Confirm"),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
          homeCtrl.formEditCtrl.clear();
          homeCtrl.changeChipIndex(0);
        },
        child: DottedBorder(
          color: Colors.grey[400]!,
          dashPattern: const [10, 8],
          child: Center(
            child: Icon(
              CupertinoIcons.add,
              size: 10.0.wp,
              color: yellowDark,
            ),
          ),
        ),
      ),
    );
  }
}
