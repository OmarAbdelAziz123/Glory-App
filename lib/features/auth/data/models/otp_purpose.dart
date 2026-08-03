enum OtpPurpose {
  registration,
  passwordReset,
}

String otpPurposeToApi(OtpPurpose purpose) => switch (purpose) {
      OtpPurpose.registration => 'REGISTRATION',
      OtpPurpose.passwordReset => 'PASSWORD_RESET',
    };

OtpPurpose otpPurposeFromApi(String value) => switch (value) {
      'REGISTRATION' => OtpPurpose.registration,
      'PASSWORD_RESET' => OtpPurpose.passwordReset,
      _ => OtpPurpose.registration,
    };
