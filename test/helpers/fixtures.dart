/// Shared API JSON fixtures matching the mobile backend contract.
library;

const qrGenerateJson = {
  'id': 'cm123',
  'token': 'b6f2-uuid-token',
  'expiresAt': '2026-08-01T18:20:00.000Z',
  'expiresInSeconds': 20,
};

const qrStatusPendingJson = {
  'id': 'cm123',
  'status': 'PENDING',
  'expiresAt': '2026-08-01T18:20:00.000Z',
  'consumedAt': null,
  'checkIn': null,
  'daysRemaining': null,
};

const qrStatusConsumedJson = {
  'id': 'cm123',
  'status': 'CONSUMED',
  'expiresAt': '2026-08-01T18:20:00.000Z',
  'consumedAt': '2026-08-01T18:20:05.000Z',
  'checkIn': {'id': 'checkin-1'},
  'daysRemaining': 12,
};

const bookingJson = {
  'id': 'booking-1',
  'type': 'PT',
  'status': 'PENDING',
  'channel': 'APP',
  'dateTime': '2026-08-01T18:20:00.000Z',
  'checkedInAt': null,
  'package': {
    'id': 'pkg-1',
    'nameEn': 'PT Package',
    'nameAr': 'باقة تدريب شخصي',
    'membershipType': 'PT',
  },
  'branch': {'id': 'branch-1', 'nameEn': '6th October'},
  'instructor': {
    'id': 'coach-1',
    'fullName': 'احمد حسام',
    'avatarUrl': null,
  },
  'subscription': {'id': 'sub-1', 'remainingSessions': 3},
  'canCancel': true,
  'canCheckIn': true,
  'canRate': false,
};

final bookingCheckedInJson = {
  'id': 'booking-1',
  'type': 'PT',
  'status': 'PENDING',
  'channel': 'APP',
  'dateTime': '2026-08-01T18:20:00.000Z',
  'checkedInAt': '2026-08-01T18:22:00.000Z',
  'package': bookingJson['package'],
  'branch': bookingJson['branch'],
  'instructor': bookingJson['instructor'],
  'subscription': bookingJson['subscription'],
  'canCancel': false,
  'canCheckIn': false,
  'canRate': true,
};

const notificationJson = {
  'id': 'notif-1',
  'titleEn': 'Get 4 months free',
  'titleAr': 'اوفر شهر 4',
  'bodyEn': 'English body',
  'bodyAr': 'اور شهرين بقيمة 90 دينار',
  'type': 'PUSH',
  'imageUrl': null,
  'read': false,
  'readAt': null,
  'createdAt': '2026-08-01T09:00:00.000Z',
};

const assessmentQuestionJson = {
  'id': 'q1',
  'questionEn': 'How would you rate the coach?',
  'questionAr': 'ما مدى تقييمك لأداء المدرب؟',
  'sortOrder': 1,
};

const workoutListItemJson = {
  'id': 'assignment-1',
  'status': 'IN_PROGRESS',
  'workout': {
    'id': 'workout-1',
    'nameEn': 'Cardio Program',
    'nameAr': 'برنامج كارديو',
    'type': 'CARDIO',
    'level': 'BEGINNER',
  },
  'startDate': '2026-05-01T00:00:00.000Z',
  'endDate': '2026-06-10T00:00:00.000Z',
  'durationDays': 40,
  'instructor': {
    'id': 'coach-1',
    'fullName': 'احمد حسام محمد',
    'avatarUrl': null,
  },
  'previewVideoUrl': 'https://player.vimeo.com/video/111',
  'previewThumbnailUrl': 'https://i.vimeocdn.com/thumb.jpg',
};

const workoutUpcomingListItemJson = {
  'id': 'assignment-2',
  'status': 'UPCOMING',
  'workout': {
    'id': 'workout-2',
    'nameEn': 'Strength Program',
    'nameAr': 'برنامج قوة',
    'type': 'STRENGTH',
    'level': 'INTERMEDIATE',
  },
  'startDate': null,
  'endDate': null,
  'durationDays': 30,
  'instructor': {
    'id': 'coach-2',
    'fullName': 'سارة علي',
    'avatarUrl': null,
  },
  'previewVideoUrl': null,
  'previewThumbnailUrl': null,
};

