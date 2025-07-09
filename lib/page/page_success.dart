import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../database/db_helper.dart';
import '../model/model_database.dart';
import 'page_home.dart';

class PageSuccess extends StatefulWidget {
  final String strSize;
  final String strPrice;
  final String strDesc;
  final String strName;
  final String strDate;
  final String strImage;

  const PageSuccess({
    super.key,
    required this.strSize,
    required this.strPrice,
    required this.strDesc,
    required this.strName,
    required this.strDate,
    required this.strImage,
  });

  @override
  State<PageSuccess> createState() => _PageSuccessState();
}

class _PageSuccessState extends State<PageSuccess> {
  late DatabaseHelper dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper.instance;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xfff8f8f8),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🎉 Confetti Animation
              SizedBox(
                height: 150,
                child: Lottie.asset('assets/animations/success.json'),
              ),

              const SizedBox(height: 10),

              // ✅ Check Icon
              // const Icon(Icons.check_circle_outline,
              //     size: 60, color: Color(0xff1B100E)),

              const SizedBox(height: 20),

              // 📦 Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.strImage,
                  height: size.height * 0.25,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                'Yay, your order is being processed!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),
              Text(
                'We are preparing your ${widget.strName} with care.',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: 260,
                height: 55,
                child: ElevatedButton(
                  onPressed: () async {
                    await dbHelper.create(
                      ModelDatabase(
                        nama: widget.strName,
                        size: widget.strSize,
                        ket: widget.strDesc,
                        jml_uang: widget.strPrice,
                        tgl_order: widget.strDate,
                        image_url: widget.strImage,
                      ),
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff1B100E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: const Text(
                    'CLOSE',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




// sekali animasi
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';

// import '../database/db_helper.dart';
// import '../model/model_database.dart';
// import 'page_home.dart';

// class PageSuccess extends StatefulWidget {
//   final String strSize;
//   final String strPrice;
//   final String strDesc;
//   final String strName;
//   final String strDate;
//   final String strImage;

//   const PageSuccess({
//     super.key,
//     required this.strSize,
//     required this.strPrice,
//     required this.strDesc,
//     required this.strName,
//     required this.strDate,
//     required this.strImage,
//   });

//   @override
//   State<PageSuccess> createState() => _PageSuccessState();
// }

// class _PageSuccessState extends State<PageSuccess> {
//   late DatabaseHelper dbHelper;

//   @override
//   void initState() {
//     super.initState();
//     dbHelper = DatabaseHelper.instance;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xfff8f8f8),
//       body: SafeArea(
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Lottie animation
//                 Lottie.asset(
//                   'assets/animations/success.json',
//                   width: 200,
//                   height: 200,
//                   repeat: false,
//                 ),
//                 const SizedBox(height: 20),

//                 Image.network(
//                   widget.strImage,
//                   height: 150,
//                 ),
//                 const SizedBox(height: 20),

//                 const Text(
//                   'Yay, your order is being processed!',
//                   style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'We are preparing your ${widget.strName} with care.',
//                   style: const TextStyle(fontSize: 13, color: Colors.grey),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 32),

//                 SizedBox(
//                   width: 200,
//                   height: 50,
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       await dbHelper.create(
//                         ModelDatabase(
//                           nama: widget.strName,
//                           size: widget.strSize,
//                           ket: widget.strDesc,
//                           jml_uang: widget.strPrice,
//                           tgl_order: widget.strDate,
//                           image_url: widget.strImage,
//                         ),
//                       );
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const HomePage()),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xff1B100E),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(50),
//                       ),
//                     ),
//                     child: const Text(
//                       'CLOSE',
//                       style: TextStyle(fontSize: 18, color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }








// import 'package:coba1/page/page_home.dart';
// import 'package:flutter/material.dart';

// import '../database/db_helper.dart';
// import '../model/model_database.dart';

// class PageSuccess extends StatefulWidget {
//   final String strSize;
//   final String strPrice;
//   final String strDesc;
//   final String strName;
//   final String strDate;
//   final String strImage;

//   const PageSuccess({super.key, required this.strSize,
//     required this.strPrice, required this.strDesc,
//     required this.strName, required this.strDate, required this.strImage});

//   @override
//   State<PageSuccess> createState() => _PageSuccessState();
// }

// class _PageSuccessState extends State<PageSuccess> {
//   late DatabaseHelper dbHelper;
//   String? strSize;
//   String? strPrice;
//   String? strDesc;
//   String? strName;
//   String? strDate;
//   String? strImage;

//   @override
//   void initState() {
//     super.initState();
//     dbHelper = DatabaseHelper.instance;
//     strSize = widget.strSize;
//     strPrice = widget.strPrice;
//     strDesc = widget.strDesc;
//     strName = widget.strName;
//     strDate = widget.strDate;
//     strImage = widget.strImage;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xfff8f8f8),
//       body: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.only(top: 70),
//             child: Column(
//               children: [
//                 Image.network(
//                   strImage.toString(),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 const Text(
//                   'Yay, the order is in progress for delivery ',
//                   style: TextStyle(fontSize: 20),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(
//                   height: 200,
//                 ),
//                 Align(
//                   alignment: Alignment.bottomCenter,
//                   child: SizedBox(
//                     height: 55,
//                     width: 260,
//                     child: ElevatedButton(
//                       onPressed: () async {
//                         await dbHelper.create(ModelDatabase(
//                           nama: strName,
//                           size: strSize,
//                           ket: strDesc,
//                           jml_uang: strPrice,
//                           tgl_order: strDate,
//                           image_url: strImage
//                         ));
//                         Navigator.push(context,
//                             MaterialPageRoute(builder: (context) {
//                               return const HomePage();
//                             })
//                         );
//                       },
//                       style: ButtonStyle(
//                           foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
//                           backgroundColor: WidgetStateProperty.all<Color>(const Color(0xff1B100E),),
//                           shape: WidgetStateProperty.all<RoundedRectangleBorder>(
//                               RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(50),
//                                   side: const BorderSide(color: Color(0xff1B100E))
//                               )
//                           )
//                       ),
//                       child: const Text(
//                         'CLOSE',
//                         style: TextStyle(fontSize: 20)
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )
//       ),
//     );
//   }
// }
