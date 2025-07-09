import 'package:coba13/fragment/fragment_history.dart';
import 'package:coba13/fragment/fragment_home.dart';
import 'package:flutter/material.dart';
import 'package:coba13/page/page_about.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController _tabController;

  static const List<Widget> _bodyView = [FragmentHome(), FragmentHistory()];

  final List<String> _labels = ['For You', 'History Order'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _bodyView.length);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> icons = const [Icon(Icons.coffee), Icon(Icons.history_edu)];

    return Scaffold(
      backgroundColor: const Color(0xfff8f8f8),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xfff8f8f8),
        centerTitle: true,
        title: const Text(
          "Coffee",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xff2c2c2c),
          ),
        ),
        // leading: IconButton(
        //   onPressed: () {},
        //   icon: const Icon(
        //     Icons.coffee_maker_outlined,
        //     color: Color(0xff1B100E),
        //   ),
        // ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PageAbout()),
              );
            },
            icon: const Icon(Icons.info_outline, color: Color(0xff1B100E)),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                bottom: 70,
              ), // Ruang aman untuk nav
              child: _bodyView[_selectedIndex],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 60, // ✅ Ubah tinggi tab bar
                padding: const EdgeInsets.symmetric(horizontal: 12),
                margin: const EdgeInsets.only(bottom: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Container(
                    color: const Color(0xFF493628),
                    child: TabBar(
                      onTap: (index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      controller: _tabController,
                      labelColor: Colors.white,
                      unselectedLabelColor: const Color(0xFFFFF4EA),
                      indicator: const UnderlineTabIndicator(
                        borderSide: BorderSide.none,
                      ),
                      tabs: List.generate(
                        icons.length,
                        (i) => _tabItem(
                          icons[i],
                          _labels[i],
                          isSelected: i == _selectedIndex,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _tabItem(Widget icon, String label, {bool isSelected = false}) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 300),
    margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
    decoration: isSelected
        ? BoxDecoration(
            color: const Color(0xFFDFA878),
            borderRadius: BorderRadius.circular(12),
          )
        : null,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconTheme(data: const IconThemeData(size: 20), child: icon),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );
}




// Widget _tabItem(Widget child, String label, {bool isSelected = false}) {
//   return AnimatedContainer(
//       margin: const EdgeInsets.all(8),
//       alignment: Alignment.center,
//       duration: const Duration(milliseconds: 500),
//       decoration: !isSelected
//           ? null
//           : BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         color: const Color(0xFFDFA878),
//       ),
//       padding: const EdgeInsets.all(10),
//       child: Column(
//         children: [
//           child,
//           Text(label, style: const TextStyle(fontSize: 12)),
//         ],
//       )
//   );
// }