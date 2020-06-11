import 'package:flutter/material.dart';
import 'package:settle_assessment/utils/constant.dart';

class CustomTile extends StatefulWidget {
  final String title;
  final String firstOption;
  final String secondOption;
  final String firstLabel;
  final String secondLabel;
  final FieldRequire type;
  final Future<bool> Function(String) onChangeFirstText;
  final Future<bool> Function(String) onChangeSecondText;
  final Function(OptionType) onChangeOption;
  final Stream<OptionType> result$;
  final bool isNumber;

  CustomTile({
    @required this.title,
    @required this.firstOption,
    @required this.secondOption,
    @required this.firstLabel,
    @required this.onChangeFirstText,
    @required this.onChangeOption,
    @required this.result$,
    @required this.type,
    this.isNumber = false,
    this.secondLabel = '',
    this.onChangeSecondText,
  });

  @override
  _CustomTileState createState() => _CustomTileState();
}

class _CustomTileState extends State<CustomTile> {
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();

    widget.result$.listen(
      (event) => setState(() => isExpanded = event == OptionType.useConfigure),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Card(
        elevation: 12,
        color: Colors.white70,
        child: ExpansionTile(
          key: new GlobalKey(),
          initiallyExpanded: isExpanded,
          maintainState: isExpanded,
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.title,
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _OptionText(
                label: widget.firstOption,
                type: OptionType.useDefault,
                onChange: widget.onChangeOption,
                value$: widget.result$,
              ),
              _OptionText(
                label: widget.secondOption,
                type: OptionType.useConfigure,
                onChange: widget.onChangeOption,
                value$: widget.result$,
              ),
            ],
          ),
          children: getChildren(),
        ),
      ),
    );
  }

  List<Widget> getChildren() {
    final List<Widget> widgets = List<Widget>();
    widgets.add(_CustomField(
      defaultValue: widget.firstLabel,
      enable$: widget.result$,
      isNumber: widget.isNumber,
      onChange: widget.onChangeFirstText,
    ));

    switch (widget.type) {
      case FieldRequire.single:
        break;
      case FieldRequire.dual:
        widgets.add(_CustomField(
          defaultValue: widget.secondLabel,
          enable$: widget.result$,
          isNumber: widget.isNumber,
          onChange: widget.onChangeSecondText,
        ));
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
      onTap: () => onChange(type),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            StreamBuilder<OptionType>(
              stream: value$,
              builder: (ctx, snapshot) => Checkbox(
                value: snapshot.data == type,
                onChanged: (value) => onChange(type),
              ),
            ),
            Text(label),
          ],
        ),
      ),
    );
  }
}

class _CustomField extends StatefulWidget {
  final Stream<OptionType> enable$;
  final String label;
  final bool isNumber;
  final Future<bool> Function(String) onChange;

  _CustomField(
      {@required this.enable$,
      @required String defaultValue,
      @required this.onChange,
      this.isNumber = false})
      : this.label = defaultValue;

  @override
  __CustomFieldState createState() => __CustomFieldState();
}

class __CustomFieldState extends State<_CustomField> {
  final TextEditingController _controller;
  bool insertedValue = false;
  String _errMessage;

  __CustomFieldState() : _controller = TextEditingController();
  @override
  void initState() {
    super.initState();

    _controller.addListener(() async {
      try {
        if(_controller.text.length > 0 && insertedValue == false) insertedValue = true;

        await widget.onChange(_controller.text);

        setState(() => _errMessage = null);
      } catch (err) {
        if (insertedValue)
          setState(() => _errMessage = err);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<OptionType>(
      stream: widget.enable$,
      builder: (ctx, snapshot) => Padding(
        padding: const EdgeInsets.all(12.0),
        child: TextField(
          keyboardType: widget.isNumber
              ? TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
          enabled: snapshot.data != OptionType.useDefault,
          controller: _controller,
          decoration: InputDecoration(
            errorText: _errMessage,
            labelText: widget.label,
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
