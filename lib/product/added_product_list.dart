import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:green_apex_demo/NavigationUtils.dart';
import 'package:green_apex_demo/model/user_response.dart';

class AddedProductList extends StatefulWidget {
  final HashMap<int, Products> productAdded;

  AddedProductList({this.productAdded});

  @override
  _AddedProductListState createState() => _AddedProductListState();
}

class _AddedProductListState extends State<AddedProductList> {
  List<Products> _products = [];

  @override
  void initState() {
    super.initState();
    widget.productAdded.entries.forEach((element) {
      if (element.value != null) _products.add(element.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final HashMap<int, Products> map = HashMap();
        _products.forEach((element) {
          map.putIfAbsent(element.id, () => element);
        });
        NavigationUtils.goBack(context, data: map);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Added Products"),
        ),
        body: ListView.builder(
          itemCount: _products.length,
          itemBuilder: (context, index) {
            return Container(
                height: 140,
                child: InkWell(
                  onLongPress: () {
                    setState(() {
                      _products.removeAt(index);
                    });
                  },
                  child: Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CachedNetworkImage(
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                          imageUrl: _products[index].productImage,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CircularProgressIndicator(
                                      value: downloadProgress.progress),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                        Text(_products[index].productName.trim()),
                        Text(_products[index].productPrice.toString().trim())
                      ],
                    ),
                  ),
                ));
          },
        ),
      ),
    );
  }
}
