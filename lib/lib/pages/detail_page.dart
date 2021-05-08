import 'package:flutter/material.dart';
import 'package:mem_stuff/lib/controllers/detail_controller.dart';
import 'package:mem_stuff/lib/core/app_const.dart';
import 'package:mem_stuff/lib/models/stuff_model.dart';
import 'package:mem_stuff/lib/repositories/stuff_repository_impl.dart';
import 'package:mem_stuff/lib/widgets/date_input_field.dart';
import 'package:mem_stuff/lib/widgets/number_input_field.dart';
import 'package:mem_stuff/lib/widgets/photo_input_area.dart';
import 'package:mem_stuff/lib/widgets/primary_button.dart';
import 'package:mem_stuff/lib/widgets/text_input_field.dart';
import 'package:mem_stuff/lib/widgets/loading_dialog.dart';

class DetailPage extends StatefulWidget {
  final StuffModel stuff;

  const DetailPage({
    Key key,
    this.stuff,
  }) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = DetailController(StuffRepositoryImpl());

  @override
  void initState() {
    _controller.setId(widget.stuff?.id);
    _controller.setPhoto(widget.stuff?.photoPath);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.stuff == null ? kTitleNewLoad : kTitleDetails),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: _buildForm(),
      ),
    );
  }

  _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PhotoInputArea(
            initialValue: widget.stuff?.photoPath ?? '',
            onChanged: _controller.setPhoto,
          ),
          TextInputField(
            label: kLabelDescription,
            icon: Icons.description_outlined,
            initialValue: widget.stuff?.description ?? '',
            onSaved: _controller.setDescription,
          ),
          TextInputField(
            label: kLabelName,
            icon: Icons.person_outline,
            initialValue: widget.stuff?.contactName ?? '',
            onSaved: _controller.setName,
          ),
          DateInputField(
            label: kLabelLoadDate,
            initialValue: widget.stuff?.date ?? '',
            onSaved: _controller.setDate,
          ),
          NumberInputField(
            label: kLabelPhone,
            icon: Icons.phone,
            initialValue: widget.stuff?.phone ?? '',
            onSaved: _controller.setPhone,
            
          ),
          PrimaryButton(
            label: kButtonSave,
            onPressed: _onSave,
          ),
        ],
      ),
    );
  }

  Future _onSave() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      LoadingDialog.show(
        context,
        message: widget.stuff == null ? 'Salvando...' : 'Atualizando...',
      );
      await _controller.save();
      LoadingDialog.hide();
      Navigator.of(context).pop();
    }
  }
}
