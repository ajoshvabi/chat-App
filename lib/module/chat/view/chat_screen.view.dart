import 'package:chat_app/module/chat/controller/chat.controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String senderId;
  final String receiverId;
  final String name;
  final String profile;

  const ChatScreen({
    super.key,
    required this.senderId,
    required this.receiverId,
    required this.name,
    required this.profile,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChatController>(
        context,
        listen: false,
      ).loadMessages(widget.senderId, widget.receiverId);
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F7),
      body: Consumer<ChatController>(
        builder: (context, chatCtrl, _) {
          return SafeArea(
            child: Column(
              children: [
                Gap(30.h),

                // Top app bar with back button and placeholder for avatar & name
                Padding(
                  padding: EdgeInsets.only(
                    left: 25.w,
                    right: 25.w,
                    bottom: 25.h,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          height: 36.h,
                          width: 36.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.arrow_back),
                        ),
                      ),
                      Gap(16.w),
                      CircleAvatar(
                        radius: 22.r,
                        backgroundImage: NetworkImage(widget.profile),
                      ),
                      SizedBox(width: 8.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.name,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 18.sp,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'Online',
                                style: GoogleFonts.poppins(
                                  color: Color(0xFF583E45),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              SizedBox(width: 5.w),
                              Container(
                                width: 12.r,
                                height: 12.r,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(height: 0, thickness: 0.3, color: Colors.black12),

                // Chat messages body
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24.r),
                        topRight: Radius.circular(24.r),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: chatCtrl.isLoading
                          ? Center(child: CircularProgressIndicator())
                          : chatCtrl.messages.isEmpty
                          ? Center(
                              child: Text(
                                "No messages",
                                style: GoogleFonts.poppins(
                                  fontSize: 16.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : ListView.builder(
                              physics: BouncingScrollPhysics(),
                              padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
                              itemCount: chatCtrl.messages.length,
                              itemBuilder: (context, index) {
                                final msg = chatCtrl.messages[index];
                                final isMe =
                                    msg['sender_id'].toString() ==
                                    widget.senderId;

                                // Format the time string from msg['sent_at'] (assuming ISO8601 format)
                                String formattedTime = '';
                                if (msg['sent_at'] != null) {
                                  DateTime sentAt = DateTime.parse(
                                    msg['sent_at'],
                                  );
                                  formattedTime = TimeOfDay.fromDateTime(
                                    sentAt,
                                  ).format(context);
                                }

                                return Align(
                                  alignment: isMe
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment: isMe
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                          vertical: 6.h,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          vertical: 10.h,
                                          horizontal: 16.w,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isMe
                                              ? Color(0xFFE35587)
                                              : Color(0xFFEDEDED),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20.r),
                                            topRight: Radius.circular(20.r),
                                            bottomLeft: isMe
                                                ? Radius.circular(20.r)
                                                : Radius.circular(0),
                                            bottomRight: isMe
                                                ? Radius.circular(0)
                                                : Radius.circular(20.r),
                                          ),
                                        ),
                                        child: Text(
                                          msg['message'] ?? '',
                                          style: GoogleFonts.poppins(
                                            fontSize: 15.sp,
                                            color: isMe
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 6.h),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            formattedTime,
                                            style: GoogleFonts.poppins(
                                              color: Color(0xFF583E45),
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          SizedBox(width: 2.w),
                                          SvgPicture.asset(
                                            "assets/icons/tickmark.svg",
                                            height: 15.r,
                                            width: 15.r,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                ),

                // Input area with textfield and send button
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 24.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFF7F6FA),
                            borderRadius: BorderRadius.circular(30.r),
                            border: Border.all(color: Color(0xFFEDEDED)),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: TextField(
                            controller: _textController,
                            style: GoogleFonts.poppins(fontSize: 15.sp),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Type a message",
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 15.sp,
                                color: Colors.grey,
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  // Implement your send message logic here
                                  final text = _textController.text.trim();
                                  if (text.isNotEmpty) {
                                    print('Send button tapped! Message: $text');
                                    _textController.clear();
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: SvgPicture.asset(
                                    "assets/icons/send.svg",
                                    width: 24.r,
                                    height: 24.r,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
