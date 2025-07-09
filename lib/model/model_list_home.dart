import 'dart:convert';
import 'package:http/http.dart' as http;

class ModelListHome {
  String? name;
  String? image_url;
  String? flavor_profile;
  String? price;
  String? description;

  ModelListHome(
      {this.name,
      this.image_url,
      this.flavor_profile,
      this.price,
      this.description});

  ModelListHome.fromJson(Map<String, dynamic> json) {
    name = json['name'].toString();
    image_url = json['image_url'].toString();
    flavor_profile = json['flavor_profile'].toString();
    price = json['price'].toString();
    description = json['description'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name;
    data['image_url'] = this.image_url;
    data['flavor_profile'] = this.flavor_profile;
    data['price'] = this.price;
    data['description'] = this.description;
    return data;
  }

  static Future<List<ModelListHome>> getListData() async {
    final apiURL = Uri.parse(
        'https://mtesfqvpkbecgjqpwaem.supabase.co/rest/v1/moroccan_teas');
    final response = await http.get(
      apiURL,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im10ZXNmcXZwa2JlY2dqcXB3YWVtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc5MjEwMTgsImV4cCI6MjA2MzQ5NzAxOH0.IETlYFBjiM14-oGP3eEv5iH9MoVdjqIg9J5wMjDhZ3g',
        'Content-Type': 'application/json',
      },
    );

    List list = jsonDecode(response.body);
    List<ModelListHome> data = list.map((e) => ModelListHome.fromJson(e)).toList();

    // Urutkan berdasarkan nama A-Z
    data.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));

    return data; // Ambil 10 data pertama
  }


  static Future<List<ModelListHome>> getPopularData() async {
    final allData = await getListData();
    return allData.take(4).toList(); // Ambil 4 pertama sebagai Popular
  }

  static Future<List<ModelListHome>> getRecommendedData() async {
    final allData = await getListData();
    return allData.skip(4).take(6).toList(); // Ambil 6 berikutnya
  }

  static Future<List<ModelListHome>> getNewData() async {
    final allData = await getListData();
    return allData
        .skip(10)
        .take(4)
        .toList(); // Ambil 4 berikutnya (index 10-13)
  }
}


// static Future<List<ModelListHome>> getListDataAsc() async {
  //   //var apiURL = Uri.parse('https://fake-coffee-api.vercel.app/api?sort=asc'); //API nya error 500
  //   var apiURL =
  //       Uri.parse('https://tea-api-gules.vercel.app/api'); //sementara pake ini
  //   final jsonData = await http.get(apiURL);
  //   List list = jsonDecode(jsonData.body);
  //   return list.map((e) => ModelListHome.fromJson(e)).toList();
  // }