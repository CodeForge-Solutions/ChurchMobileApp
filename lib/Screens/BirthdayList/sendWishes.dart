import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for clipboard
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../../constants.dart';
import 'birthdayList.dart';

class SendWishesScreen extends StatelessWidget {
  final ApplicationUser user;

  const SendWishesScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController messageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          user.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Name
            Text(
              'Name: ${user.name}',
              style: const TextStyle(
                fontSize: kDetailNameFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: kSpacing),

            // Date of Birth
            Text(
              'Date of Birth: ${DateFormat('dd-MM-yyyy').format(
                  user.birthday)}',
              style: const TextStyle(
                fontSize: kDetailPhoneFontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: kSpacing),

            // Message Input Field
            TextField(
              controller: messageController,
              decoration: customInputDecoration(
                  'Enter your message'),
              maxLines: 5,
            ),
            const SizedBox(height: kSpacing),

            // Button Row: Share and Copy
            Row(
              children: [
                // Share Button
                Expanded(
                  child: buildGradientButton(
                    child: const Text(
                      'Share',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      if (messageController.text.isNotEmpty) {
                        Share.share(messageController.text);
                      } else {
                        showToast(context, 'Please enter a message to share!');
                      }
                    },
                  ),
                ),
                const SizedBox(width: kSpacing),

                // Copy to Clipboard Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (messageController.text.isNotEmpty) {
                        Clipboard.setData(
                          ClipboardData(text: messageController.text),
                        );
                        showToast(context, 'Message copied to clipboard!');
                      } else {
                        showToast(context, 'Please enter a message to copy!');
                      }
                    },
                    icon: const Icon(Icons.copy, color: Colors.white),
                    label: const Text(
                      'Copy',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      minimumSize: const Size(double.infinity, 50),
                      shape: const RoundedRectangleBorder(
                        borderRadius: borderRadius,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
