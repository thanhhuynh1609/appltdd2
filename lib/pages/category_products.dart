import 'dart:convert'; // Để sử dụng base64Decode
import 'dart:typed_data'; // Để sử dụng Uint8List

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/pages/product_detail.dart';
import 'package:shopping_app/pages/widget/support_widget.dart';
import 'package:shopping_app/services/database.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class CategoryProduct extends StatefulWidget {
  String category;
  CategoryProduct({required this.category});

  @override
  State<CategoryProduct> createState() => _CategoryProductState();
}

class _CategoryProductState extends State<CategoryProduct> {
  Stream? CategoryStream;

  // Hàm lấy dữ liệu từ Firestore
  getontheload() async {
    CategoryStream = await DatabaseMethods().getProducts(widget.category);
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  // Hàm hiển thị sản phẩm từ Firestore
  Widget allProducts() {
    return StreamBuilder(
      stream: CategoryStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return GridView.builder(
          padding: kIsWeb
              ? EdgeInsets.symmetric(horizontal: 40, vertical: 20)
              : EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: kIsWeb ? 4 : 2, // 4 cột cho web, 2 cột cho app
            childAspectRatio: kIsWeb ? 0.75 : 0.6, // Tỷ lệ phù hợp hơn cho web
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
          ),
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];

            // Giải mã base64 từ Firestore
            String base64Image = ds["Image"];
            Uint8List bytes = base64Decode(base64Image);

            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: kIsWeb
                    ? [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ]
                    : null, // Thêm bóng cho web
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  // Hiển thị hình ảnh từ base64
                  Center(
                    child: Image.memory(
                      bytes,
                      height: kIsWeb ? 200 : 150, // Tăng kích thước cho web
                      width: kIsWeb ? 200 : 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    ds["Name"],
                    style: AppWidget.semiboldTextFeildStyle(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$" + ds["Price"],
                        style: TextStyle(
                          color: Color(0xfffd6f3e),
                          fontSize: kIsWeb ? 22 : 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductDetail(
                                      detail: ds["Detail"],
                                      image: ds["Image"],
                                      name: ds["Name"],
                                      price: ds["Price"])));
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Color(0xfffd6f3e),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: kIsWeb ? 20 : 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
          title: Text(
            "${widget.category} Products",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width, // Full chiều ngang
          height: MediaQuery.of(context).size.height, // Full chiều cao
          color: Colors.grey[100], // Màu nền nhẹ cho web
          child: allProducts(),
        ),
      );
    } else {
      // Giữ nguyên giao diện gốc cho app
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xfff2f2f2),
        ),
        body: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              Expanded(child: allProducts()),
            ],
          ),
        ),
      );
    }
  }
}







// import 'dart:convert';  // Để sử dụng base64Decode
// import 'dart:typed_data';  // Để sử dụng Uint8List

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:shopping_app/pages/product_detail.dart';
// import 'package:shopping_app/pages/widget/support_widget.dart';
// import 'package:shopping_app/services/database.dart';

// class CategoryProduct extends StatefulWidget {
//   String category;
//   CategoryProduct({required this.category});

//   @override
//   State<CategoryProduct> createState() => _CategoryProductState();
// }

// class _CategoryProductState extends State<CategoryProduct> {
//   Stream? CategoryStream;

//   // Hàm lấy dữ liệu từ Firestore
//   getontheload() async {
//     CategoryStream = await DatabaseMethods().getProducts(widget.category);
//     setState(() {});
//   }

//   @override
//   void initState() {
//     getontheload();
//     super.initState();
//   }

//   // Hàm hiển thị sản phẩm từ Firestore
//   Widget allProducts() {
//     return StreamBuilder(
//       stream: CategoryStream,
//       builder: (context, AsyncSnapshot snapshot) {
//         return snapshot.hasData
//             ? GridView.builder(
//                 padding: EdgeInsets.zero,
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     childAspectRatio: 0.6,
//                     mainAxisSpacing: 10,
//                     crossAxisSpacing: 10),
//                 itemCount: snapshot.data.docs.length,
//                 itemBuilder: (context, index) {
//                   DocumentSnapshot ds = snapshot.data.docs[index];

//                   // Giải mã base64 từ Firestore
//                   String base64Image = ds["Image"];
//                   Uint8List bytes = base64Decode(base64Image);

