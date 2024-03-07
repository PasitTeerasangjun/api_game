import 'package:api_game/game.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class Tablegame extends StatefulWidget {
  const Tablegame({super.key});

  @override
  State<Tablegame> createState() => _TableState();
}

class _TableState extends State<Tablegame> {
  List<list_game>? _data;

  // เมธอดสำหรับโหลดข้อมูล
  void _getgame() async {
    var dio = Dio(BaseOptions(responseType: ResponseType.plain));
    var response =
        await dio.get('https://api.sampleapis.com/playstation/games');

    setState(() {
      var list = jsonDecode(response.data.toString());

      _data = list.map<list_game>((item) {
        return list_game(
          name: item['name'],
          genre: List<String>.from(item['genre']),
          developers: List<String>.from(item['developers']),
          publishers: List<String>.from(item['publishers']),
          releasejapan: item['releaseDates']['Japan'],
          releasenorthamerica: item['releaseDates']['NorthAmerica'],
          releaseeurope: item['releaseDates']['Europe'],
          releaseaustralia: item['releaseDates']['Australia'],
          
        );
      }).toList();
        // เรียงลำดับตามชื่อจาก A ไป Z (กรณีต้องการเรียงลำดับ)
      _data!.sort((a, b) => a.name!.compareTo(b.name!));
    });
  }

  @override
  void initState() {
    super.initState();
    // เรียกเมธอดสำหรับโหลดข้อมูลใน initState() ของคลาสที่ extends มาจาก State
    _getgame();
  }

  Future<void> _showinfo(list_game data) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(data.name ?? ''),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text("Release in Japan : ${data.releasejapan}" ?? ''),
              Text("Release in NorthAmerica : ${data.releasenorthamerica}" ?? ''),
              Text("Release in Europe : ${data.releaseeurope}" ?? ''),
              Text("Release in Australia : ${data.releaseaustralia}" ?? ''),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
  @override
  Widget build(BuildContext context) {
    Widget _buildPageBody() {
      return Column(
        children: [
          Expanded(
            child: _data == null
                ? SizedBox.shrink()
                : ListView.builder(
                    itemCount: _data!.length,
                    itemBuilder: (context, index) {
                      var data = _data![index];

                      String _genre=
                          data.genre != null && data.genre!.isNotEmpty
                              ? data.genre!.join(', ')
                              : 'Unknown Genre';

                      String _developers=
                          data.developers != null && data.developers!.isNotEmpty
                              ? data.developers!.join(', ')
                              : 'Unknown Developers';

                      return ListTile(
                        title: Text("Name : ${data.name}" ?? ''),
                        subtitle: Text(_genre),
                        trailing: Text("Developers : ${_developers}"),
                        onTap: () {
                          _showinfo(data);
                        },
                      );
                    },
                  ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Classroom')),
      ),
      body: Center(
        child: _buildPageBody(),
      ),
    );
  }
}
