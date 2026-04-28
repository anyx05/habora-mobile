enum BookingErrorCode {
  berthNotFound,
  vesselTooLong,
  vesselTooDeep,
  berthUnavailable,
  unknown,
}

class BookingException implements Exception {
  final BookingErrorCode code;
  final String? rawMessage;

  const BookingException(this.code, [this.rawMessage]);

  factory BookingException.fromCode(String? pgCode, String? message) {
    return switch (pgCode) {
      'P0001' => BookingException(BookingErrorCode.berthNotFound, message),
      'P0002' => BookingException(BookingErrorCode.vesselTooLong, message),
      'P0003' => BookingException(BookingErrorCode.vesselTooDeep, message),
      'P0004' => BookingException(BookingErrorCode.berthUnavailable, message),
      _       => BookingException(BookingErrorCode.unknown, message),
    };
  }

  @override
  String toString() => 'BookingException(${code.name}): $rawMessage';
}
