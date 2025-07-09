import 'package:flutter/material.dart';
import '../page/page_see_all.dart';
import '../model/model_list_home.dart';
import '../page/page_order.dart';
import '../utils/tools.dart';

class FragmentHome extends StatefulWidget {
  const FragmentHome({super.key});

  @override
  State<FragmentHome> createState() => _FragmentHomeState();
}

class _FragmentHomeState extends State<FragmentHome> with TickerProviderStateMixin {
  final List<Map<String, dynamic>> categories = [
    {'label': 'New', 'icon': Icons.new_releases},
    {'label': 'Popular', 'icon': Icons.star},
    {'label': 'Recommended', 'icon': Icons.thumb_up},
  ];

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Image.asset(
                'assets/banner_coffee.jpg',
                width: size.width,
                height: size.height * 0.25,
                fit: BoxFit.fill,
              ),
            ),
          ),

          // Chips Centered & Animated
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: categories.asMap().entries.map((entry) {
                        int index = entry.key;
                        final category = entry.value;
                        final animation = Tween<double>(begin: 0.0, end: 1.0)
                            .animate(CurvedAnimation(
                          parent: _controller,
                          curve: Interval(0.1 * index, 1.0, curve: Curves.easeOut),
                        ));

                        return ScaleTransition(
                          scale: animation,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            child: Chip(
                              avatar: Icon(
                                category['icon'],
                                color: Colors.white,
                                size: 16,
                              ),
                              label: Text(
                                category['label'],
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor: const Color(0xFF493628),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ),
          ),

          _buildSectionHeader("All Items", showSeeAll: true),
          _buildListSection(
            future: ModelListHome.getListData(),
            size: size,
            showLoveIcon: false,
          ),
          const SizedBox(height: 30),
          _buildSectionHeader("New Items"),
          _buildListSection(
            future: ModelListHome.getNewData(),
            size: size,
          ),
          const SizedBox(height: 30),
          _buildSectionHeader("Popular Items"),
          _buildListSection(
            future: ModelListHome.getPopularData(),
            size: size,
          ),
          const SizedBox(height: 30),
          _buildSectionHeader("Recommended Items"),
          _buildListSection(
            future: ModelListHome.getRecommendedData(),
            size: size,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {bool showSeeAll = false}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xff493628),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          if (showSeeAll)
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const PageSeeAll(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(0.0, 1.0);
                      const end = Offset.zero;
                      const curve = Curves.ease;

                      final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                      final fadeTween = Tween<double>(begin: 0.0, end: 1.0);

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: FadeTransition(
                          opacity: animation.drive(fadeTween),
                          child: child,
                        ),
                      );
                    },
                  ),
                );
              },
              child: const Text(
                "See All",
                style: TextStyle(
                  color: Color(0xff493628),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildListSection({
    required Future<List<ModelListHome>> future,
    required Size size,
    bool showLoveIcon = false,
  }) {
    return FutureBuilder<List<ModelListHome>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return SizedBox(
              width: size.width,
              height: 150,
              child: Center(
                child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.red)),
              ),
            );
          }

          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return SizedBox(
              width: size.width,
              height: 150,
              child: const Center(
                child: Text(
                  "Ups, tidak ada data!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1B100E),
                  ),
                ),
              ),
            );
          }

          return SizedBox(
            height: 340,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final item = snapshot.data![index];
                double dPrice = double.tryParse(item.price.toString())?.ceilToDouble() ?? 0;
                double dTotal = dPrice * 16200;

                return SizedBox(
                  width: 180,
                  child: Card(
                    margin: const EdgeInsets.all(10),
                    clipBehavior: Clip.antiAlias,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Column(
                        children: [
                          Container(
                            width: size.width * 0.30,
                            height: 180,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(item.image_url.toString()),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10, top: 8),
                            child: Text(
                              item.name.toString(),
                              style: const TextStyle(
                                  color: Color(0xff1B100E),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              item.flavor_profile?.replaceAll('[', '').replaceAll(']', '') ?? '',
                              style: const TextStyle(color: Color(0xff1B100E), fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  CurrencyFormat.convertToIdr(dTotal),
                                  style: const TextStyle(
                                    color: Color(0xff1B100E),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OrderPage(
                                          modelListHome: item,
                                          dPrice: dTotal,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: const ShapeDecoration(
                                      shape: CircleBorder(),
                                      color: Color(0xFF493628),
                                    ),
                                    child: const Icon(Icons.add_outlined, color: Color(0xFFFFF4EA)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }

        return SizedBox(
          width: size.width,
          height: 150,
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xffdbb166)),
            ),
          ),
        );
      },
    );
  }
}











// import 'package:flutter/material.dart';

// import '../model/model_list_home.dart';
// import '../page/page_order.dart';
// import '../utils/tools.dart';

// class FragmentHome extends StatefulWidget {
//   const FragmentHome({super.key});

//   @override
//   State<FragmentHome> createState() => _FragmentHomeState();
// }

// class _FragmentHomeState extends State<FragmentHome> {
//   final List<String> _dynamicChips = ['Popular', 'Recommended', 'New'];

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;

//     return SingleChildScrollView(
//       physics: const BouncingScrollPhysics(),
//       padding: const EdgeInsets.only(bottom: 100),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Banner Image
//           Padding(
//             padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
//             child: ClipRRect(
//               borderRadius: const BorderRadius.all(Radius.circular(10)),
//               child: Image.asset(
//                 'assets/banner_coffee.jpg',
//                 width: size.width,
//                 height: size.height * 0.25,
//                 fit: BoxFit.fill,
//                 alignment: Alignment.center,
//               ),
//             ),
//           ),

//           // Bagian All Items dengan header tanpa ikon bintang dan tanpa See All, dan ada gambar love di pojok kiri atas gambar produk
//           _buildSectionHeader("All Items", showIconStar: false, showSeeAll: false),
//           _buildListSection(
//             future: ModelListHome.getListData(),
//             size: size,
//             showLoveIcon: true,
//           ),

//           const SizedBox(height: 30),

//           // Bagian Popular Items tanpa ikon bintang, tanpa See All, dan tanpa gambar love di produk
//           _buildSectionHeader("Popular Items", showIconStar: false, showSeeAll: false),
//           _buildListSection(
//             future: ModelListHome.getPopularData(),
//             size: size,
//             showLoveIcon: false,
//           ),

//           const SizedBox(height: 30),

//           // Bagian Recommended Items tanpa ikon bintang, tanpa See All, dan tanpa gambar love di produk
//           _buildSectionHeader("Recommended Items", showIconStar: false, showSeeAll: false),
//           _buildListSection(
//             future: ModelListHome.getRecommendedData(),
//             size: size,
//             showLoveIcon: false,
//           ),

//           const SizedBox(height: 30),

//           // Bagian New Items tanpa ikon bintang, tanpa See All, dan tanpa gambar love di produk
//           _buildSectionHeader("New Items", showIconStar: false, showSeeAll: false),
//           _buildListSection(
//             future: ModelListHome.getNewData(),
//             size: size,
//             showLoveIcon: false,
//           ),

//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }

//   // Widget header tiap section
//   // showIconStar = apakah menampilkan ikon bintang di depan tulisan
//   // showSeeAll = apakah menampilkan tombol See All di kanan header
//   Widget _buildSectionHeader(String title,
//       {bool showIconStar = true, bool showSeeAll = true}) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               if (showIconStar)
//                 const Icon(Icons.star_border, color: Color(0xff493628)),
//               if (showIconStar) const SizedBox(width: 4),
//               Text(title,
//                   style: const TextStyle(
//                       color: Color(0xff493628), fontWeight: FontWeight.bold)),
//             ],
//           ),
//           if (showSeeAll)
//             Text("See All",
//                 style: const TextStyle(
//                     color: Color(0xff493628), fontWeight: FontWeight.bold))
//         ],
//       ),
//     );
//   }

//   // Widget list produk horizontal
//   // showLoveIcon = apakah menampilkan ikon love di pojok kiri atas gambar produk
//   Widget _buildListSection({
//     required Future<List<ModelListHome>> future,
//     required Size size,
//     bool showLoveIcon = false,
//   }) {
//     return FutureBuilder<List<ModelListHome>>(
//       future: future,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           if (snapshot.hasError) {
//             return SizedBox(
//               width: size.width,
//               height: 150,
//               child: Center(
//                 child: Text(
//                   "Error: ${snapshot.error}",
//                   style: const TextStyle(color: Colors.red),
//                 ),
//               ),
//             );
//           }

//           if (snapshot.data == null || snapshot.data!.isEmpty) {
//             return SizedBox(
//               width: size.width,
//               height: 150,
//               child: const Center(
//                 child: Text(
//                   "Ups, tidak ada data!",
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xff1B100E),
//                     fontFamily: 'Chirp',
//                   ),
//                 ),
//               ),
//             );
//           } else {
//             return SizedBox(
//               height: 340,
//               child: ListView.builder(
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                 shrinkWrap: true,
//                 scrollDirection: Axis.horizontal,
//                 itemCount: snapshot.data!.length,
//                 itemBuilder: (context, index) {
//                   final item = snapshot.data![index];
//                   double dPrice =
//                       double.tryParse(item.price.toString())?.ceilToDouble() ?? 0;
//                   double dTotal = dPrice * 16200;

//                   return Stack(
//                     alignment: Alignment.topLeft,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(top: 5),
//                         child: SizedBox(
//                           width: 180,
//                           height: size.height,
//                           child: Card(
//                             margin: const EdgeInsets.all(10),
//                             clipBehavior: Clip.antiAlias,
//                             elevation: 5,
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10)),
//                             color: Colors.white,
//                             child: Padding(
//                               padding: const EdgeInsets.all(6),
//                               child: Column(
//                                 children: [
//                                   Container(
//                                     width: size.width * 0.30,
//                                     height: 180,
//                                     decoration: BoxDecoration(
//                                       image: DecorationImage(
//                                         fit: BoxFit.cover,
//                                         image:
//                                             NetworkImage(item.image_url.toString()),
//                                       ),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.only(bottom: 10),
//                                     child: Text(
//                                       item.name.toString(),
//                                       style: const TextStyle(
//                                           color: Color(0xff1B100E),
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.bold),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ),
//                                   Expanded(
//                                     child: Text(
//                                       item.flavor_profile
//                                           .toString()
//                                           .replaceAll('[', '')
//                                           .replaceAll(']', ''),
//                                       style: const TextStyle(
//                                           color: Color(0xff1B100E), fontSize: 14),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.only(top: 20),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Text(
//                                           CurrencyFormat.convertToIdr(dTotal),
//                                           style: const TextStyle(
//                                               color: Color(0xff1B100E),
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                         GestureDetector(
//                                           onTap: () {
//                                             Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                 builder: (context) => OrderPage(
//                                                   modelListHome: item,
//                                                   dPrice: dTotal,
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                           child: Container(
//                                             width: 30,
//                                             height: 30,
//                                             decoration: const ShapeDecoration(
//                                               shape: CircleBorder(),
//                                               color: Color(0xFF493628),
//                                             ),
//                                             child: const Icon(Icons.add_outlined,
//                                                 color: Color(0xFFFFF4EA)),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),

//                       // Tampilkan ikon love jika showLoveIcon true
//                       if (showLoveIcon)
//                         Container(
//                           width: 50,
//                           height: 50,
//                           decoration: const ShapeDecoration(
//                               shape: CircleBorder(), color: Color(0xFF493628)),
//                           child: const Icon(Icons.favorite_border,
//                               color: Color(0xFFFFF4EA)),
//                         ),
//                     ],
//                   );
//                 },
//               ),
//             );
//           }
//         } else if (snapshot.connectionState == ConnectionState.none) {
//           return SizedBox(
//               width: size.width,
//               height: 150,
//               child: Center(child: Text("${snapshot.error}")));
//         } else {
//           return SizedBox(
//             width: size.width,
//             height: 150,
//             child: const Center(
//               child: CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(Color(0xffdbb166))),
//             ),
//           );
//         }
//       },
//     );
//   }
// }





// import 'package:flutter/material.dart';

// import '../model/model_list_home.dart';
// import '../page/page_order.dart';
// import '../utils/tools.dart';

// class FragmentHome extends StatefulWidget {
//   const FragmentHome({super.key});

//   @override
//   State<FragmentHome> createState() => _FragmentHomeState();
// }

// class _FragmentHomeState extends State<FragmentHome> {
//   final List<String> _dynamicChips = ['Popular', 'Recommended', 'New', 'Season Special'];

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;

//     return SingleChildScrollView(
//       physics: const BouncingScrollPhysics(),
//       padding: const EdgeInsets.only(bottom: 100),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
//             child: ClipRRect(
//               borderRadius: const BorderRadius.all(Radius.circular(10)),
//               child: Image.asset(
//                 'assets/banner_coffee.jpg',
//                 width: size.width,
//                 height: size.height * 0.25,
//                 fit: BoxFit.fill,
//                 alignment: Alignment.center,
//               ),
//             ),
//           ),
//           SizedBox(
//             height: size.height * 0.05,
//             child: ListView.separated(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               scrollDirection: Axis.horizontal,
//               shrinkWrap: true,
//               itemCount: _dynamicChips.length,
//               separatorBuilder: (_, __) => SizedBox(width: size.width * 0.03),
//               itemBuilder: (_, index) => Chip(
//                 padding: const EdgeInsets.all(10),
//                 label: Text(_dynamicChips[index]),
//                 labelStyle: const TextStyle(color: Color(0xFFFFF4EA)),
//                 backgroundColor: const Color(0xFF493628),
//               ),
//             ),
//           ),
//           const Padding(
//             padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Icon(Icons.star_border, color: Color(0xff493628)),
//                     SizedBox(width: 4),
//                     Text("Popular Items",
//                         style: TextStyle(
//                             color: Color(0xff493628),
//                             fontWeight: FontWeight.bold
//                         )
//                     )
//                   ],
//                 ),
//                 Text("See All",
//                     style: TextStyle(
//                         color: Color(0xff493628),
//                         fontWeight: FontWeight.bold
//                     )
//                 )
//               ],
//             ),
//           ),
//           _buildListSection(
//             future: ModelListHome.getListData(), // ✅ hanya ini ditampilkan
//             size: size,
//           ),
//           const SizedBox(height: 20),
//           // ✅ Bagian getListDataAsc dihapus agar tidak duplikat
//         ],
//       ),
//     );
//   }

//   Widget _buildListSection({
//     required Future<List<ModelListHome>> future,
//     required Size size,
//   }) {
//     return FutureBuilder<List<ModelListHome>>(
//       future: future,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           if (snapshot.data!.isEmpty) {
//             return SizedBox(
//               width: size.height / 1.3,
//               height: size.width / 1.3,
//               child: const Center(
//                 child: Text(
//                   "Ups, tidak ada data!",
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xff1B100E),
//                     fontFamily: 'Chirp',
//                   ),
//                 ),
//               ),
//             );
//           } else {
//             return SizedBox(
//               height: 340,
//               child: ListView.builder(
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                 shrinkWrap: true,
//                 scrollDirection: Axis.horizontal,
//                 itemCount: snapshot.data!.length,
//                 itemBuilder: (context, index) {
//                   final item = snapshot.data![index];
//                   double dPrice = double.tryParse(item.price.toString())?.ceilToDouble() ?? 0;
//                   double dTotal = dPrice * 16200;

//                   return Stack(
//                     alignment: Alignment.topLeft,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(top: 5),
//                         child: SizedBox(
//                           width: 180,
//                           height: size.height,
//                           child: Card(
//                             margin: const EdgeInsets.all(10),
//                             clipBehavior: Clip.antiAlias,
//                             elevation: 5,
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10)),
//                             color: Colors.white,
//                             child: Padding(
//                               padding: const EdgeInsets.all(6),
//                               child: Column(
//                                 children: [
//                                   Container(
//                                     width: size.width * 0.30,
//                                     height: 180,
//                                     decoration: BoxDecoration(
//                                       image: DecorationImage(
//                                         fit: BoxFit.cover,
//                                         image: NetworkImage(item.image_url.toString()),
//                                       ),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.only(bottom: 10),
//                                     child: Text(
//                                       item.name.toString(),
//                                       style: const TextStyle(
//                                           color: Color(0xff1B100E),
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.bold),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ),
//                                   Expanded(
//                                     child: Text(
//                                       item.flavor_profile.toString().replaceAll('[', '').replaceAll(']', ''),
//                                       style: const TextStyle(
//                                           color: Color(0xff1B100E), fontSize: 14),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.only(top: 20),
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Text(
//                                           CurrencyFormat.convertToIdr(dTotal),
//                                           style: const TextStyle(
//                                               color: Color(0xff1B100E),
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                         GestureDetector(
//                                           onTap: () {
//                                             Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                 builder: (context) => OrderPage(
//                                                   modelListHome: item,
//                                                   dPrice: dTotal,
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                           child: Container(
//                                             width: 30,
//                                             height: 30,
//                                             decoration: const ShapeDecoration(
//                                               shape: CircleBorder(),
//                                               color: Color(0xFF493628),
//                                             ),
//                                             child: const Icon(Icons.add_outlined,
//                                                 color: Color(0xFFFFF4EA)),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Container(
//                         width: 50,
//                         height: 50,
//                         decoration: const ShapeDecoration(
//                             shape: CircleBorder(), color: Color(0xFF493628)),
//                         child: const Icon(Icons.favorite_border,
//                             color: Color(0xFFFFF4EA)),
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             );
//           }
//         } else if (snapshot.connectionState == ConnectionState.none) {
//           return SizedBox(
//               width: size.height / 1.3,
//               height: size.width / 1.3,
//               child: Center(child: Text("${snapshot.error}")));
//         } else {
//           return SizedBox(
//             width: size.height / 1.3,
//             height: size.width / 1.3,
//             child: const Center(
//               child: CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(Color(0xffdbb166))),
//             ),
//           );
//         }
//       },
//     );
//   }
// }





// import 'package:flutter/material.dart';

// import '../model/model_list_home.dart';
// import '../page/page_order.dart';
// import '../utils/tools.dart';

// class FragmentHome extends StatefulWidget {
//   const FragmentHome({super.key});

//   @override
//   State<FragmentHome> createState() => _FragmentHomeState();
// }

// class _FragmentHomeState extends State<FragmentHome> {
//   final List<String> _dynamicChips = ['Popular', 'Recommended', 'New', 'Season Special'];

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;

//     return SingleChildScrollView(
//       physics: const BouncingScrollPhysics(),
//       padding: const EdgeInsets.only(bottom: 100),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
//             child: ClipRRect(
//               borderRadius: const BorderRadius.all(Radius.circular(10)),
//               child: Image.asset(
//                 'assets/banner_coffee.jpg',
//                 width: size.width,
//                 height: size.height * 0.25,
//                 fit: BoxFit.fill,
//                 alignment: Alignment.center,
//               ),
//             ),
//           ),
//           SizedBox(
//             height: size.height * 0.05,
//             child: ListView.separated(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               scrollDirection: Axis.horizontal,
//               shrinkWrap: true,
//               itemCount: _dynamicChips.length,
//               separatorBuilder: (_, __) => SizedBox(width: size.width * 0.03),
//               itemBuilder: (_, index) => Chip(
//                 padding: const EdgeInsets.all(10),
//                 label: Text(_dynamicChips[index]),
//                 labelStyle: const TextStyle(color: Color(0xFFFFF4EA)),
//                 backgroundColor: const Color(0xFF493628),
//               ),
//             ),
//           ),
//           const Padding(
//             padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Icon(Icons.star_border, color: Color(0xff493628)),
//                     SizedBox(width: 4),
//                     Text("Popular Items",
//                         style: TextStyle(
//                             color: Color(0xff493628),
//                             fontWeight: FontWeight.bold
//                         )
//                     )
//                   ],
//                 ),
//                 Text("See All",
//                     style: TextStyle(
//                         color: Color(0xff493628),
//                         fontWeight: FontWeight.bold
//                     )
//                 )
//               ],
//             ),
//           ),
//           _buildListSection(
//             future: ModelListHome.getListData(),
//             size: size,
//           ),
//           const SizedBox(height: 20),
//           _buildListSection(
//             future: ModelListHome.getListDataAsc(),
//             size: size,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildListSection({
//     required Future<List<ModelListHome>> future,
//     required Size size,
//   }) {
//     return FutureBuilder<List<ModelListHome>>(
//       future: future,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           if (snapshot.data!.isEmpty) {
//             return SizedBox(
//               width: size.height / 1.3,
//               height: size.width / 1.3,
//               child: const Center(
//                 child: Text(
//                   "Ups, tidak ada data!",
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xff1B100E),
//                     fontFamily: 'Chirp',
//                   ),
//                 ),
//               ),
//             );
//           } else {
//             return SizedBox(
//               height: 340,
//               child: ListView.builder(
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                 shrinkWrap: true,
//                 scrollDirection: Axis.horizontal,
//                 itemCount: snapshot.data!.length,
//                 itemBuilder: (context, index) {
//                   final item = snapshot.data![index];
//                   double dPrice = double.tryParse(item.price.toString())?.ceilToDouble() ?? 0;
//                   double dTotal = dPrice * 16200;

//                   return Stack(
//                     alignment: Alignment.topLeft,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(top: 5),
//                         child: SizedBox(
//                           width: 180,
//                           height: size.height,
//                           child: Card(
//                             margin: const EdgeInsets.all(10),
//                             clipBehavior: Clip.antiAlias,
//                             elevation: 5,
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10)),
//                             color: Colors.white,
//                             child: Padding(
//                               padding: const EdgeInsets.all(6),
//                               child: Column(
//                                 children: [
//                                   Container(
//                                     width: size.width * 0.30,
//                                     height: 180,
//                                     decoration: BoxDecoration(
//                                       image: DecorationImage(
//                                         fit: BoxFit.cover,
//                                         image: NetworkImage(item.image_url.toString()),
//                                       ),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.only(bottom: 10),
//                                     child: Text(
//                                       item.name.toString(),
//                                       style: const TextStyle(
//                                           color: Color(0xff1B100E),
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.bold),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ),
//                                   Expanded(
//                                     child: Text(
//                                       item.flavor_profile.toString().replaceAll('[', '').replaceAll(']', ''),
//                                       style: const TextStyle(
//                                           color: Color(0xff1B100E), fontSize: 14),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.only(top: 20),
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Text(
//                                           CurrencyFormat.convertToIdr(dTotal),
//                                           style: const TextStyle(
//                                               color: Color(0xff1B100E),
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                         GestureDetector(
//                                           onTap: () {
//                                             Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                 builder: (context) => OrderPage(
//                                                   modelListHome: item,
//                                                   dPrice: dTotal,
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                           child: Container(
//                                             width: 30,
//                                             height: 30,
//                                             decoration: const ShapeDecoration(
//                                               shape: CircleBorder(),
//                                               color: Color(0xFF493628),
//                                             ),
//                                             child: const Icon(Icons.add_outlined,
//                                                 color: Color(0xFFFFF4EA)),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Container(
//                         width: 50,
//                         height: 50,
//                         decoration: const ShapeDecoration(
//                             shape: CircleBorder(), color: Color(0xFF493628)),
//                         child: const Icon(Icons.favorite_border,
//                             color: Color(0xFFFFF4EA)),
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             );
//           }
//         } else if (snapshot.connectionState == ConnectionState.none) {
//           return SizedBox(
//               width: size.height / 1.3,
//               height: size.width / 1.3,
//               child: Center(child: Text("${snapshot.error}")));
//         } else {
//           return SizedBox(
//             width: size.height / 1.3,
//             height: size.width / 1.3,
//             child: const Center(
//               child: CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(Color(0xffdbb166))),
//             ),
//           );
//         }
//       },
//     );
//   }
// }
