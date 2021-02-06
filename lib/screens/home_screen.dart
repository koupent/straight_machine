import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:soundpool/soundpool.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> _textList = [
    "おめでとうございます",
    "合格です",
    "よくできました",
    "残念でした",
    "不合格です",
    "頑張りましょう"
  ];

  List<int> _soundIds = [0, 0, 0, 0, 0, 0];

  Soundpool _soundpool; //インスタンスはクラス全体で使いたいのでここで宣言

  //画面の初回起動時の処理
  @override
  void initState() {
    super.initState(); //継承元のメソッドの処理も使う場合
    _initSounds(); //音声をメモリーにロードする処理
  }

  //音声をメモリーにロードする処理
  Future<void> _initSounds() async {
    try {
      _soundpool = Soundpool(); //インスタンス作成

      _soundIds[0] = await loadSound("assets/sounds/sound1.mp3");
      _soundIds[1] = await loadSound("assets/sounds/sound2.mp3");
      _soundIds[2] = await loadSound("assets/sounds/sound3.mp3");
      _soundIds[3] = await loadSound("assets/sounds/sound4.mp3");
      _soundIds[4] = await loadSound("assets/sounds/sound5.mp3");
      _soundIds[5] = await loadSound("assets/sounds/sound6.mp3");

      //initStateでは非同期処理ができない。
      // 加えて、音声をロードする前にbuild()処理が終わってしまうので、音声がならない。
      // それらを解決するため、build()を呼び出す処理を後付で実行
      setState(() {});
    } on IOException catch (error) {
      print("エラーの内容は：$error");
    }
  }

  Future<int> loadSound(String soundPath) {
    return rootBundle.load(soundPath).then((value) => _soundpool.load(value));
  }

  //画面の破棄時の処理
  @override
  void dispose() {
    _soundpool.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("つっこみマシーン"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                      flex: 1, child: _soundButton(_textList[0], _soundIds[0])),
                  Expanded(
                      flex: 1, child: _soundButton(_textList[1], _soundIds[1])),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                      flex: 1, child: _soundButton(_textList[2], _soundIds[2])),
                  Expanded(
                      flex: 1, child: _soundButton(_textList[3], _soundIds[3])),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                      flex: 1, child: _soundButton(_textList[4], _soundIds[4])),
                  Expanded(
                      flex: 1, child: _soundButton(_textList[5], _soundIds[5])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _soundButton(String displayText, int soundId) {
    return Container(
        padding: EdgeInsets.all(8.0),
        child: RaisedButton(
          color: Colors.green,
          onPressed: () => _playSound(soundId),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          child: Text(
            displayText,
            style: TextStyle(color: Colors.white),
          ),
        ));
  }

  void _playSound(int soundId) {
    _soundpool.play(soundId);
  }
}
