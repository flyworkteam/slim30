String _normalizeExerciseName(String raw) {
  return raw
      .replaceAll('\u00A0', ' ')
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

String _basenameWithoutExtension(String pathLike) {
  final normalizedPath = pathLike.replaceAll('\\', '/');
  final parts = normalizedPath.split('/');
  final last = parts.isEmpty ? pathLike : parts.last;
  final dotIndex = last.lastIndexOf('.');
  if (dotIndex <= 0) {
    return last;
  }
  return last.substring(0, dotIndex);
}

const Map<String, String> _canonicalAliasByNormalizedName = {
  'modified push up': 'push up',
  'knee push up': 'push up',
  'incline push up': 'push up',
};

const Map<String, String> _videoUrlByNormalizedName = {
  'skater jump': 'https://slim30.b-cdn.net/workouts/v1/Skater_Jump.mp4',
  'glute bridge march':
      'https://slim30.b-cdn.net/workouts/v1/Glute_Bridge_March.mp4',
  'plank jack': 'https://slim30.b-cdn.net/workouts/v1/Plank_Jack.mp4',
  'sumo squat': 'https://slim30.b-cdn.net/workouts/v1/sumo_squat.mp4',
  'jumping jack': 'https://slim30.b-cdn.net/workouts/v1/Jumping_Jack.mp4',
  'plank': 'https://slim30.b-cdn.net/workouts/v1/Plank.mp4',
  'standing calf raise':
      'https://slim30.b-cdn.net/workouts/v1/Standing_Calf_Raise.mp4',
  'wall sit': 'https://slim30.b-cdn.net/workouts/v1/Wall_Sit.mp4',
  'push up': 'https://slim30.b-cdn.net/workouts/v1/Push-Up.mp4',
  'butt kicks': 'https://slim30.b-cdn.net/workouts/v1/Butt_Kicks.mp4',
  'bodyweight squat':
      'https://slim30.b-cdn.net/workouts/v1/Bodyweight_Squat.mp4',
  'mountain climber':
      'https://slim30.b-cdn.net/workouts/v1/Mountain_Climber.mp4',
  'jump squat': 'https://slim30.b-cdn.net/workouts/v1/jump_squat.mp4',
  'burpee': 'https://slim30.b-cdn.net/workouts/v1/Burpee.mp4',
  'reverse lunge': 'https://slim30.b-cdn.net/workouts/v1/Reverse_Lunge.mp4',
  'fast feet shuffle':
      'https://slim30.b-cdn.net/workouts/v1/Fast_Feet_Shuffle.mp4',
  'squat thrust': 'https://slim30.b-cdn.net/workouts/v1/Squat_Thrust.mp4',
  'step back kick': 'https://slim30.b-cdn.net/workouts/v1/Step_Back_Kick.mp4',
  'high knees': 'https://slim30.b-cdn.net/workouts/v1/High_Knees.mp4',
  'side step squat': 'https://slim30.b-cdn.net/workouts/v1/Side_Step_Squat.mp4',
  'glute bridge': 'https://slim30.b-cdn.net/workouts/v1/glute_bridge.mp4',
  'jump rope':
      'https://slim30.b-cdn.net/workouts/v1/Jump_Rope__ipsiz_simu_lasyon_dahil_.mp4',
  'plank shoulder tap':
      'https://slim30.b-cdn.net/workouts/v1/Plank_Shoulder_Tap.mp4',
  'marching plank': 'https://slim30.b-cdn.net/workouts/v1/marching_plank.mp4',
  'standing knee drive':
      'https://slim30.b-cdn.net/workouts/v1/Standing_Knee_Drive.mp4',
  'side lunge': 'https://slim30.b-cdn.net/workouts/v1/Side_Lunge.mp4',
  'shadow boxing': 'https://slim30.b-cdn.net/workouts/v1/Shadow_Boxing.mp4',
  'walking lunge': 'https://slim30.b-cdn.net/workouts/v1/Walking_Lunge.mp4',
};

String? resolveExerciseVideoUrl(String title) {
  return resolveExerciseVideoUrlByMedia(mediaPath: '', title: title);
}

String? resolveExerciseVideoUrlByMedia({
  required String mediaPath,
  required String title,
}) {
  final mediaBase = _normalizeExerciseName(
    _basenameWithoutExtension(mediaPath),
  );
  if (mediaBase.isNotEmpty) {
    final mediaCanonical =
        _canonicalAliasByNormalizedName[mediaBase] ?? mediaBase;
    final mediaUrl = _videoUrlByNormalizedName[mediaCanonical];
    if (mediaUrl != null) {
      return mediaUrl;
    }
  }

  final titleBase = _normalizeExerciseName(title);
  if (titleBase.isEmpty) {
    return null;
  }

  final titleCanonical =
      _canonicalAliasByNormalizedName[titleBase] ?? titleBase;
  return _videoUrlByNormalizedName[titleCanonical];
}
