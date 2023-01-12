import 'package:eklezia/widgets/app_text.dart';
import 'package:eklezia/widgets/colors.dart';
import 'package:flutter/material.dart';

import '../../widgets/app_text_large.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'aide',
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    iconSize: 35,
                    padding: const EdgeInsets.all(0),
                    color: AppColors.activColor,
                    icon: const Icon(Icons.navigate_before),
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/screens/setting_screen', (route) => false);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AppTextLarge(
                        text: 'Aides',
                        color: Theme.of(context).hintColor,
                        size: 22,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: AppText(
                    text: """
          jhwcxhhjkhwjxhcjlkhvjhwkjlhjhljklwcvsqsljjlhjsdkl
          dsuhuhxwcnjhsqdjhkjlhkjhjklwxhcjklhljkhwvcxjhjhqs
          wxchvhioqiohncvxjlohuqhmhlhwcxhmjhmsjld
          wcxjhjsdhjxwcjujjhlhwcohjsldmwxc
          qsfsqdqsddsqdsdsqdqsqdsqdfsdqsdqfsdsqfsqdsqdsqdds 
          jhwcxhhjkhwjxhcjlkhvjhwkjlhjhljklwcvsqsljjlhjsdkl
          dsuhuhxwcnjhsqdjhkjlhkjhjklwxhcjklhljkhwvcxjhjhqs
          wxchvhioqiohncvxjlohuqhmhlhwcxhmjhmsjld
          wcxjhjsdhjxwcjujjhlhwcohjsldmwxc
          qsfsqdqsddsqdsdsqdqsqdsqdfsdqsdqfsdsqfsqdsqdsqdds
          jhwcxhhjkhwjxhcjlkhvjhwkjlhjhljklwcvsqsljjlhjsdkl
          dsuhuhxwcnjhsqdjhkjlhkjhjklwxhcjklhljkhwvcxjhjhqs
          wxchvhioqiohncvxjlohuqhmhlhwcxhmjhmsjld
          wcxjhjsdhjxwcjujjhlhwcohjsldmwxc
          qsfsqdqsddsqdsdsqdqsqdsqdfsdqsdqfsdsqfsqdsqdsqdds
          jhwcxhhjkhwjxhcjlkhvjhwkjlhjhljklwcvsqsljjlhjsdkl
          dsuhuhxwcnjhsqdjhkjlhkjhjklwxhcjklhljkhwvcxjhjhqs
          wxchvhioqiohncvxjlohuqhmhlhwcxhmjhmsjld
          wcxjhjsdhjxwcjujjhlhwcohjsldmwxc
          qsfsqdqsddsqdsdsqdqsqdsqdfsdqsdqfsdsqfsqdsqdsqdds
          jhwcxhhjkhwjxhcjlkhvjhwkjlhjhljklwcvsqsljjlhjsdkl
          dsuhuhxwcnjhsqdjhkjlhkjhjklwxhcjklhljkhwvcxjhjhqs
          wxchvhioqiohncvxjlohuqhmhlhwcxhmjhmsjld
          wcxjhjsdhjxwcjujjhlhwcohjsldmwxc
          qsfsqdqsddsqdsdsqdqsqdsqdfsdqsdqfsdsqfsqdsqdsqdds 
          jhwcxhhjkhwjxhcjlkhvjhwkjlhjhljklwcvsqsljjlhjsdkl
          dsuhuhxwcnjhsqdjhkjlhkjhjklwxhcjklhljkhwvcxjhjhqs
          wxchvhioqiohncvxjlohuqhmhlhwcxhmjhmsjld
          wcxjhjsdhjxwcjujjhlhwcohjsldmwxc
          qsfsqdqsddsqdsdsqdqsqdsqdfsdqsdqfsdsqfsqdsqdsqdds
          jhwcxhhjkhwjxhcjlkhvjhwkjlhjhljklwcvsqsljjlhjsdkl
          dsuhuhxwcnjhsqdjhkjlhkjhjklwxhcjklhljkhwvcxjhjhqs
          wxchvhioqiohncvxjlohuqhmhlhwcxhmjhmsjld
          wcxjhjsdhjxwcjujjhlhwcohjsldmwxc
          qsfsqdqsddsqdsdsqdqsqdsqdfsdqsdqfsdsqfsqdsqdsqdds
          jhwcxhhjkhwjxhcjlkhvjhwkjlhjhljklwcvsqsljjlhjsdkl
          dsuhuhxwcnjhsqdjhkjlhkjhjklwxhcjklhljkhwvcxjhjhqs
          wxchvhioqiohncvxjlohuqhmhlhwcxhmjhmsjld
          wcxjhjsdhjxwcjujjhlhwcohjsldmwxc
          qsfsqdqsddsqdsdsqdqsqdsqdfsdqsdqfsdsqfsqdsqdsqdds
          jhwcxhhjkhwjxhcjlkhvjhwkjlhjhljklwcvsqsljjlhjsdkl
          dsuhuhxwcnjhsqdjhkjlhkjhjklwxhcjklhljkhwvcxjhjhqs
          wxchvhioqiohncvxjlohuqhmhlhwcxhmjhmsjld
          wcxjhjsdhjxwcjujjhlhwcohjsldmwxc
          qsfsqdqsddsqdsdsqdqsqdsqdfsdqsdqfsdsqfsqdsqdsqdds 
          jhwcxhhjkhwjxhcjlkhvjhwkjlhjhljklwcvsqsljjlhjsdkl
          dsuhuhxwcnjhsqdjhkjlhkjhjklwxhcjklhljkhwvcxjhjhqs
          wxchvhioqiohncvxjlohuqhmhlhwcxhmjhmsjld
          wcxjhjsdhjxwcjujjhlhwcohjsldmwxc
          qsfsqdqsddsqdsdsqdqsqdsqdfsdqsdqfsdsqfsqdsqdsqdds
          jhwcxhhjkhwjxhcjlkhvjhwkjlhjhljklwcvsqsljjlhjsdkl
          dsuhuhxwcnjhsqdjhkjlhkjhjklwxhcjklhljkhwvcxjhjhqs
          wxchvhioqiohncvxjlohuqhmhlhwcxhmjhmsjld
          wcxjhjsdhjxwcjujjhlhwcohjsldmwxc
          qsfsqdqsddsqdsdsqdqsqdsqdfsdqsdqfsdsqfsqdsqdsqdds
          jhwcxhhjkhwjxhcjlkhvjhwkjlhjhljklwcvsqsljjlhjsdkl
          dsuhuhxwcnjhsqdjhkjlhkjhjklwxhcjklhljkhwvcxjhjhqs
          wxchvhioqiohncvxjlohuqhmhlhwcxhmjhmsjld
          wcxjhjsdhjxwcjujjhlhwcohjsldmwxc
          qsfsqdqsddsqdsdsqdqsqdsqdfsdqsdqfsdsqfsqdsqdsqdds""",
                    size: 16,
                    color: Theme.of(context).cardColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
