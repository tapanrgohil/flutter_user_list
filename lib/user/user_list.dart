import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:green_apex_demo/model/user_response.dart';
import 'package:green_apex_demo/user/products_list.dart';

class UserList extends StatelessWidget {
  final List<Data> users;
  final Function callBack;

  UserList({@required this.users, @required this.callBack});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                        radius: 30.0,
                        child: CachedNetworkImage(
                          height: 200,
                          width: 200,
                          imageUrl: users[index].profilePic,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CircularProgressIndicator(
                                      value: downloadProgress.progress),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        )),
                    Container(
                      child: Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(users[index].name.trim()),
                              Text(users[index].email.trim()),
                              Text(users[index].phones[0].mobile.trim())
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Visibility(
                  visible: users[index].products.isNotEmpty,
                  child: ProductsList(
                    products: users[index].products ?? [],
                    callBack: (product) {
                      callBack(product);
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
