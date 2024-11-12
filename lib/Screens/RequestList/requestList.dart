import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';
import '../../APIService.dart';
import '../../constants.dart';

class RequestListScreen extends StatefulWidget {
  const RequestListScreen({Key? key}) : super(key: key);

  @override
  _RequestListScreenState createState() => _RequestListScreenState();
}

class _RequestListScreenState extends State<RequestListScreen> {
  List<ApplicationRequest> applicationRequests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  Future<void> fetchRequests() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await ApiService.getRequest("user/getUnAcceptedUsersList");

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['isSuccess'] == true) {
          List<dynamic> data = jsonResponse['data'];
          setState(() {
            applicationRequests = data.map((item) {
              return ApplicationRequest(
                id: item['id'],
                name: item['name'],
                gender: item['gender'],
                phoneNumber: item['phoneNumber'],
              );
            }).toList();
          });
        } else {
          setState(() {
            applicationRequests = [];
          });
          showToast(context, jsonResponse['message']);
        }
      } else {
        showToast(context, "Failed to fetch data");
        setState(() {
          applicationRequests = [];
        });
      }
    } catch (e) {
      showToast(context, "An error occurred");
      setState(() {
        applicationRequests = [];
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : applicationRequests.isEmpty
          ? const Center(
        child: Text(
          "No requests available",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: applicationRequests.length,
        itemBuilder: (context, index) {
          return ApplicationAccessRequestCard(
            request: applicationRequests[index],
            onRequestUpdated: fetchRequests,
          );
        },
      ),
    );
  }
}

class ApplicationRequest {
  final int id;
  final String name;
  final String gender;
  final String phoneNumber;
  bool isAccepted;

  ApplicationRequest({
    required this.id,
    required this.name,
    required this.gender,
    required this.phoneNumber,
    this.isAccepted = false,
  });
}

class ApplicationAccessRequestCard extends StatefulWidget {
  final ApplicationRequest request;
  final VoidCallback onRequestUpdated;

  const ApplicationAccessRequestCard({Key? key, required this.request, required this.onRequestUpdated}) : super(key: key);

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
                  onPressed: isButtonDisabled ? null : () => _handleAcceptRequest(),
                ),
                IconButton(
                  icon: const Icon(Icons.clear, color: Colors.red),
                  onPressed: isButtonDisabled ? null : () => _handleRejectRequest(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleAcceptRequest() async {
    setState(() {
      isButtonDisabled = true;
    });

    try {
      final response = await ApiService.postRequest(
        "user/acceptUser?userId=${widget.request.id}",
      );

      if (response.statusCode == 200) {
        setState(() {
          widget.request.isAccepted = true;
          isButtonDisabled = true;
        });
        showToast(context, 'Request accepted');
        widget.onRequestUpdated();
      } else {
        showToast(context, 'Failed to accept request');
        setState(() {
          isButtonDisabled = false;
        });
      }
    } catch (e) {
      showToast(context, "An error occurred");
      setState(() {
        isButtonDisabled = false;
      });
    }
  }

  Future<void> _handleRejectRequest() async {
    setState(() {
      isButtonDisabled = true;
    });

    try {
      final response = await ApiService.postRequest(
        "user/rejectUser?userId=${widget.request.id}",
      );

      if (response.statusCode == 200) {
        setState(() {
          widget.request.isAccepted = false;
          isButtonDisabled = true;
        });
        showToast(context, 'Request rejected');
        widget.onRequestUpdated();
      } else {
        showToast(context, 'Failed to reject request');
        setState(() {
          isButtonDisabled = false;
        });
      }
    } catch (e) {
      showToast(context, "An error occurred");
      setState(() {
        isButtonDisabled = false;
      });
    }
  }
}
