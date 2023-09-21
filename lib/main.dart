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
          String abc=First.prefs!.getString("level_status$index") ?? "";
          return InkWell(
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) {
                  return Home(index);
                },
              ));
            },
            child: Container(
              color:  (abc=="yes")? Colors.grey : Colors.yellow,
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
  PageController ?controller;
  List logo = [
    Icons.alarm,
    Icons.ac_unit_outlined,
    Icons.accessible_sharp,
    Icons.account_circle_rounded
  ];
  List temp = [];
  List ans = ["ONEqq", "TWO", "THREE", "FOUR"];
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
   get();
  }
  get()
  {
    print("Levelno$levelNo");

    user_ans = List.filled(ans[levelNo].toString().length, '');
    temp = List.filled(user_ans.length, "");
    for (int i = 0; i < ans[levelNo].toString().length; i++) {
      option.add(ans[levelNo][i]);
    }
    atoz.shuffle();
    for (int i = ans[levelNo].toString().length; i < 14; i++) {
      option.add(atoz[i]);
    }
    option.shuffle();
    controller=PageController(initialPage: levelNo);
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
          levelNo=value;
          print(levelNo);
          get();
          setState(() {

          });
        },
        itemBuilder: (context, index) {
          String abc=First.prefs!.getString("level_status$levelNo") ?? "";
          return (abc=="yes") ?  Center(child: Text("Win"),) : Column(
            children: [
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
                              temp[index]="";
                              user_ans[index] = "";
                              setState(() {});
                            },
                          )),
                    ),
                    color: Colors.blue,
                  )),
              Expanded(
                  child: Container(
                    child: Row(children: [
                      ElevatedButton(onPressed: () {
                        print(temp);
                        for(int i=0;i<temp.length;i++){
                          if(temp[i]!=''){
                            option[temp[i]]=user_ans[i];
                            user_ans[i]="";
                          }
                        }
                        setState(() {

                        });
                      }, child: Text("All")),
                      ElevatedButton(onPressed: () {
                        // print(temp);
                        for(int i=temp.length-1;i>=0;i--)
                        {
                          //  print(i);
                          if(temp[i]!=''){
                            print(temp[i]);
                            option[temp[i]]=user_ans[i];
                            temp[i]="";
                            user_ans[i]="";
                            break;
                          }
                        }
                        setState(() {

                        });
                      }, child: Text("Last"))
                    ],),
                    color: Colors.yellow,
                  )),
              Expanded(
                  child: Container(
                    child: Wrap(
                        alignment: WrapAlignment.center,
                        children: List.generate(
                            option.length,
                                (index) => InkWell(
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
                            ))),
                    color: Colors.green,
                  )),
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
