import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants.dart';

class RequestListScreen extends StatefulWidget {
  const RequestListScreen({Key? key}) : super(key: key);

  // Sample data for demonstration
  @override
  _RequestListScreenState createState() => _RequestListScreenState();
}

class _RequestListScreenState extends State<RequestListScreen> {
  final List<ApplicationRequest> applicationRequests = [
    ApplicationRequest(name: 'Alice', gender: 'Female', phoneNumber: '123-456-7890'),
    ApplicationRequest(name: 'Alice1', gender: 'Female', phoneNumber: '123-456-78901'),
    ApplicationRequest(name: 'Bob1', gender: 'Male', phoneNumber: '987-654-3210'),
    ApplicationRequest(name: 'Bob2', gender: 'Male', phoneNumber: '987-654-3210'),
    ApplicationRequest(name: 'Bob3', gender: 'Male', phoneNumber: '987-654-3210'),
    ApplicationRequest(name: 'Bob4', gender: 'Male', phoneNumber: '987-654-3210'),
    ApplicationRequest(name: 'Bob5', gender: 'Male', phoneNumber: '987-654-3210'),
    ApplicationRequest(name: 'Bob6', gender: 'Male', phoneNumber: '987-654-3210')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Request List",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: kAppBarFontSize,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: applicationRequests.length,
        itemBuilder: (context, index) {
          return ApplicationAccessRequestCard(request: applicationRequests[index]);
        },
      ),
    );
  }
}

class ApplicationRequest {
  final String name;
  final String gender;
  final String phoneNumber;
  bool isAccepted;

  ApplicationRequest({
    required this.name,
    required this.gender,
    required this.phoneNumber,
    this.isAccepted = false,
  });
}

class ApplicationAccessRequestCard extends StatefulWidget {
  final ApplicationRequest request;

  const ApplicationAccessRequestCard({Key? key, required this.request}) : super(key: key);

  @override
  _ApplicationAccessRequestCardState createState() => _ApplicationAccessRequestCardState();
}

class _ApplicationAccessRequestCardState extends State<ApplicationAccessRequestCard> {
  bool isButtonDisabled = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(kCardMargin),
      child: Padding(
        padding: const EdgeInsets.all(kCardPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ClipOval(
                  child: SvgPicture.asset(
                    widget.request.gender == 'Male'
                        ? 'assets/icons/male.svg'
                        : 'assets/icons/female.svg',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.request.name.isNotEmpty ? widget.request.name : 'Unknown',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.request.phoneNumber.isNotEmpty
                          ? widget.request.phoneNumber
                          : 'No phone number',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.check, color: Colors.green),
                  onPressed: isButtonDisabled ? null : () => _handleAcceptRequest(context),
                ),
                IconButton(
                  icon: const Icon(Icons.clear, color: Colors.red),
                  onPressed: isButtonDisabled ? null : () => _handleRejectRequest(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleAcceptRequest(BuildContext context) {
    setState(() {
      widget.request.isAccepted = true; // Update state
      isButtonDisabled = true; // Disable buttons
    });
    showToast(context, 'Request accepted');

    // Re-enable the button after the defined duration
    Future.delayed(const Duration(seconds: kButtonDisableDuration), () {
      setState(() {
        isButtonDisabled = false; // Re-enable buttons
      });
    });
  }

  void _handleRejectRequest(BuildContext context) {
    setState(() {
      widget.request.isAccepted = false; // Update state
      isButtonDisabled = true; // Disable buttons
    });
    showToast(context, 'Request rejected');

    // Re-enable the button after the defined duration
    Future.delayed(const Duration(seconds: kButtonDisableDuration), () {
      setState(() {
        isButtonDisabled = false; // Re-enable buttons
      });
    });
  }
}
