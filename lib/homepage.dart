import 'dart:convert';
import 'package:crud_flutter/editdata.dart';
import 'package:crud_flutter/tambahdata.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _listdata = [];
  List _searchResult = [];
  bool _isloading = true;
  String _searchText = '';

  Future _getdata() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.1.106/crud_api/read.php'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _listdata = data;
          _isloading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future _hapus(String id) async {
    try {
      final response = await http
          .post(Uri.parse('http://192.168.1.106/crud_api/hapus.php'), body: {
        "nim": id,
      });
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
    }
  }

  void _runFilter(String enteredKeyword) {
    List filteredList = [];
    if (enteredKeyword.isEmpty) {
      filteredList = _listdata;
    } else {
      filteredList = _listdata.where((data) {
        String namaMahasiswa = data['nama_mahasiswa'].toLowerCase();
        String nim = data['nim'].toLowerCase();
        return namaMahasiswa.contains(enteredKeyword.toLowerCase()) ||
            nim.contains(enteredKeyword.toLowerCase());
      }).toList();
    }

    setState(() {
      _searchText = enteredKeyword;
      _searchResult = filteredList;
    });
  }

  @override
  void initState() {
    _getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (value) => _runFilter(value),
              decoration: InputDecoration(
                labelText: 'Cari',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(25.0),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: _isloading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: _searchResult.length > 0
                        ? _searchResult.length
                        : _listdata.length,
                    itemBuilder: ((context, index) {
                      var data = _searchResult.length > 0
                          ? _searchResult[index]
                          : _listdata[index];
                      return Card(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => EditDataPage(
                                      ListData: {
                                        "id": data['id'],
                                        "nim": data['nim'],
                                        "nama_mahasiswa":
                                            data['nama_mahasiswa'],
                                        "alamat": data['alamat'],
                                      },
                                    )),
                              ),
                            );
                          },
                          child: ListTile(
                            title: Text(data['nama_mahasiswa']),
                            subtitle: Text(data['nim']),
                            trailing: IconButton(
                              onPressed: () {
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: ((context) {
                                    return AlertDialog(
                                      content: Text(
                                          "Apakah Yakin Kamu Akan Menghapus Data Ini?"),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Batal"),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            _hapus(data['nim']).then((value) {
                                              if (value) {
                                                const snackBar = SnackBar(
                                                  content: Text(
                                                      'Data Berhasil Dihapus'),
                                                );
                                              } else {
                                                const snackBar = SnackBar(
                                                  content: Text(
                                                      'Gagal Menghapus Data'),
                                                );
                                              }
                                            });
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    HomePage(),
                                              ),
                                              (route) => false,
                                            );
                                          },
                                          child: Text("Hapus"),
                                        ),
                                      ],
                                    );
                                  }),
                                );
                              },
                              icon: Icon(Icons.delete),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Text(
          "+",
          style: TextStyle(fontSize: 28),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => TambahDataPage()),
            ),
          );
        },
      ),
    );
  }
}
