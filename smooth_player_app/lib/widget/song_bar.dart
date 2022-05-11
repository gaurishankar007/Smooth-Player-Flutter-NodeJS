// import 'dart:async';

// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';

// class SongBar extends StatefulWidget {
//   final Song? songData;
//   const SongBar({Key? key, @required this.songData}) : super(key: key);

//   @override
//   State<SongBar> createState() => _SongBarState();
// }

// class _SongBarState extends State<SongBar> {
//   final AudioPlayer player = Player.player;

//   late StreamSubscription stateSub, completionSub;
//   late SOng? songData;

//   @override
//   void initState() {
//     super.initState();

//     songData = widget.songData;

//     stateSub = player.onPlayerStateChanged.listen((state) {
//       setState(() {
//         Player.isPaused = state == PlayerState.PAUSED;
//         songData = Player.playingSong;
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

//     return Padding(
//       padding: EdgeInsets.symmetric(
//         horizontal: 5,
//       ),
//       child: GestureDetector(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (builder) => PlayingSong(),
//             ),
//           );
//         },
//         child: Container(
//           padding: EdgeInsets.all(4),
//           height: 60,
//           decoration: BoxDecoration(
//             color: Color(0XFF5B86E5),
//             borderRadius: BorderRadius.circular(8),
//             boxShadow: const [
//               BoxShadow(
//                 color: Colors.black12,
//                 spreadRadius: 1,
//                 blurRadius: 5,
//                 offset: Offset(0, -2),
//               )
//             ],
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 width: 50,
//                 decoration: BoxDecoration(
//                   color: Color(0XFF36D1DC),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               SizedBox(
//                 width: sWidth * .5,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       songData!.title!,
//                       overflow: TextOverflow.fade,
//                       softWrap: false,
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       songData!.album!.title!,
//                       overflow: TextOverflow.fade,
//                       softWrap: false,
//                       style: TextStyle(
//                         color: Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   TextButton(
//                     onPressed: () {
//                       Player().previousSong();
//                       setState(() {
//                         songData = Player.playingSong;
//                       });
//                     },
//                     style: TextButton.styleFrom(
//                       padding: EdgeInsets.zero,
//                       minimumSize: Size.zero,
//                       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                     ),
//                     child: Icon(
//                       Icons.skip_previous,
//                       size: 35,
//                       color: Colors.black,
//                     ),
//                   ),
//                   Player.isPaused
//                       ? TextButton(
//                           onPressed: () {
//                             Player().resumeSong();
//                           },
//                           style: TextButton.styleFrom(
//                             padding: EdgeInsets.zero,
//                             minimumSize: Size.zero,
//                             tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                           ),
//                           child: Icon(
//                             Icons.play_arrow_sharp,
//                             size: 40,
//                             color: Colors.black,
//                           ),
//                         )
//                       : TextButton(
//                           onPressed: () {
//                             Player().pauseSong();
//                           },
//                           style: TextButton.styleFrom(
//                             padding: EdgeInsets.zero,
//                             minimumSize: Size.zero,
//                             tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                           ),
//                           child: Icon(
//                             Icons.pause_sharp,
//                             size: 40,
//                             color: Colors.black,
//                           ),
//                         ),
//                   TextButton(
//                     onPressed: () {
//                       Player().nextSong();
//                       setState(() {
//                         songData = Player.playingSong;
//                       });
//                     },
//                     style: TextButton.styleFrom(
//                       padding: EdgeInsets.zero,
//                       minimumSize: Size.zero,
//                       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                     ),
//                     child: Icon(
//                       Icons.skip_next,
//                       size: 35,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
