import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/pages/category_products.dart';
import 'package:shopping_app/pages/widget/support_widget.dart';
import 'package:shopping_app/services/database.dart';
import 'package:shopping_app/services/shared_pref.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool search = false;

  List categories = [
    "images/headphoneicon.png",
    "images/laptopicon.png",
    "images/watchicon.png",
    "images/tvicon.png",
  ];

  List Categoryname = [
    "Headphones",
    "Laptop",
    "Watch",
    "TV",
  ];

  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }
    setState(() {
      search = true;
    });

    var CapitalizedValue = value.substring(0, 1).toUpperCase() + value.substring(1);
    if (queryResultSet.isEmpty && value.length == 1) {
      DatabaseMethods().search(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; ++i) {
          queryResultSet.add(docs.docs[i].data());
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['UpdateName'].startsWith(CapitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  String? name, image;

  getthesharedpref() async {
    name = await SharedPreferenceHelper().getUserName();
    image = await SharedPreferenceHelper().getUserImage();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Scaffold(
        backgroundColor: Colors.grey[100], // Nền nhẹ cho web
        body: name == null
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width, // Full chiều ngang
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hey, " + name!,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                "Good Morning",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset(
                              "images/boy.jpg",
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      // Thanh tìm kiếm
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6, // Giới hạn chiều rộng
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: TextField(
                          onChanged: (value) {
                            initiateSearch(value);
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search Products",
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(Icons.search, color: Colors.black),
                            contentPadding: EdgeInsets.symmetric(vertical: 15),
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      // Kết quả tìm kiếm
                      search
                          ? Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: ListView(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                primary: false,
                                shrinkWrap: true,
                                children: tempSearchStore.map((element) {
                                  return buildResultCard(element);
                                }).toList(),
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Categories
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Categories",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Text(
                                        "See all",
                                        style: TextStyle(
                                          color: Color(0xfffd6f3e),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Row(
                                  children: [
                                    Container(
                                      width: 150,
                                      height: 150,
                                      padding: EdgeInsets.all(20),
                                      margin: EdgeInsets.only(right: 20),
                                      decoration: BoxDecoration(
                                        color: Color(0xfffd6f3e),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "All",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: SizedBox(
                                        height: 150,
                                        child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          itemCount: categories.length,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return CategoryTile(
                                              image: categories[index],
                                              name: Categoryname[index],
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 40),
                                // All Products
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "All Products",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Text(
                                        "See all",
                                        style: TextStyle(
                                          color: Color(0xfffd6f3e),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                SizedBox(
                                  height: 300,
                                  child: ListView(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      ProductTile(
                                        image: "images/headphone2.png",
                                        name: "Headphone",
                                        price: "100",
                                      ),
                                      ProductTile(
                                        image: "images/watch2.png",
                                        name: "Apple Watch",
                                        price: "300",
                                      ),
                                      ProductTile(
                                        image: "images/laptop2.png",
                                        name: "Laptop",
                                        price: "1000",
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
      );
    } else {
      // Giữ nguyên giao diện gốc cho app
      return Scaffold(
        backgroundColor: Color(0xfff2f2f2),
        body: name == null
            ? Center(child: CircularProgressIndicator())
            : Container(
                margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Hey, " + name!, style: AppWidget.boldTextFeildStyle()),
                            Text("Good Morning", style: AppWidget.lightTextFeildStyle()),
                          ],
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            "images/boy.jpg",
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.circular(10)),
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                        onChanged: (value) {
                          initiateSearch(value);
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search Products",
                          hintStyle: AppWidget.lightTextFeildStyle(),
                          prefixIcon: Icon(Icons.search, color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    search
                        ? ListView(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            primary: false,
                            shrinkWrap: true,
                            children: tempSearchStore.map((element) {
                              return buildResultCard(element);
                            }).toList(),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Categories", style: AppWidget.semiboldTextFeildStyle()),
                                Text(
                                  "see all",
                                  style: TextStyle(
                                      color: Color(0xfffd6f3e),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          height: 130,
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                              color: Color(0xfffd6f3e),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              "All",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 130,
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: categories.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return CategoryTile(
                                    image: categories[index], name: Categoryname[index]);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("All Products", style: AppWidget.semiboldTextFeildStyle()),
                        Text(
                          "see all",
                          style: TextStyle(
                              color: Color(0xfffd6f3e),
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Container(
                      height: 240,
                      child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: [
                          ProductTile(
                            image: "images/headphone2.png",
                            name: "Headphone",
                            price: "100",
                          ),
                          ProductTile(
                            image: "images/watch2.png",
                            name: "Apple Watch",
                            price: "300",
                          ),
                          ProductTile(
                            image: "images/laptop2.png",
                            name: "Laptop",
                            price: "1000",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      );
    }
  }

  Widget buildResultCard(data) {
    return Container(
      height: 100,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Image.network(
            data["Image"],
            height: 50,
            width: 50,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 10),
          Text(
            data["Name"],
            style: AppWidget.semiboldTextFeildStyle(),
          ),
        ],
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  String image, name;
  CategoryTile({required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryProduct(category: name)));
      },
      child: Container(
        padding: EdgeInsets.all(kIsWeb ? 25 : 20),
        margin: EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: kIsWeb
              ? [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              image,
              height: kIsWeb ? 70 : 50,
              width: kIsWeb ? 70 : 50,
              fit: BoxFit.cover,
            ),
            Icon(Icons.arrow_forward, size: kIsWeb ? 24 : 20),
          ],
        ),
      ),
    );
  }
}

class ProductTile extends StatelessWidget {
  String image, name, price;
  ProductTile({required this.image, required this.name, required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 20),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: kIsWeb
            ? [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          Image.asset(
            image,
            height: kIsWeb ? 180 : 150,
            width: kIsWeb ? 180 : 150,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 10),
          Text(
            name,
            style: AppWidget.semiboldTextFeildStyle(),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "\$$price",
                style: TextStyle(
                  color: Color(0xfffd6f3e),
                  fontSize: kIsWeb ? 22 : 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
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
            ],
          ),
        ],
      ),
    );
  }
}





// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:shopping_app/pages/category_products.dart';
// import 'package:shopping_app/pages/widget/support_widget.dart';
// import 'package:shopping_app/services/database.dart';
// import 'package:shopping_app/services/shared_pref.dart';

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
// bool search=false;


//   List categories = [
//     "images/headphoneicon.png",
//     "images/laptopicon.png",
//     "images/watchicon.png",
//     "images/tvicon.png",
//   ];

//   List Categoryname = [
//     "Headphones",
//     "Laptop",
//     "Watch",
//     "TV",
//   ];

//   var queryResultSet=[];
//   var tempSearchStore=[];



//   initiateSearch(value){
//     if(value.length==0){
//       setState(() {
//         queryResultSet=[];
//         tempSearchStore=[];
//       });
//     }
//     setState(() {
//       search = true;
//     });

//     var CapitalizedValue = value.substring(0,1).toUpperCase()+value.substring(1);
//     if(queryResultSet.isEmpty && value.length==1){
//       DatabaseMethods().search(value).then((QuerySnapshot docs){
//         for(int i=0; i<docs.docs.length; ++i){
//           queryResultSet.add(docs.docs[i].data());
//         }
//       });
//     }else{
//       tempSearchStore=[];
//       queryResultSet.forEach((element){
//         if(element['UpdateName'].startsWith(CapitalizedValue )){
//           setState(() {
//             tempSearchStore.add(element);
//           });
//         }
//       });
//     }
//   }

//   String? name, image;

//   getthesharedpref() async {
//     name = await SharedPreferenceHelper().getUserName();
//     image = await SharedPreferenceHelper().getUserImage();
//     setState(() {});
//   }

//   ontheload() async {
//     await getthesharedpref();
//     setState(() {});
//   }

//   @override
//   void initState() {
//     ontheload();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xfff2f2f2),
//       body: name == null?
//            Center(child: CircularProgressIndicator())
//           : Container(
//               margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("Hey, " + name!,
//                               style: AppWidget.boldTextFeildStyle()),
//                           Text("Good Morning",
//                               style: AppWidget.lightTextFeildStyle()),
//                         ],
//                       ),
//                       ClipRRect(
//                           borderRadius: BorderRadius.circular(20),
//                           child: Image.asset(
//                             "images/boy.jpg",
//                             height: 70,
//                             width: 70,
//                             fit: BoxFit.cover,
//                           )),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 30,
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(10)),
//                     width: MediaQuery.of(context).size.width,
//                     child: TextField(
//                       onChanged: (value){
//                         initiateSearch(value);
//                       },
//                       decoration: InputDecoration(
//                         border: InputBorder.none,
//                         hintText: "Search Products",
//                         hintStyle: AppWidget.lightTextFeildStyle(),
//                         prefixIcon: Icon(
//                           Icons.search,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//               search? ListView(
//                 padding: EdgeInsets.only(left: 10, right: 10),
//                 primary: false,
//                 shrinkWrap: true,
//                 children: tempSearchStore.map((element){
//                   return buildResultCard(element);
//                 }).toList(),
//               ):    Padding(
//                     padding: const EdgeInsets.only(right: 20),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "Categories",
//                           style: AppWidget.semiboldTextFeildStyle(),
//                         ),
//                         Text(
//                           "see all",
//                           style: TextStyle(
//                               color: Color(0xfffd6f3e),
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold),
//                         )
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Row(
//                     children: [
//                       Container(
//                           height: 130,
//                           padding: EdgeInsets.all(20),
//                           margin: EdgeInsets.only(right: 20),
//                           decoration: BoxDecoration(
//                               color: Color(0xfffd6f3e),
//                               borderRadius: BorderRadius.circular(10)),
//                           child: Center(
//                               child: Text(
//                             "All",
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold),
//                           ))),
//                       Expanded(
//                         child: Container(
//                           height: 130,
//                           child: ListView.builder(
//                               padding: EdgeInsets.zero,
//                               itemCount: categories.length,
//                               shrinkWrap: true,
//                               scrollDirection: Axis.horizontal,
//                               itemBuilder: (context, index) {
//                                 return CategoryTile(
//                                     image: categories[index],
//                                     name: Categoryname[index]);
//                               }),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "All Products",
//                         style: AppWidget.semiboldTextFeildStyle(),
//                       ),
//                       Text(
//                         "see all",
//                         style: TextStyle(
//                             color: Color(0xfffd6f3e),
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold),
//                       )
//                     ],
//                   ),
//                   SizedBox(
//                     height: 30,
//                   ),
//                   Container(
//                     height: 240,
//                     child: ListView(
//                       shrinkWrap: true,
//                       scrollDirection: Axis.horizontal,
//                       children: [
//                         Container(
//                           margin: EdgeInsets.only(right: 20),
//                           padding: EdgeInsets.symmetric(horizontal: 20),
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(10)),
//                           child: Column(
//                             children: [
//                               Image.asset(
//                                 "images/headphone2.png",
//                                 height: 150,
//                                 width: 150,
//                                 fit: BoxFit.cover,
//                               ),
//                               Text(
//                                 "Headphone",
//                                 style: AppWidget.semiboldTextFeildStyle(),
//                               ),
//                               SizedBox(
//                                 height: 10,
//                               ),
//                               Row(
//                                 children: [
//                                   Text(
//                                     "\$100",
//                                     style: TextStyle(
//                                         color: Color(0xfffd6f3e),
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   SizedBox(
//                                     width: 50,
//                                   ),
//                                   Container(
//                                       padding: EdgeInsets.all(5),
//                                       decoration: BoxDecoration(
//                                           color: Color(0xfffd6f3e),
//                                           borderRadius:
//                                               BorderRadius.circular(7)),
//                                       child: Icon(
//                                         Icons.add,
//                                         color: Colors.white,
//                                       ))
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                         Container(
//                           margin: EdgeInsets.only(right: 20),
//                           padding: EdgeInsets.symmetric(horizontal: 20),
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(10)),
//                           child: Column(
//                             children: [
//                               Image.asset(
//                                 "images/watch2.png",
//                                 height: 150,
//                                 width: 150,
//                                 fit: BoxFit.cover,
//                               ),
//                               Text(
//                                 "Apple Watch   ",
//                                 style: AppWidget.semiboldTextFeildStyle(),
//                               ),
//                               SizedBox(
//                                 height: 10,
//                               ),
//                               Row(
//                                 children: [
//                                   Text(
//                                     "\$300",
//                                     style: TextStyle(
//                                         color: Color(0xfffd6f3e),
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   SizedBox(
//                                     width: 50,
//                                   ),
//                                   Container(
//                                       padding: EdgeInsets.all(5),
//                                       decoration: BoxDecoration(
//                                           color: Color(0xfffd6f3e),
//                                           borderRadius:
//                                               BorderRadius.circular(7)),
//                                       child: Icon(
//                                         Icons.add,
//                                         color: Colors.white,
//                                       ))
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                         Container(
//                           padding: EdgeInsets.symmetric(horizontal: 20),
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(10)),
//                           child: Column(
//                             children: [
//                               Image.asset(
//                                 "images/laptop2.png",
//                                 height: 150,
//                                 width: 150,
//                                 fit: BoxFit.cover,
//                               ),
//                               Text(
//                                 "Laptop",
//                                 style: AppWidget.semiboldTextFeildStyle(),
//                               ),
//                               SizedBox(
//                                 height: 10,
//                               ),
//                               Row(
//                                 children: [
//                                   Text(
//                                     "\$1000",
//                                     style: TextStyle(
//                                         color: Color(0xfffd6f3e),
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   SizedBox(
//                                     width: 50,
//                                   ),
//                                   Container(
//                                       padding: EdgeInsets.all(5),
//                                       decoration: BoxDecoration(
//                                           color: Color(0xfffd6f3e),
//                                           borderRadius:
//                                               BorderRadius.circular(7)),
//                                       child: Icon(
//                                         Icons.add,
//                                         color: Colors.white,
//                                       ))
//                                 ],
//                               )
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
//   Widget buildResultCard(data){
//     return Container(
//       height: 100,
//       child: Row(
//         children: [
//           Image.network(data["Image"], height: 50, width: 50, fit: BoxFit.cover,),
//           Text(data["Name"],style: AppWidget.semiboldTextFeildStyle(),)
//         ],
//       ),
//     );
//   }
// }

// class CategoryTile extends StatelessWidget {
//   String image, name;
//   CategoryTile({required this.image, required this.name});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => CategoryProduct(category: name)));
//       },
//       child: Container(
//         padding: EdgeInsets.all(20),
//         margin: EdgeInsets.only(right: 20),
//         decoration: BoxDecoration(
//             color: Colors.white, borderRadius: BorderRadius.circular(10)),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Image.asset(
//               image,
//               height: 50,
//               width: 50,
//               fit: BoxFit.cover,
//             ),
//             Icon(Icons.arrow_forward)
//           ],
//         ),
//       ),
//     );
//   }
  
// }
