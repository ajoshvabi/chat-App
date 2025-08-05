import 'package:chat_app/module/chat/view/chat_screen.view.dart';
import 'package:chat_app/module/messages/controller/message.controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MessagesViewScreen extends StatefulWidget {
  const MessagesViewScreen({super.key});

  @override
  State<MessagesViewScreen> createState() => _MessagesViewScreenState();
}

class _MessagesViewScreenState extends State<MessagesViewScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MessageController>(context, listen: false).messageOnInit();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<MessageController>(
          builder: (context, mesgCtrl, _) {
            return mesgCtrl.isLoading
                ? Center(child: CircularProgressIndicator())
                : Padding(
                    padding: EdgeInsets.only(
                      left: 25.w,
                      right: 25.w,
                      bottom: 25.h,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Gap(30.h),
                          // Top Bar with back button and title
                          Row(
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
                              SizedBox(width: 16.w),
                              Text(
                                "Messages",
                                style: GoogleFonts.poppins(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30.h),
                          // Stories (horizontal scroll)
                          SizedBox(
                            height: 85.h,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: mesgCtrl.chats.length,
                              separatorBuilder: (_, __) =>
                                  SizedBox(width: 18.w),
                              itemBuilder: (context, index) {
                                final story = mesgCtrl.chats[index];
                                return Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 26.r,
                                      backgroundImage:
                                          story["image"]!.startsWith('http')
                                          ? NetworkImage(story["image"]!)
                                          : AssetImage(story["image"]!)
                                                as ImageProvider,
                                    ),
                                    SizedBox(height: 4.h),
                                    SizedBox(
                                      width: 60.w,
                                      child: Text(
                                        story["name"]!,
                                        style: GoogleFonts.poppins(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 24.h),

                          // Search Bar
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: "Search",
                                    hintStyle: GoogleFonts.poppins(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 18,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(28),
                                      borderSide: BorderSide(
                                        color: Color(0xFFE8E6EA),
                                        width: 1.2,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(28),
                                      borderSide: BorderSide(
                                        color: Color(0xFFE8E6EA),
                                        width: 1.2,
                                      ),
                                    ),
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(
                                        right: 14.0,
                                      ),
                                      child: SvgPicture.asset(
                                        "assets/icons/search.svg",
                                        width: 24,
                                        height: 24,
                                      ),
                                    ),
                                    suffixIconConstraints: BoxConstraints(
                                      minHeight: 24,
                                      minWidth: 24,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 28.h),

                          // Chat title
                          Text(
                            "Chat",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 17.sp,
                            ),
                          ),
                          SizedBox(height: 14.h),

                          // List of chats
                          mesgCtrl.chats.isEmpty
                              ? Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 50.h,
                                    ),
                                    child: Text(
                                      "No chats available",
                                      style: GoogleFonts.poppins(
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ),
                                )
                              : ListView.separated(
                                  itemCount: mesgCtrl.chats.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  separatorBuilder: (_, __) =>
                                      Divider(color: Color(0xFFF1F1F1)),
                                  itemBuilder: (context, index) {
                                    final chat = mesgCtrl.chats[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ChatScreen(
                                              senderId: mesgCtrl
                                                  .getUserIdFromHive()!,
                                              receiverId: chat["id"]!,
                                              name: chat["name"]!,
                                              profile: chat["image"]!,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              radius: 26,
                                              backgroundImage:
                                                  chat["image"]!.startsWith(
                                                    'http',
                                                  )
                                                  ? NetworkImage(chat["image"]!)
                                                  : AssetImage(chat["image"]!)
                                                        as ImageProvider,
                                            ),
                                            SizedBox(width: 18),
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    chat["name"]!,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Text(
                                                    mesgCtrl.formatTime(
                                                      chat["time"]!,
                                                    ),
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ],
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
