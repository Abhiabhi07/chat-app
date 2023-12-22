import 'package:chat/common/error_screen.dart';
import 'package:chat/common/loading_indicator.dart';
import 'package:chat/controller/select_contact_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContactsScreen extends ConsumerWidget {
  static const routeName = '/contacts-screen';
  const ContactsScreen({super.key});

  void selectContact(
      WidgetRef ref, Contact selectedContact, BuildContext context) {
    ref
        .read(selectContactControllerProvider)
        .selectContact(selectedContact, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: ref.watch(getContactsProvider).when(
            data: (contactList) {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2 / 0.8,
                ),
                shrinkWrap: true,
                itemCount: contactList.length,
                itemBuilder: (context, index) {
                  final contact = contactList[index];
                  return GestureDetector(
                    onTap: () => selectContact(ref, contact, context),
                    child: Container(
                      margin: const EdgeInsets.all(7.0),
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.teal, width: 1.0),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                image: contact.photo != null
                                    ? MemoryImage(contact.photo!)
                                    : const NetworkImage(
                                        'https://cdn-icons-png.flaticon.com/128/9131/9131478.png',
                                      ) as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  contact.displayName,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                  maxLines: 1,
                                ),
                                Text(
                                  contact.phones[0].number.replaceAll(
                                    ' ',
                                    '',
                                  ),
                                )
                              ],
                            ),
                          )
                          // ListTile(
                          //   title: Text(''),
                          // )
                        ],
                      ),
                    ),
                  );
                  // Container(
                  //   margin: EdgeInsets.all(8.0),
                  //   height: 70,
                  //   child: ListTile(
                  //     contentPadding: EdgeInsets.all(8.0),
                  //     shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(10.0)),
                  //     tileColor: Colors.blue,
                  //     leading: Container(
                  //       width: 50,
                  //       decoration: BoxDecoration(
                  //           color: Colors.amber,
                  //           borderRadius: BorderRadius.circular(10.0)),
                  //     ),
                  //   ),
                  // );
                },
              );
            },
            error: (err, trace) => ErrorScreen(
              error: err.toString(),
            ),
            loading: () => LoadingIndicator(),

            // LoadingIndicator()
          ),
    );
  }
}
