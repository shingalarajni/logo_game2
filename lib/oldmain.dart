import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    home: First(),
  ));
}

class First extends StatefulWidget {
  static SharedPreferences? prefs;

  @override
  State<First> createState() => _FirstState();
}

class _FirstState extends State<First> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get();
  }

  get() async {
    First.prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        itemCount: 12,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, crossAxisSpacing: 5, mainAxisSpacing: 5),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) {
                  return Home(index);
                },
              ));
            },
            child: Container(
              color: (First.prefs!.getString("level_status$index")=="yes") ? Colors.grey : Colors.yellow,
              child: Text("$index"),
            ),
          );
        },
      ),
    );
  }
}

class Home extends StatefulWidget {
  int level;

  Home(this.level);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageController? controller;
  List logo = [
    Icons.alarm,
    Icons.ac_unit_outlined,
    Icons.accessible_sharp,
    Icons.account_circle_rounded
  ];
  List temp = [];
  List ans = [
    "ONE",
    "TWO",
    "THREE",
    "FOUR",
    "FIVE",
    "SIX",
    "SEVEN",
    "EIGHT",
    "NINE",
    "TEN"
  ];
  List option = [];
  List user_ans = [];
  int levelNo = 0;
  List atoz = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V'
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    levelNo = widget.level;
    print("Levelno$levelNo");
    temp = List.filled(14, "");
    option = List.filled(14, "");
    user_ans = List.filled(ans[levelNo].toString().length, '');
    for (int i = 0; i < ans[levelNo].toString().length; i++) {
      option[i] = ans[levelNo][i];
    }
    atoz.shuffle();
    for (int i = ans[levelNo].toString().length; i < 14; i++) {
      option[i] = atoz[i];
    }
    option.shuffle();
    controller = PageController(initialPage: levelNo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Logo Game"),
      ),
      body: PageView.builder(
        controller: controller,
        itemCount: ans.length,
        onPageChanged: (value) {
          levelNo = value;
          print(levelNo);
          print("Levelno$levelNo");
          temp = List.filled(14, "");
          user_ans = List.filled(ans[levelNo].toString().length, '');
          for (int i = 0; i < ans[levelNo].toString().length; i++) {
            option[i] = ans[levelNo][i];
          }
          atoz.shuffle();
          for (int i = ans[levelNo].toString().length; i < 14; i++) {
            option[i] = atoz[i];
          }
          option.shuffle();
          controller = PageController(initialPage: levelNo);
          setState(() {});
        },
        itemBuilder: (context, index) {
          return (First.prefs!.getString("level_status$levelNo")=="yes") ?  Center(child: Text("Win"),) : Column(
            children: [
              Text(
                "Ans : ${ans[levelNo]}",
                style: TextStyle(fontSize: 30),
              ),
              Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    color: Colors.red,
                    child: Icon(logo[0]),
                  )),
              Expanded(
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: List.generate(
                          user_ans.length,
                              (index) => InkWell(
                            child: Container(
                              width: 50,
                              alignment: Alignment.center,
                              child: Text(
                                user_ans[index],
                                style: TextStyle(color: Colors.white),
                              ),
                              height: 50,
                              color: Colors.black,
                              margin: EdgeInsets.all(5),
                            ),
                            onTap: () {
                              option[temp[index]] = user_ans[index];
                              user_ans[index] = "";
                              setState(() {});
                            },
                          )),
                    ),
                    color: Colors.blue,
                  )),
              Expanded(
                  child: Container(
                    color: Colors.yellow,
                  )),
              Expanded(
                  flex: 2,
                  child: Container(
                    child: GridView.builder(
                      itemCount: 14,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5),
                      itemBuilder: (context, index) {
                        return InkWell(
                          child: Container(
                            width: 50,
                            alignment: Alignment.center,
                            child: Text(
                              option[index],
                              style: TextStyle(color: Colors.white),
                            ),
                            height: 50,
                            color: Colors.black,
                            margin: EdgeInsets.all(5),
                          ),
                          onTap: () {
                            if (option[index] != '') {
                              for (int i = 0; i < user_ans.length; i++) {
                                if (user_ans[i] == '') {
                                  user_ans[i] = option[index];
                                  temp[i] = index;
                                  option[index] = "";
                                  checkwin();
                                  break;
                                }
                                print(temp);
                              }
                            }

                            setState(() {});
                          },
                        );
                      },
                    ),
                    color: Colors.green,
                  )),
              Expanded(child: Text(" "))
            ],
          );
        },
      ),
    );
  }

  checkwin() {
    String win_ans = user_ans.join("");
    print(win_ans);
    print(ans[levelNo]);
    if (ans[levelNo] == win_ans) {
      First.prefs!.setString("level_status$levelNo", "yes");
      levelNo++;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("You win this level"),
            actions: [
              TextButton(
                  onPressed: () {
                    //  controller!.jumpToPage(levelNo);
                    Navigator.pop(context);
                    controller!.animateToPage(levelNo,
                        duration: Duration(seconds: 2), curve: Curves.linear);
                    setState(() {});
                  },
                  child: Text("Next Level"))
            ],
          );
        },
      );
    }
  }
}
