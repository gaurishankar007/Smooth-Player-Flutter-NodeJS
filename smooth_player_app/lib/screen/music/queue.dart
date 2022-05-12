// import 'dart:async';

// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';

// class SongQueue extends StatefulWidget {
//   const SongQueue({
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<SongQueue> createState() => _SongQueueState();
// }

// class _SongQueueState extends State<SongQueue> {
//   final AudioPlayer player = Player.player;
//   Song? song = Player.playingSong;

//   List<Song> nextSongs = Player.nextSongs.toList();
//   List<Song> songQueue =
//       Player.songQueue.isNotEmpty ? Player.songQueue.toList() : [];

//   late StreamSubscription stateSub, completionSub;

//   @override
//   void initState() {
//     super.initState();

//     stateSub = player.onPlayerStateChanged.listen((state) {
//       setState(() {
//         Player.isPaused = state == PlayerState.PAUSED;
//       });
//     });

//     completionSub = player.onPlayerCompletion.listen((state) {
//       Player().autoNextSong();
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     stateSub.cancel();
//     completionSub.cancel();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final sWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(
//             Icons.arrow_back,
//             color: Colors.black,
//           ),
//         ),
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.symmetric(
//             horizontal: sWidth * .03,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Now Playing",
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//                         width: 50,
//                         height: 50,
//                         decoration: BoxDecoration(
//                           color: Color(0XFF5B86E5),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       SizedBox(
//                         width: sWidth * .5,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               song!.title!,
//                               overflow: TextOverflow.fade,
//                               softWrap: false,
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             Text(
//                               song!.album!.title!,
//                               overflow: TextOverflow.fade,
//                               softWrap: false,
//                               style: TextStyle(
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   IconButton(
//                     onPressed: () {
//                       Player().nextSong();
//                     },
//                     icon: Icon(
//                       Icons.delete,
//                       color: Colors.red,
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 25,
//               ),
//               songQueue.isNotEmpty
//                   ? Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "Next in Queue",
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             IconButton(
//                               onPressed: () {
//                                 setState(() {
//                                   Player.songQueue.clear();
//                                   songQueue = [];
//                                 });
//                               },
//                               icon: Icon(
//                                 Icons.delete,
//                                 color: Colors.red,
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         ListView.builder(
//                           physics: NeverScrollableScrollPhysics(),
//                           shrinkWrap: true,
//                           itemCount: songQueue.length,
//                           itemBuilder: (context, index) {
//                             return Padding(
//                               padding: const EdgeInsets.symmetric(
//                                 vertical: 5,
//                               ),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Container(
//                                         width: 50,
//                                         height: 50,
//                                         decoration: BoxDecoration(
//                                           color: Color(0XFF5B86E5),
//                                           borderRadius:
//                                               BorderRadius.circular(8),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: 10,
//                                       ),
//                                       SizedBox(
//                                         width: sWidth * .5,
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               songQueue[index].title!,
//                                               overflow: TextOverflow.fade,
//                                               softWrap: false,
//                                               style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                             Text(
//                                               songQueue[index].album!.title!,
//                                               overflow: TextOverflow.fade,
//                                               softWrap: false,
//                                               style: TextStyle(
//                                                 color: Colors.black,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   IconButton(
//                                     onPressed: () {
//                                       setState(() {
//                                         songQueue.removeAt(index);
//                                       });
//                                       Player.songQueue.clear();
//                                       for (int i = 0;
//                                           i < songQueue.length;
//                                           i++) {
//                                         Player.songQueue.add(songQueue[i]);
//                                       }
//                                     },
//                                     icon: Icon(
//                                       Icons.delete,
//                                       color: Colors.red,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         )
//                       ],
//                     )
//                   : SizedBox(
//                       height: 0,
//                     ),
//               SizedBox(
//                 height: 25,
//               ),
//               Text(
//                 "Next From: " + song!.album!.title!,
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               ListView.builder(
//                 physics: NeverScrollableScrollPhysics(),
//                 shrinkWrap: true,
//                 itemCount: nextSongs.length,
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(
//                       vertical: 5,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             Container(
//                               width: 50,
//                               height: 50,
//                               decoration: BoxDecoration(
//                                 color: Color(0XFF5B86E5),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             SizedBox(
//                               width: sWidth * .5,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     nextSongs[index].title!,
//                                     overflow: TextOverflow.fade,
//                                     softWrap: false,
//                                     style: TextStyle(
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   Text(
//                                     nextSongs[index].album!.title!,
//                                     overflow: TextOverflow.fade,
//                                     softWrap: false,
//                                     style: TextStyle(
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                         IconButton(
//                           onPressed: () {
//                             setState(() {
//                               nextSongs.removeAt(index);
//                             });

//                             Player.nextSongs.clear();

//                             for (int i = 0; i < nextSongs.length; i++) {
//                               Player.nextSongs.add(nextSongs[i]);
//                             }
//                           },
//                           icon: Icon(
//                             Icons.delete,
//                             color: Colors.red,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
