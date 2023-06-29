import 'package:crud_flutter/homepage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditDataPage extends StatefulWidget {
  final Map ListData;
  const EditDataPage({super.key, required this.ListData});

  @override
  State<EditDataPage> createState() => _EditDataPageState();
}

class _EditDataPageState extends State<EditDataPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController id = TextEditingController();
  TextEditingController nim = TextEditingController();
  TextEditingController nama_mahasiswa = TextEditingController();
  TextEditingController alamat = TextEditingController();
  Future _update() async {
    final respone = await http
        .post(Uri.parse('http://192.168.1.106/crud_api/edit.php'), body: {
      "id": id.text,
      "nim": nim.text,
      "nama_mahasiswa": nama_mahasiswa.text,
      "alamat": alamat.text,
    });
    if (respone.statusCode == 200) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    id.text = widget.ListData["id"];
    nim.text = widget.ListData["nim"];
    nama_mahasiswa.text = widget.ListData["nama_mahasiswa"];
    alamat.text = widget.ListData["alamat"];
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Data"),
      ),
      body: Form(
          key: formKey,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                TextFormField(
                  controller: nim,
                  decoration: InputDecoration(
                    hintText: "Nomor Induk Mahasiswa",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Nomor Induk Mahasiswa Tidak Boleh Kosong";
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: nama_mahasiswa,
                  decoration: InputDecoration(
                    hintText: "Nama Lengkap Mahasiswa",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Nama Lengkap Mahasiswa Tidak Boleh Kosong";
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: alamat,
                  decoration: InputDecoration(
                    hintText: "Alamat Mahasiswa",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Alamat Mahasiswa Tidak Boleh Kosong";
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        _update().then((value) {
                          if (value) {
                            const snackBar = SnackBar(
                              content: Text('Data Berhasil Diubah'),
                            );
                          } else {
                            const snackBar = SnackBar(
                              content: Text('Gagal Mengubah Data'),
                            );
                          }
                        });
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                            (route) => false);
                      }
                    },
                    child: Text("Ubah"))
              ],
            ),
          )),
    );
  }
}
