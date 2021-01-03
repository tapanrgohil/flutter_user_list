import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_apex_demo/NavigationUtils.dart';
import 'package:green_apex_demo/product/added_product_list.dart';
import 'package:green_apex_demo/user/user_bloc.dart';
import 'package:green_apex_demo/user/user_list.dart';
import 'package:http/http.dart' as http;

import 'model/user_response.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Green Apex',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Users'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  UserBloc _bloc = UserBloc(http.Client());
  HashMap<int, Products> productAdded = HashMap();

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _bloc.add(Fetch());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                if (productAdded.isNotEmpty) {
                  HashMap<int,Products> map  = await NavigationUtils.goNext(
                      context,
                      AddedProductList(
                        productAdded: productAdded,
                      ));
                  setState(() {
                    productAdded = map;
                  });
                }
              },
              child: Text(
                "Add To Cart ${productAdded.length}",
              ),
            ),
          )
        ],
      ),
      body: Center(
          child: BlocBuilder(
        cubit: _bloc,
        builder: (context, state) {
          if (state is InitialUserState) {
            return CircularProgressIndicator();
          } else if (state is UsersLoaded) {
            return UserList(
              users: state.users,
              callBack: (product) {
                onProductTap(product);
              },
            );
          } else {
            return Text("Something went wrong"); //error state
          }
        },
      )),
    );
  }

  void onProductTap(product) {
    setState(() {
      if (productAdded.containsKey(product.id)) {
        productAdded.remove(product.id);
      } else {
        productAdded.putIfAbsent(product.id, () {
          return product;
        });
      }
    });
  }
}
