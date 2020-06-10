import 'package:flutter/material.dart';
import 'package:settle_assessment/utils/constant.dart';



class CustomTile extends StatelessWidget {
  final String title;
  final String firstOption;
  final String secondOption;
  final String firstLabel;
  final String secondLabel;
  final FieldRequire type;
  final Function(String) onChangeFirstText;
  final Function(String) onChangeSecondText;
  final Function(OptionType) onChangeOption;
  final Stream<OptionType> result$;

  CustomTile({
    @required this.title,
    @required this.firstOption,
    @required this.secondOption,
    @required this.firstLabel,
    @required this.onChangeFirstText,
    @required this.onChangeOption,
    @required this.result$,    
    @required this.type ,
    this.secondLabel = '',
    this.onChangeSecondText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Card(
        elevation: 12,
        color: Colors.white70,
        child: ExpansionTile(
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _OptionText(label: firstOption, type: OptionType.useDefault, onChange: onChangeOption, value$: result$,),
              _OptionText(label: secondOption, type: OptionType.useConfigure, onChange: onChangeOption, value$: result$,),
            ],
          ),
          children: getChildren(),
        ),
      ),
    );
  }

  List<Widget> getChildren() {
    final List<Widget> widgets = List<Widget>();
    widgets.add(_CustomField(defaultValue: firstLabel, enable$: result$,));

    switch(type){
      
      case FieldRequire.single:
        break;
      case FieldRequire.dual:
        widgets.add(_CustomField(defaultValue: secondLabel, enable$: result$,));
        break;
    }

    return widgets;
  }
}

class _OptionText extends StatelessWidget {
  final OptionType type;
  final Function(OptionType) onChange;
  final Stream<OptionType> value$;
  final String label;

  _OptionText({
    @required this.label,
    @required this.onChange,
    @required this.value$,
    @required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onChange(type),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            StreamBuilder<OptionType>(
              stream: value$,
              builder: (ctx, snapshot) => Checkbox(
                value: snapshot.data == OptionType.useConfigure,
                onChanged: (value) => onChange(type),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(label),
            )
          ],
        ),
      ),
    );
  }
}

class _CustomField extends StatelessWidget {
  final TextEditingController _controller;
  final Stream<OptionType> enable$;

  _CustomField({@required this.enable$, @required String defaultValue})
      : _controller = TextEditingController(text: defaultValue);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<OptionType>(
      stream: enable$,
      builder: (ctx, snapshot) => TextField(
        readOnly: snapshot.data == OptionType.useDefault,
        controller: _controller,
        decoration: InputDecoration(
          labelText: 'Value',
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
