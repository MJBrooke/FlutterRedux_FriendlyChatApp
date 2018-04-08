import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';

const String _name = "Your Name";

//ACTIONS
class OnMessageAddedAction {
  final String newMessage;

  OnMessageAddedAction(this.newMessage);
}

//APP_STATE
@immutable
class AppState {
  final List<String> messages;

  AppState({this.messages = const []});

  factory AppState.initialState() {
    return new AppState(messages: const []);
  }

  AppState copyWith({List<String> messages}) {
    return AppState(messages: messages ?? this.messages);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AppState && runtimeType == other.runtimeType && messages == other.messages;

  @override
  int get hashCode => messages.hashCode;

  @override
  String toString() {
    return 'AppState{messages: $messages}';
  }
}

//REDUCERS
AppState appStateReducer(AppState state, dynamic action) {
  return AppState(messages: messagesReducer(state.messages, action));
}

final messagesReducer = combineReducers<List<String>>([TypedReducer<List<String>, OnMessageAddedAction>(_addMessage)]);

List<String> _addMessage(List<String> messages, OnMessageAddedAction action) {
  return List.from(messages)..insert(0, action.newMessage);
}

//APP
void main() {
  final store = Store<AppState>(appStateReducer, initialState: AppState.initialState());

  runApp(FriendlychatApp(store));
}

class FriendlychatApp extends StatelessWidget {
  final Store<AppState> store;

  FriendlychatApp(this.store);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: "Friendlychat",
        home: ChatScreen(),
      ),
    );
  }
}

class ChatScreen extends StatelessWidget {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<String>>(
        converter: (store) => store.state.messages,
        builder: (context, messages) {
          return Scaffold(
            appBar: AppBar(title: Text("Friendlychat")),
            body: Column(
              children: <Widget>[
                Flexible(
                    child: ListView.builder(
                        padding: new EdgeInsets.all(8.0),
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (_, int idx) {
                          return ChatMessage(messages[idx]);
                        })),
                Divider(height: 1.0),
                Container(
                  decoration: BoxDecoration(color: Theme.of(context).cardColor),
                  child: _buildTextComposer(context),
                ),
              ],
            ),
          );
        });
  }

  Widget _buildTextComposer(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: new StoreConnector<AppState, VoidCallback>(converter: (store) {
          return () {
            store.dispatch(new OnMessageAddedAction(_textController.text));
            _textController.clear();
          };
        }, builder: (context, callback) {
          return Row(children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: (_) => callback(),
                decoration: InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            Container(margin: EdgeInsets.symmetric(horizontal: 4.0), child: IconButton(icon: Icon(Icons.send), onPressed: callback)),
          ]);
        }),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(child: Text(_name[0])),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(_name, style: Theme.of(context).textTheme.subhead),
              Container(
                margin: EdgeInsets.only(top: 5.0),
                child: Text(text),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
