import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_video_call/constants/constants.dart';
import 'package:flutter_video_call/services/login_service.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final TextEditingController singleInviteeUserIDTextCtrl =
      TextEditingController();
  final TextEditingController groupInviteeUserIDsTextCtrl =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Video Call Flutter',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 5, 204, 108),
              )),
          actions: [
            logoutButton(),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Welcome, To Video Call Flutter application plase enter the user id and group id to make a call",
                ),
                const SizedBox(height: 10),
                Text(
                  'Your User Id: ${currentUser.id}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 30),
                inviteeInputRow(
                  title: 'Invitee name',
                  description:
                      "Please enter the user id of the invitee to make a call with the user",
                  textController: singleInviteeUserIDTextCtrl,
                ),
                const Divider(height: 20, color: Colors.grey),
                inviteeInputRow(
                  title: 'Group name',
                  description:
                      "Please enter the user id of the invitee to make a call with the group",
                  textController: groupInviteeUserIDsTextCtrl,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget logoutButton() {
    return Ink(
      child: IconButton(
        icon: const Icon(Icons.logout),
        iconSize: 24,
        color: Colors.red,
        onPressed: () {
          logout().then((value) {
            onUserLogout();
            Navigator.pushNamed(
              // ignore: use_build_context_synchronously
              context,
              PageRouteNames.login,
            );
          });
        },
      ),
    );
  }

  Widget inviteeInputRow({
    required String title,
    required String description,
    required TextEditingController textController,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          description,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 10),
        inviteeIDFormField(
          textCtrl: textController,
          formatters: [
            FilteringTextInputFormatter.allow(RegExp('[0-9,]')),
          ],
          labelText: 'Invitee ID',
          hintText: 'Please enter invitee ID',
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            sendCallButton(
              isVideoCall: false,
              inviteeUsersIDTextCtrl: textController,
              onCallFinished: onSendCallInvitationFinished,
            ),
            const SizedBox(width: 10),
            sendCallButton(
              isVideoCall: true,
              inviteeUsersIDTextCtrl: textController,
              onCallFinished: onSendCallInvitationFinished,
            ),
          ],
        ),
      ],
    );
  }

  Widget inviteeIDFormField({
    required TextEditingController textCtrl,
    List<TextInputFormatter>? formatters,
    String hintText = '',
    String labelText = '',
  }) {
    const textStyle = TextStyle(fontSize: 12.0);
    return TextFormField(
      style: textStyle,
      controller: textCtrl,
      inputFormatters: formatters,
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        hintStyle: textStyle,
        labelText: labelText,
        labelStyle: textStyle,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        filled: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      ),
    );
  }

  Widget sendCallButton({
    required bool isVideoCall,
    required TextEditingController inviteeUsersIDTextCtrl,
    void Function(String code, String message, List<String>)? onCallFinished,
  }) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: inviteeUsersIDTextCtrl,
      builder: (context, inviteeUserID, _) {
        final invitees =
            getInvitesFromTextCtrl(inviteeUsersIDTextCtrl.text.trim());

        return ZegoSendCallInvitationButton(
          isVideoCall: isVideoCall,
          invitees: invitees,
          resourceID: 'zego_data',
          iconSize: const Size(40, 40),
          buttonSize: const Size(50, 50),
          onPressed: onCallFinished,
        );
      },
    );
  }

// This method displays an appropriate error or success message after sending a call invitation, providing feedback to the user. If the call invitation was successful, the method displays a success message. If the call invitation failed, the method displays an error message with the user IDs that caused the failure. The method also displays the error code and message if they are provided.

  void onSendCallInvitationFinished(
    String code,
    String message,
    List<String> errorInvitees,
  ) {
    if (errorInvitees.isNotEmpty) {
      var userIDs = '';
      for (var index = 0; index < errorInvitees.length; index++) {
        if (index >= 5) {
          userIDs += '... ';
          break;
        }
        final userID = errorInvitees.elementAt(index);
        userIDs += '$userID ';
      }
      if (userIDs.isNotEmpty) {
        userIDs = userIDs.substring(0, userIDs.length - 1);
      }

      var errorMessage = "User doesn't exist or is offline: $userIDs";
      if (code.isNotEmpty) {
        errorMessage += ', code: $code, message:$message';
      }
      showToast(
        errorMessage,
        position: StyledToastPosition.top,
        context: context,
      );
    } else if (code.isNotEmpty) {
      showToast(
        'code: $code, message:$message',
        position: StyledToastPosition.top,
        context: context,
      );
    }
  }
}

// function parses the invitee IDs from the input and creates user objects for the call invitation.ZegoUIKitUser is a class that represents a user in the ZegoUIKit SDK. The function creates a list of ZegoUIKitUser objects from the invitee IDs entered in the text field. The function splits the invitee IDs by commas and creates a ZegoUIKitUser object for each ID. The function then adds the ZegoUIKitUser objects to a list and returns the list.

List<ZegoUIKitUser> getInvitesFromTextCtrl(String textCtrlText) {
  final invitees = <ZegoUIKitUser>[];
  final inviteeIDs = textCtrlText.trim().replaceAll('，', '');
  inviteeIDs.split(',').forEach((inviteeUserID) {
    if (inviteeUserID.isEmpty) return;

    invitees.add(ZegoUIKitUser(
      id: inviteeUserID,
      name: 'user_$inviteeUserID',
    ));
  });
  return invitees;
}
