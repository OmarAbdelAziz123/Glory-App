import 'package:flutter/material.dart';
import 'package:glory_gym/core/core.dart';

import '../../domain/entities/body_measurement_entity.dart';
import '../widgets/body_records_list_view.dart';

final class BodyCompositionScreen extends StatelessWidget {
  const BodyCompositionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BodyRecordsScreenShell(
      title: context.l10n.bodyCompositionScan,
      type: BodyRecordType.inBodyTest,
    );
  }
}