const workoutDetailJson = {
  'id': 'assignment-1',
  'status': 'IN_PROGRESS',
  'startDate': '2026-05-01T00:00:00.000Z',
  'endDate': '2026-06-10T00:00:00.000Z',
  'durationDays': 40,
  'remainingDays': 22,
  'suggestedWeight': '10.00',
  'suggestedWeightLast': null,
  'userWeight': null,
  'userWeightLast': null,
  'canAddWeight': true,
  'instructor': {
    'id': 'coach-1',
    'fullName': 'احمد حسام محمد',
    'avatarUrl': null,
  },
  'workout': {
    'id': 'workout-1',
    'nameEn': 'Cardio Program',
    'nameAr': 'برنامج كارديو',
    'type': 'CARDIO',
    'level': 'BEGINNER',
    'durationDays': 40,
  },
  'instructions': [
    {
      'id': 'step-1',
      'stepNumber': 1,
      'instructionEn': 'Cardio',
      'instructionAr': 'كارديو',
      'videos': [
        {
          'id': 'video-1',
          'videoUrl': 'https://player.vimeo.com/video/111',
          'thumbnailUrl': 'https://i.vimeocdn.com/thumb1.jpg',
          'duration': '02:10',
        },
      ],
    },
    {
      'id': 'step-2',
      'stepNumber': 2,
      'instructionEn': 'Cardio',
      'instructionAr': 'كارديو',
      'videos': [
        {
          'id': 'video-2',
          'videoUrl': 'https://player.vimeo.com/video/222',
          'thumbnailUrl': 'https://i.vimeocdn.com/thumb2.jpg',
          'duration': '02:10',
        },
      ],
    },
  ],
  'createdAt': '2026-05-01T00:00:00.000Z',
};

final workoutDetailAfterWeightJson = {
  ...workoutDetailJson,
  'userWeight': '20.00',
  'userWeightLast': null,
};

final workoutDetailWithPreviousWeightJson = {
  ...workoutDetailJson,
  'userWeight': '25.00',
  'userWeightLast': '20.00',
};

const workoutVideoJson = {
  'id': 'video-1',
  'videoUrl': 'https://player.vimeo.com/video/111',
  'thumbnailUrl': 'https://i.vimeocdn.com/thumb1.jpg',
  'duration': '01:00',
  'stepNumber': 1,
  'instructionEn': 'Cardio',
  'instructionAr': 'كارديو',
};

/// Matches GET /mobile/workouts seed response.
const workoutSeedListItemJson = {
  'id': 'seed_wa_4',
  'status': 'UPCOMING',
  'workout': {
    'id': 'seed_wo_1',
    'nameEn': 'Cardio Program',
    'nameAr': 'برنامج كارديو',
    'type': 'CARDIO',
    'level': 'BEGINNER',
  },
  'startDate': null,
  'endDate': null,
  'durationDays': 40,
  'instructor': {
    'id': 'seed_user_instr_1',
    'fullName': 'Coach Ahmed',
    'avatarUrl': null,
  },
  'previewVideoUrl': 'https://player.vimeo.com/video/000003',
  'previewThumbnailUrl': 'https://i.vimeocdn.com/video/thumb3.jpg',
};

/// Matches GET /mobile/workouts/{id} seed response.
const workoutSeedDetailJson = {
  'id': 'seed_wa_4',
  'status': 'UPCOMING',
  'startDate': null,
  'endDate': null,
  'durationDays': 40,
  'remainingDays': null,
  'suggestedWeight': null,
  'suggestedWeightLast': null,
  'userWeight': null,
  'userWeightLast': null,
  'canAddWeight': false,
  'instructor': {
    'id': 'seed_user_instr_1',
    'fullName': 'Coach Ahmed',
    'avatarUrl': null,
  },
  'workout': {
    'id': 'seed_wo_1',
    'nameEn': 'Cardio Program',
    'nameAr': 'برنامج كارديو',
    'type': 'CARDIO',
    'level': 'BEGINNER',
    'durationDays': 40,
  },
  'instructions': [
    {
      'id': 'seed_wi_1',
      'stepNumber': 1,
      'instructionEn': 'Warmup',
      'instructionAr': 'إحماء',
      'videos': [
        {
          'id': 'seed_vid_3',
          'videoUrl': 'https://player.vimeo.com/video/000003',
          'thumbnailUrl': 'https://i.vimeocdn.com/video/thumb3.jpg',
          'duration': '02:10',
        },
      ],
    },
    {
      'id': 'seed_wi_2',
      'stepNumber': 2,
      'instructionEn': 'Main set',
      'instructionAr': 'التمرين الأساسي',
      'videos': [
        {
          'id': 'seed_vid_1',
          'videoUrl': 'https://player.vimeo.com/video/000001',
          'thumbnailUrl': 'https://i.vimeocdn.com/video/thumb1.jpg',
          'duration': '02:10',
        },
      ],
    },
  ],
  'createdAt': '2026-09-03T10:58:34.514Z',
};