//                   return Container(
//                     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                     decoration: BoxDecoration(
//                         color: Colors.white, borderRadius: BorderRadius.circular(10)),
//                     child: Column(
//                       children: [
//                         SizedBox(height: 10,),
//                         // Hiển thị hình ảnh từ base64
//                         Image.memory(
//                           bytes,
//                           height: 150,
//                           width: 150,
//                           fit: BoxFit.cover,
//                         ),
//                         SizedBox(height: 10,),
//                         Text(
//                           ds["Name"],
//                           style: AppWidget.semiboldTextFeildStyle(),
//                         ),
//                         Spacer(),
//                         Row(
//                           children: [
//                             Text(
//                               "\$" + ds["Price"],
//                               style: TextStyle(
//                                   color: Color(0xfffd6f3e),
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                             SizedBox(
//                               width: 30,
//                             ),
//                             GestureDetector(
//                               onTap: (){
//                                 Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductDetail(detail: ds["Detail"], image: ds["Image"], name: ds["Name"], price: ds["Price"])));
//                               },
//                               child: Container(
//                                   padding: EdgeInsets.all(5),
//                                   decoration: BoxDecoration(
//                                       color: Color(0xfffd6f3e),
//                                       borderRadius: BorderRadius.circular(7)),
//                                   child: Icon(
//                                     Icons.add,
//                                     color: Colors.white,
//                                   )),
//                             )
//                           ],
//                         )
//                       ],
//                     ),
//                   );
//                 })
//             : Container();
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xfff2f2f2),
//       ),
//       body: Container(
//         margin: EdgeInsets.only(left: 20, right: 20),
//         child: Container(
//           child: Column(
//             children: [
//               Expanded(child: allProducts()),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }









// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:shopping_app/pages/widget/support_widget.dart';
// import 'package:shopping_app/services/database.dart';

// class CategoryProduct extends StatefulWidget {
//   String category;
//   CategoryProduct({required this.category});

//   @override
//   State<CategoryProduct> createState() => _CategoryProductState();
// }

// class _CategoryProductState extends State<CategoryProduct> {
//   Stream? CategoryStream;

//   getontheload()async{
//     CategoryStream= await DatabaseMethods().getProducts(widget.category);
//     setState(() {
      
//     });
//   }

//  @override
//  void initState(){
//   getontheload();
//    super.initState();
//  }


//   Widget allProducts() {
//     return StreamBuilder(
//         stream: CategoryStream,
//         builder: (context, AsyncSnapshot snapshot) {
//           return snapshot.hasData
//               ? GridView.builder(
//                   padding: EdgeInsets.zero,
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       childAspectRatio: 0.6,
//                       mainAxisSpacing: 10,
//                       crossAxisSpacing: 10),
//                   itemCount: snapshot.data.docs.length,
//                   itemBuilder: (context, index) {
//                     DocumentSnapshot ds = snapshot.data.docs[index];

//                     return Container(
//                       margin: EdgeInsets.only(right: 20),
//                       padding: EdgeInsets.symmetric(horizontal: 20),
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(10)),
//                       child: Column(
//                         children: [
//                           Image.network(
//                             ds["Image"],
//                             height: 150,
//                             width: 150,
//                             fit: BoxFit.cover,
//                           ),
//                           Text(
//                             ds["Name"],
//                             style: AppWidget.semiboldTextFeildStyle(),
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Row(
//                             children: [
//                               Text(
//                                 "\$"+ds["Price"],
//                                 style: TextStyle(
//                                     color: Color(0xfffd6f3e),
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                               SizedBox(
//                                 width: 50,
//                               ),
//                               Container(
//                                   padding: EdgeInsets.all(5),
//                                   decoration: BoxDecoration(
//                                       color: Color(0xfffd6f3e),
//                                       borderRadius: BorderRadius.circular(7)),
//                                   child: Icon(
//                                     Icons.add,
//                                     color: Colors.white,
//                                   ))
//                             ],
//                           )
//                         ],
//                       ),
//                     );
//                   })
//               : Container();
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xfff2f2f2),
//       ),
//       body: Container(
//         child: Container(
//           child: Column(
//             children: [
//               Expanded(child: allProducts()),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
