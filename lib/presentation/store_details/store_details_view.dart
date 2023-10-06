import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:new_project/app/di.dart';
import 'package:new_project/domain/models.dart';
import 'package:new_project/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:new_project/presentation/resources/color_manager.dart';
import 'package:new_project/presentation/resources/string_manager.dart';
import 'package:new_project/presentation/resources/values_manager.dart';
import 'package:new_project/presentation/store_details/store_details_viewmodel.dart';

class StoreDetailsView extends StatefulWidget {
  const StoreDetailsView({Key? key}) : super(key: key);

  @override
  _StoreDetailsViewState createState() => _StoreDetailsViewState();
}

class _StoreDetailsViewState extends State<StoreDetailsView> {
  final StoreDetailsViewModel _viewModel = instance<StoreDetailsViewModel>();

  @override
  void initState() {
    bind();
    super.initState();
  }

  bind() {
    _viewModel.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<FlowState>(
          stream: _viewModel.outputState,
          builder: (context, snapshot) {
            return Container(
              child:
              snapshot.data?.getScreenWidget(context, _getContentWidget(), () {
                _viewModel.start();
              }) ??
                  Container(),
            );
          },
        ));
  }

  Widget _getContentWidget() {
    return Scaffold(
        backgroundColor: ColorManger.white,
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(
            //back button
            color: ColorManger.white,
          ),
          backgroundColor: ColorManger.primary,
          centerTitle: true,
        ),
        body: Container(
          constraints: const BoxConstraints.expand(),
          color: ColorManger.white,
          child: SingleChildScrollView(
            child: StreamBuilder<StoreDetails>(
              stream: _viewModel.outStoreDetailsData,
              builder: (context, snapshot) {
                return _getItems(snapshot.data);
              },
            ),
          ),
        ));
  }

  Widget _getItems(StoreDetails? storeDetails) {
    if (storeDetails != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
              child: Image.network(
                storeDetails.image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 250,
              )),
          _getSection(AppStrings.details.tr()),
          _getInfoText(storeDetails.details),
          _getSection(AppStrings.services.tr()),
          _getInfoText(storeDetails.services),
          _getSection(AppStrings.about.tr()),
          _getInfoText(storeDetails.about)
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _getSection(String title) {
    return Padding(
        padding: const EdgeInsets.only(
            top: AppPadding.p12,
            left: AppPadding.p12,
            right: AppPadding.p12,
            bottom: AppPadding.p2),
        child: Text(title, style: Theme.of(context).textTheme.titleMedium));
  }

  Widget _getInfoText(String info) {
    return Padding(
      padding: const EdgeInsets.all(AppSize.z12),
      child: Text(info, style: Theme.of(context).textTheme.bodySmall),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}