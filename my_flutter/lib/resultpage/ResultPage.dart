import 'package:my_flutter/inputpage/gender/Gender.dart';
import 'package:my_flutter/appbar/BmiAppBar.dart';
import 'package:my_flutter/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter/Calculator.dart' as calculator;

class ResultPage extends StatefulWidget {
  final int height;
  final int weight;
  final Gender gender;

  const ResultPage({Key key, this.height, this.weight, this.gender})
      : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color(0xFF00154F),
      appBar: PreferredSize(
        child: BmiAppBar(isInputPage: false),
        preferredSize: Size.fromHeight(appBarHeight(context)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ResultCard(

            bmi: calculator.calculateBMI(
                height: widget.height, weight: widget.weight),
            minWeight:
            calculator.calculateMinNormalWeight(height: widget.height),
            maxWeight:
            calculator.calculateMaxNormalWeight(height: widget.height),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 40.0),
            child: IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.grey,
                size: 28.0,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Container(
              height: 52.0,
              width: 80.0,
              child: RaisedButton(
                child: Icon(
                  Icons.refresh,
                  color: Colors.white,
                  size: 28.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                onPressed: () => Navigator.of(context).pop(),
                color: Theme.of(context).primaryColor,
              )),
          Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: IconButton(
              icon: Icon(
                Icons.share,
                color: Colors.grey,
                size: 28.0,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class ResultCard extends StatelessWidget {
  comment (double bmi){
    if (bmi<18.5)
    return Column(
      children: <Widget>[
              Text(
              'You Are Kinda Skinny',
              style: TextStyle(fontSize: 30.0),
            ),
            Text('You Need Some 🥛🥙🥩', style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
      ],
    );
    else if (bmi >= 18.5 && bmi < 24.9)
    return Column(
              children: <Widget>[
                Text(
              
              'You In A Great Shape',
              style: TextStyle(fontSize: 30.0),
            ),
            Text('Keep It up 😍🔥', style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
              ],
    );
    else if (bmi >= 24.9 && bmi < 29.9 )
     return Column(
              children: <Widget>[
                Text(
              
              'It Ok But Pay Attention',
              style: TextStyle(fontSize: 30.0),
            ),
            Text('You Need Healthy Food 🥕🍅🍆', style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
              ],
    );
    if ( bmi >= 30) 
     return Column(
              children: <Widget>[
                Text(
              
              'Get Your Self Up Now',
              style: TextStyle(fontSize: 30.0),
            ),
            Text('And Workout 🏃‍💪🏋️', style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
              ],
    );
      
    
  }
  final double bmi;
  final double minWeight;
  final double maxWeight;

  ResultCard({Key key, this.bmi, this.minWeight, this.maxWeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Container(
          width: double.infinity,
          child: Column(children: [
           
            comment(bmi),
         
            Text(
              bmi.toStringAsFixed(1),
              style: TextStyle(fontSize: 140.0, fontWeight: FontWeight.bold),
            ),
            Text(
              'BMI = ${bmi.toStringAsFixed(2)} kg/m²',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                'Normal BMI weight range for the height:\n${minWeight
                    .round()}kg - ${maxWeight.round()}kg',
                style: TextStyle(fontSize: 14.0, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}