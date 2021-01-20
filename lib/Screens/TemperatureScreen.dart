import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartpetcare/Constants/size_config.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:firebase_database/firebase_database.dart';

class TemperatureScreen extends StatefulWidget {
  @override
  _TemperatureScreenState createState() => _TemperatureScreenState();
}

class _TemperatureScreenState extends State<TemperatureScreen> {
  static final databaseReferenceTest = FirebaseDatabase.instance.reference();
  var temp;
  var data = databaseReferenceTest.child('Temperature');
  bool heaterOn = true;
  bool heaterOff = false;
  bool fanOn = true;
  bool fanOff = false;
  double progress = 0.2;

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
          child: Scaffold(
            body: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xffF3CE69),
                        Color(0xffFFB843)
                      ]
                  )
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Smart Pet Care',
                        style: GoogleFonts.robotoMono(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: SizeConfig.textMultiplier * 4
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: SizeConfig.isMobilePortrait ? 6 : 4,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xff393733),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50)
                          )
                      ),
                      child: ListView(
                        children: [
                          SizedBox(
                              height: SizeConfig.heightMultiplier * 12
                          ),
                          Container(
                              child: StreamBuilder(
                                  stream: data.onValue,
                                  builder: (context,snap){
                                    if(snap.hasData){
                                      return CircularPercentIndicator(
                                        backgroundColor: Color(0xff2D2D2D),
                                        progressColor: Color(0xffF6C85F),
                                        percent:(int.parse(snap.data.snapshot.value.toString()).toDouble())/125.0,
                                        animation: true,
                                        radius: 200.0,
                                        lineWidth: 10.0,
                                        circularStrokeCap: CircularStrokeCap.round,
                                        center: Container(
                                          height: SizeConfig.heightMultiplier * 16,
                                          width: SizeConfig.widthMultiplier * 40,
                                          margin: EdgeInsets.only(
                                              left: SizeConfig.widthMultiplier * 8
                                          ),
                                          child: Container(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 3,
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    child:Text(snap.data.snapshot.value.toString(),
                                                      style: GoogleFonts.robotoMono(
                                                          color: Color(0xffF6C85F),
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: SizeConfig.textMultiplier * 3.7
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.all(8),
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          bottom: SizeConfig.heightMultiplier * 6
                                                      ),
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          border: Border.all(
                                                              color: Colors.yellow,
                                                              width: 1
                                                          )
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                    child: Text(
                                                      'C',
                                                      style: GoogleFonts.robotoMono(
                                                          color: Color(0xffF6C85F),
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: SizeConfig.textMultiplier * 7
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        header: Container(
                                          margin: EdgeInsets.only(
                                              bottom: SizeConfig.heightMultiplier * 3
                                          ),
                                          child: Text(
                                            'Temperature',
                                            style: GoogleFonts.robotoMono(
                                                color: Color(0xffF6C85F),
                                                fontWeight: FontWeight.w500,
                                                fontSize: SizeConfig.textMultiplier * 4
                                            ),
                                          ),
                                        ),
                                      );
                                    }else {
                                      return CircularProgressIndicator();
                                    }
                                  }
                              )
                          ),
                          SizedBox(
                            height: SizeConfig.heightMultiplier * 4,
                          ),
                          Visibility(
                            visible: heaterOn,
                            child: Container(
                              height: SizeConfig.heightMultiplier * 8,
                              margin: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.widthMultiplier * 10
                              ),
                              child: RaisedButton(
                                color: Color(0xffF6C85F),
                                onPressed: (){
                                  updateData('Heater', 'on');
                                  updateData('Fan', 'off');
                                  setState(() {
                                    heaterOff = true;
                                    heaterOn = false;
                                    fanOn = false;
                                    fanOff = true;
                                  });
                                },
                                child: Text(
                                  'Turn On Heater',
                                  style: GoogleFonts.robotoMono(
                                      color: Colors.black,
                                      fontSize: SizeConfig.textMultiplier * 3,
                                      fontWeight: FontWeight.w500
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: heaterOff,
                            child: Container(
                              height: SizeConfig.heightMultiplier * 8,
                              margin: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.widthMultiplier * 10
                              ),
                              child: RaisedButton(
                                color: Color(0xffF6C85F),
                                onPressed: (){
                                  updateData('Heater', 'off');
                                  updateData('Fan', 'on');
                                  setState(() {
                                    heaterOn = true;
                                    heaterOff = false;
                                    fanOff = true;
                                    fanOn = false;
                                  });
                                },
                                child: Text(
                                  'Turn Off Heater',
                                  style: GoogleFonts.robotoMono(
                                      color: Colors.black,
                                      fontSize: SizeConfig.textMultiplier * 3,
                                      fontWeight: FontWeight.w500
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.heightMultiplier * 3,
                          ),
                          Visibility(
                            visible: fanOn,
                            child: Container(
                              height: SizeConfig.heightMultiplier * 8,
                              margin: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.widthMultiplier * 10
                              ),
                              child: RaisedButton(
                                color: Color(0xffF6C85F),
                                onPressed: (){
                                  updateData('Fan', 'on');
                                  updateData('Heater', 'off');
                                  setState(() {
                                    fanOff = true;
                                    fanOn = false;
                                    heaterOn = false;
                                    heaterOn = true;
                                  });
                                },
                                child: Text(
                                  'Turn On Fan',
                                  style: GoogleFonts.robotoMono(
                                      color: Colors.black,
                                      fontSize: SizeConfig.textMultiplier * 3,
                                      fontWeight: FontWeight.w500
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: fanOff,
                            child: Container(
                              height: SizeConfig.heightMultiplier * 8,
                              margin: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.widthMultiplier * 10
                              ),
                              child: RaisedButton(
                                color: Color(0xffF6C85F),
                                onPressed: (){
                                  updateData('Fan', 'off');
                                  updateData('Heater', 'on');
                                  setState(() {
                                    fanOn = true;
                                    fanOff = false;
                                    heaterOn = true;
                                    heaterOff = false;
                                  });
                                },
                                child: Text(
                                  'Turn Off Fan',
                                  style: GoogleFonts.robotoMono(
                                      color: Colors.black,
                                      fontSize: SizeConfig.textMultiplier * 3,
                                      fontWeight: FontWeight.w500
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
  void updateData(String appliance, String state){
    databaseReferenceTest.update({
      '$appliance': '$state'
    });
  }

  getTemperatureValue(String value) async{
    int initialValue = int.parse(value);
    double finalValue = initialValue.toDouble()/125.0;

    setState(() async{
      progress=  await finalValue;
    });
  }
}
