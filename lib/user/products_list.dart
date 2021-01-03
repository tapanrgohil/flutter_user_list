import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:green_apex_demo/model/user_response.dart';
import 'package:green_apex_demo/model/user_response.dart';

class ProductsList extends StatelessWidget {
  final List<Products> products;
  final Function callBack;

  const ProductsList({this.products, this.callBack});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 140,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: products.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                callBack(products[index]);
              },
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CachedNetworkImage(
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                      imageUrl: products[index].productImage,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              CircularProgressIndicator(
                                  value: downloadProgress.progress),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    Text(products[index].productName.trim()),
                    Text(products[index].productPrice.toString().trim())
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
