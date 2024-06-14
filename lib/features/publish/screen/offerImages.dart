import 'package:flutter/material.dart';
import 'package:resilink_design/constants/global_variables.dart';

class OfferImages extends StatefulWidget {
  const OfferImages({super.key});

  @override
  State<StatefulWidget> createState() {
    return OfferImagesState();
  }

}

class OfferImagesState extends State<OfferImages> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery
            .of(context)
            .size
            .height * 0.45,
        padding: EdgeInsets.only(left: 25, right: 25),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: 4,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 1.1
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Action à réaliser lors du clic sur l'image
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: GlobalVariables.navigationBarColor,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.add_a_photo,
                            size: constraints.maxHeight * 0.1,
                            color: Colors.grey[600],
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Add a picture',
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        )
    );
  }

}