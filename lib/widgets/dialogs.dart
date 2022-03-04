import 'package:flutter/material.dart';

Future emptyDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Text('Fill all the fields!'),
          ),
        );
      });
}

mySnackbar(context) {
  Navigator.pop(context);
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text('Your request has been recieved')));
}

forumSnackbar(context) {
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text('Your question has been posted')));
}

authDialog(message, context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Authentication'),
          content: Text(message),
          // child: Container(
          //   padding: EdgeInsets.all(10),
          //   child: Text(message),
          // ),
        );
      });
}

checkErrors(error, context) {
  print(error.code);
  switch (error.code) {
    case 'invalid-email':
      return authDialog('Invalid Email', context);
      break;
    case 'email-already-exists':
      return authDialog('There is already a user registered with this email.', context);
      break;
    case 'iwrong-password':
      return authDialog('You entered a wrong password ', context);
      break;
    case 'internal-error':
      return authDialog('Server error. Please try again later ', context);
      break;
    case 'invalid-credential':
      return authDialog('Invalid credential', context);
      break;
    case 'invalid-password':
      return authDialog('Invalid password', context);
      break;
    case 'user-not-found':
      return authDialog('User not found', context);
      break;
    case 'invalid-argument':
      return authDialog('Invalid arguments', context);
      break;
    
    default:
      return authDialog('An error occured', context);
  }
}

