import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ttgame/state_data.dart';
import './state_data.dart';


void main() => runApp(Provider<StateData>(
          create: (BuildContext context) => StateData(),
          child: PageA()));

//String isim = "Kullanıcı";

class MesajBalonu extends StatelessWidget {
  var mesaj;
  @override
  MesajBalonu({required this.mesaj});

  Widget build(BuildContext context) {
    String sehir = Provider.of<StateData>(context).isim;
    return Container(
      margin: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            child: Text(sehir[0]),
          ),
          SizedBox(
            width: 13,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("$sehir"),
                SizedBox(
                  height: 4,
                ),
                Text(mesaj),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PageA extends StatelessWidget {
  const PageA({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Tuttu-Tutmadı",
      home: Iskele(),
    );
  }
}

class Iskele extends StatelessWidget {
  const Iskele({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Center(child: Text("Tuttu-Tutmadı")),
      ),
      body: AnaEkran(),
    );
  }
}


class AnaEkran extends StatefulWidget {
  const AnaEkran({Key? key}) : super(key: key);

  @override
  _AnaEkranState createState() => _AnaEkranState();
}

class _AnaEkranState extends State<AnaEkran> {
  //final ValueNotifier<String> _username = ValueNotifier<String>("Kullanıcı");
  int skor = 0;

  TextEditingController t1 = TextEditingController();

  List<MesajBalonu> mesajListesi = [];

  listeyeEkle(String gelenMesaj) {
    showAlertDialog(BuildContext context) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),

              //title: Text("Title"),
              content: Text("Tuttu Tutmadı ile başlayan bir şey yazmalısın!"),
              actions: [
                MaterialButton(
                  shape: StadiumBorder(),
                  color: Colors.blueAccent,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Anladım"),
                )
              ],
            );
          });
    }

    setState(() {
      MesajBalonu mesajNesnesi = MesajBalonu(mesaj: gelenMesaj);
      // gelenMesaj ulaşmaya çalış
      mesajListesi.insert(0, mesajNesnesi);
      t1.clear();
      if (gelenMesaj.isEmpty && gelenMesaj.length < 5) {
        return showAlertDialog(
          context,
        );
      } else if (gelenMesaj.toLowerCase().substring(0, 5) == "tuttu") {
        //print("Tuttu");
        skor++;
      } else {
        //print("Tutmadı");
        skor--;
      }
    });
  }

  Widget metinGirisAlani() {
    FocusNode focusNode = FocusNode();
    return Container(
      margin: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: RawKeyboardListener(
                focusNode: focusNode,
                onKey: (event) {
                  if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
                    listeyeEkle(t1.text);
                  }
                },
                child: TextFormField(
                  maxLength: 150,
                  decoration: InputDecoration(
                    hintText: "Yaz Bir Şeyler",
                    prefixIcon: Icon(Icons.edit),
                  ),
                  controller: t1,
                  onChanged: (value) {},
                  onEditingComplete: () {},
                ),
              ),
            ),
          ),
          IconButton(
              onPressed: () => listeyeEkle(t1.text), icon: Icon(Icons.send)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                width: 150,
                height: 23,
                color: Colors.yellowAccent,
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        "SKOR: $skor ",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          TextFormField(
            onSaved: (value) {
              var username = value;
            },
            decoration: InputDecoration(
              hintText: "Your User Name",
              fillColor: Colors.blueAccent,
              filled: true,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 3,
                  )),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: BorderSide(color: Colors.blue, width: 5)),
            ),
          ),
          Divider(thickness: 1),
          Flexible(
            child: ListView.builder(
                reverse: true,
                itemCount: mesajListesi.length,
                itemBuilder: (_, indeksNumarasi) =>
                    mesajListesi[indeksNumarasi]),
          ),
          Divider(thickness: 1),
          metinGirisAlani(),
        ],
      ),
    );
  }
}

