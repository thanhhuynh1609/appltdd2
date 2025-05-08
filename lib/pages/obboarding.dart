import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Scaffold(
        backgroundColor: Color(0xffEDF0E7),
        body: Container(
          width: MediaQuery.of(context).size.width, // Full chiều ngang
          height: MediaQuery.of(context).size.height, // Full chiều cao
          child: Row(
            children: [
              // Phần bên trái: Hình ảnh
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/tainghe.png"),
                      fit: BoxFit.contain, // Giữ tỷ lệ hình ảnh
                    ),
                  ),
                ),
              ),
              // Phần bên phải: Tiêu đề và nút
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Explore\nThe Best\nProducts',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 60, // Tăng kích thước cho web
                        ),
                      ),
                      SizedBox(height: 40),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          onTap: () {
                            // Logic khi nhấn nút "Next"
                          },
                          child: Container(
                            padding: EdgeInsets.all(25),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: Text(
                              'Next',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 24, // Tăng kích thước cho web
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // Giữ nguyên giao diện gốc cho app
      return Scaffold(
        backgroundColor: Color(0xffEDF0E7),
        body: Container(
          margin: EdgeInsets.only(top: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset("images/tainghe.png"),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  'Explore\nThe Best\nProducts',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 20.0),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    child: Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
}





// import 'package:flutter/material.dart';

// class Onboarding extends StatefulWidget {
//   const Onboarding({super.key});

//   @override
//   State<Onboarding> createState() => _OnboardingState();
// }

// class _OnboardingState extends State<Onboarding> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xffEDF0E7),
//       body: Container(
//         margin: EdgeInsets.only(top: 50.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Image.asset("images/tainghe.png"),
//             Padding(
//               padding: const EdgeInsets.only(left: 20.0),
//               child: Text(
//               'Explore\nThe Best\nProducts',
//               style:
//                   TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 40 ),
//             ),
//             ),
//             SizedBox(height: 20.0,),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Container(
//                   margin: EdgeInsets.only(right: 20.0),
//                   padding: EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.black,
//                   ),
//                   child: Text(
//                   'Next',
//                   style:
//                       TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20 ),
//                 ),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
