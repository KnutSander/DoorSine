/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 18/01/2022

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class RuleBasedSearching{
  var trigger_words = ["meeting", "meet", "tomorrow", "book"];

  RuleBasedSearching(){
    //print(DateFormat.yMd('en_UK').parse('1/10/2020'));
    //print(checkMessage("Meet tomorrow at 10:30?"));
  }

  bool checkMessage(String message){
    // Split string and convert to lowercase
    var splitString = message.split(" ");
    var lowercaseString = [];
    splitString.forEach((element) => lowercaseString.add(element.toLowerCase()));

    // Need to find a way to extract time and date from the string
    DateTime dateTime = DateTime.now();

    // Check if trigger word is in the message
    bool triggerWordFound = false;
    for(String elem in lowercaseString) {
      if (trigger_words.contains(elem)) {
        // Ask to create meeting
        triggerWordFound = true;
        break;
      }
    }

    return setUpMeeting(triggerWordFound, dateTime);
  }

  bool setUpMeeting(bool triggerWordFound, DateTime meetingTime){


    // IF message CONTAINS list of trigger words AND a date AND a time AND both are not past
      // Ask to schedule meeting at given date and time
    // IF message CONTAINS a date AND a time AND both are not past
      // Ask to schedule meeting at given date and time
    // IF message CONTAINS a date AND date is not past
      // Ask to schedule meeting at given date
    // IF message CONTAINS a time AND time is not past
      // Ask to schedule a meeting today on given time
    if(triggerWordFound){
      // Ask to schedule a meeting
      return true;
    }

    return false;
  }
}

void main(){
  print(DateTime(2020) > DateTime(2021));
  //RuleBasedSearching rbs = RuleBasedSearching();
  //rbs.checkMessage("Meeting the 12-01-2022 at 13:30");
  // var test = DateTime.parse("1969-07-20");
  // print(test);
  //initializeDateFormatting('en_UK', null).then((_) => RuleBasedSearching());
}