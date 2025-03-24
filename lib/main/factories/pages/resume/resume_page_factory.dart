import '../../../../ui/pages/pages.dart';
import 'resume.dart';

ResumePage makeResumePage() =>
    ResumePage(resumePresenter: makeGetxResumePresenter());
