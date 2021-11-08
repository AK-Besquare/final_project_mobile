// ignore_for_file: file_names, prefer_const_constructors, avoid_print, unnecessary_string_interpolations, annotate_overrides, no_logic_in_create_state

import 'dart:convert';
import 'package:final_project/PostDetail.dart';
import 'package:final_project/createPost.dart';
import 'package:final_project/cubit/main_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key, required this.channel}) : super(key: key);
  final WebSocketChannel channel;

  State<StatefulWidget> createState() {
    return _PostPageState(channel);
  }
}

class _PostPageState extends State<PostPage> {
  _PostPageState(this.channel);
  WebSocketChannel channel;
  TextEditingController name = TextEditingController();
  bool isFavorite = false;
  bool favouriteClicked = false;

  List posts = [];
  List favoritePosts = [];

  void getPosts() {
    channel.stream.listen((message) {
      final decodedMessage = jsonDecode(message);
      setState(() {
        posts = decodedMessage['data']['posts'];
      });
    });

    channel.sink.add('{"type": "get_posts"}');
  }

  // sortDate() {
  //   for (int i = 0; i >= posts.length; i++) {}
  // }

  @override
  void initState() {
    super.initState();
    getPosts();
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainCubit(),
      child: Scaffold(
        backgroundColor: Colors.blue[100],
        drawer: Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 200,
                color: Colors.white,
                child: Image.network(
                    'https://i2.wp.com/www.newsbugz.com/wp-content/uploads/2018/05/Vadivelu-Images-e1527074481787.jpg?fit=1011%2C609&ssl=1&resize=1280%2C720'),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(onPressed: () {
                    Navigator.pushNamed(context, '/avoji');
                  }, child: Text('Tap to Know More, Jil Jil Jiga Jiga!!!', style: TextStyle(fontSize: 25) ,)),
               
                ],
              )
            ],
          ),
        ),
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    if (favouriteClicked == true) {
                      favouriteClicked = false;
                    } else {
                      favouriteClicked = true;
                    }
                  });
                },
                icon: Icon(Icons.face_outlined)),
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => CreatePost(channel: channel)));
              },
              icon: Icon(Icons.add),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return BlocProvider(
                        create: (context) => MainCubit(),
                        child: BlocBuilder<MainCubit, String>(
                          builder: (context, state) {
                            return AlertDialog(
                              title: const Text("Information"),
                              content: Text(
                                  "Tap and hold a post to delete the post"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Ok"),
                                )
                              ],
                            );
                          },
                        ),
                      );
                    });
              },
              icon: Icon(Icons.info),
            ),
          ],
          title: Center(
            child: Text(
              'Feed',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
          backgroundColor: Colors.blue[100],
        ),
        body: (favouriteClicked == false)
            ? BlocBuilder<MainCubit, String>(
                builder: (context, index) {
                  print(posts.length);
                  return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 10.0,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PostDetails(
                                    name: posts[index]['author'],
                                    title: posts[index]['title'],
                                    description: posts[index]['description'],
                                    url: posts[index]['image'],
                                  ),
                                ),
                              );
                              // Move to post details page
                            },
                            onLongPress: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return BlocProvider(
                                      create: (context) => MainCubit(),
                                      child: BlocBuilder<MainCubit, String>(
                                        builder: (context, state) {
                                          return AlertDialog(
                                            title: const Text("Delete Post"),
                                            content: Text(
                                                "Do you want to delete this post?"),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    context
                                                        .read<MainCubit>()
                                                        .delete(
                                                            posts[index]['_id'],
                                                            channel);

                                                    // context
                                                    //     .read<MainCubit>()
                                                    //     .openChannel(channel);

                                                    Navigator.of(context).pop();
                                                  });
                                                },
                                                child: Text('Delete'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text("Cancel"),
                                              )
                                            ],
                                          );
                                        },
                                      ),
                                    );
                                  });
                            },
                            child: Container(
                                padding: EdgeInsets.all(10.0),
                                child: ListTile(
                                  leading: Image.network(Uri.parse(
                                                  posts[index]['image'])
                                              .isAbsolute &&
                                          posts[index].containsKey('image')
                                      ? '${posts[index]['image']}'
                                      : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnEbxdqSdbCp4nLPU7adfKKvahLVQ3euoW-2Kqluw6RucVoRPhGhsO8IICw-S0HRdv9p8&usqp=CAU'),
                                  title: Text(
                                    '${posts[index]["title"].toString().characters.take(20)}',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  subtitle: Text(
                                      'Created by ${posts[index]["author"].toString().characters.take(15)} on ${posts[index]["date"].toString().characters.take(10)}'),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      FavoriteButton(
                                          iconSize: 30.0,
                                          valueChanged: (isFavorite) {
                                            setState(() {
                                              isFavorite = true;
                                              if (favoritePosts
                                                  .contains(posts[index])) {
                                                favoritePosts
                                                    .remove(posts[index]);
                                                print('item already added');
                                              } else {
                                                favoritePosts.add(posts[index]);
                                              }
                                              print(favoritePosts);
                                            });
                                          }),
                                    ],
                                  ),
                                )),
                          ),
                        );
                      });
                },
              )
            : BlocBuilder<MainCubit, String>(
                builder: (context, state) {
                  return ListView.builder(
                      itemCount: favoritePosts.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 10.0,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PostDetails(
                                    name: posts[index]['author'],
                                    title: posts[index]['title'],
                                    description: posts[index]['description'],
                                    url: posts[index]['image'],
                                  ),
                                ),
                              );
                              // Move to post details page
                            },
                            onLongPress: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return BlocProvider(
                                      create: (context) => MainCubit(),
                                      child: BlocBuilder<MainCubit, String>(
                                        builder: (context, state) {
                                          return AlertDialog(
                                            title: const Text("Delete Post"),
                                            content: Text(
                                                "Do you want to delete this post?"),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    context.read().delete(
                                                        posts[index]['_id']);

                                                    Navigator.of(context).pop();
                                                  });
                                                },
                                                child: Text('Delete'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text("Cancel"),
                                              )
                                            ],
                                          );
                                        },
                                      ),
                                    );
                                  });
                            },
                            child: Container(
                                padding: EdgeInsets.all(10.0),
                                child: ListTile(
                                  leading: Image.network(Uri.parse(
                                                    posts[index]['image'])
                                                .isAbsolute &&
                                            posts[index].containsKey('image')
                                        ? '${posts[index]['image']}'
                                        : 'https://cdn.pixabay.com/photo/2019/02/19/19/45/thumbs-up-4007573_1280.png'),
                                  
                                  title: Text(
                                    '${posts[index]["title"].toString().characters.take(20)}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                      'Created by ${posts[index]["author"].toString().characters.take(15)} on ${posts[index]["date"].toString().characters.take(10)}'),
                                )),
                          ),
                        );
                      });
                },
              ),
      ),
    );
  }
}
