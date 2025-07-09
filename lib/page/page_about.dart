import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PageAbout extends StatelessWidget {
  const PageAbout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f8f8),
      appBar: AppBar(
        backgroundColor: const Color(0xfff8f8f8),
        elevation: 0,
        title: const Text(
          'About This App',
          style: TextStyle(
            color: Color(0xff2c2c2c),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xff1B100E)),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            'assets/animations/about.json', // letakkan animasi Lottie di folder ini
                            height: 200,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Coffee Ordering App',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff493628),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Halo! Kami dari Kelompok6, developer yang menyukai kopi dan teknologi.'
                            'Aplikasi ini saya buat sebagai media latihan sekaligus solusi untuk mempermudah pemesanan kopi secara online.'
                            'Dengan desain simpel dan fitur praktis, saya harap aplikasi ini bisa memberi pengalaman yang menyenangkan bagi pecinta kopi.'
                            'Terima kasih telah mencoba, dan jangan ragu beri masukan ya!',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff2c2c2c),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
