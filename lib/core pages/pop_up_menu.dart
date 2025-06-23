// import 'package:flutter/material.dart';
// import 'package:popup_menu/popup_menu.dart';
// import '../core/app_color.dart';
//
//
// class NearbyPopupMenu {
//   static void show(BuildContext context, GlobalKey widgetKey) {
//     PopupMenu menu = PopupMenu(
//       context: context,
//       config: MenuConfig(
//         maxColumn: 1,
//         backgroundColor: AppColors.WhisperWhite, // Example: Using OliveGrove for background
//         highlightColor: AppColors.SunsetOrange, // Example: Using SunsetOrange for highlight
//         lineColor: AppColors.LightGrey, // Example: Using LightGrey for dividers
//       ),
//       onClickMenu: (MenuItemProvider item) {
//         // Handle menu item click
//         debugPrint("Selected: ${item.menuTitle}");
//         // You can add navigation or other logic here
//       },
//       items: [
//         MenuItem(
//           title: "قريب منك!",
//           textStyle: const TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 12,
//             color: AppColors.CedarOlive, // Example: Using WhisperWhite for text
//           ),
//           userInfo: "title",
//         ),
//         MenuItem(
//           title: "حملات",
//           textStyle: const TextStyle(
//             color: AppColors.SunsetOrange, // Example: Using OceanBlue for text
//           ),
//         ),
//         MenuItem(
//           title: "مبادرات",
//           textStyle: const TextStyle(
//             color: AppColors.OceanBlue, // Example: Using RichBerry for text
//           ),
//         ),
//         MenuItem(
//           title: "شكاوى",
//           textStyle: const TextStyle(
//             color: AppColors.RichBerry, // Example: Using CharcoalGrey for text
//           ),
//         ),
//       ],
//     );
//     menu.show(widgetKey: widgetKey);
//   }
// }
