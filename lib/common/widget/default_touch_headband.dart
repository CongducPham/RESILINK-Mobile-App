import 'package:flutter/material.dart';

import '../../constants/global_variables.dart';
import 'default_pop_up.dart';

class DefaultTouchHeadband extends StatelessWidget {
  DefaultTouchHeadband({super.key, required this.delete, required this.update, required this.parentContext});

  bool delete;
  bool update;
  BuildContext parentContext;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.06,
      decoration: BoxDecoration(
        color: GlobalVariables.navigationBarColor,
      ),
      child: Row(
        children: [
          delete ? const Expanded(
              flex: 2,
              child: Center(
                child: Icon(
                  Icons.warning_amber,
                  color: Colors.red,
                ),
              )
          )
          : Container(),
          Expanded(
              flex: delete ? 8 : 9,
              child: Container(
                child: Text("Test"),
              )
          ),
          Expanded(
              flex: delete ? 2 : 1,
              child: Center(
                child: IconButton(
                  onPressed: () {
                    if (update) {
                      DefaultPopUp.show(context, "Expired offer", "The validity date of your offer is expired. You can update the offer and republish it.", "Close");
                    } else {

                    }
                  },
                  icon: update ? Icon(Icons.mode_edit_outlined)
                  : Icon(Icons.cancel_outlined),
                ),
              )
          ),
        ],
      ),
    );
  }


}