export type WorkoutActivity = {
  id: string;
  exercise_id: string;
  set_type: string;
  workout_index: number;
  activity_sets: ActivitySet[];
}

export type ActivitySet = {
    set_index: number;
}

export type ResistanceSet = ActivitySet & {
    weight: number;
    repetitions: number;
}

export type RunSet = ActivitySet & {
    distance: number;
    elevation: number;
    duration: number;
}

export type SwimSet = ActivitySet & {
    distance: number;
    laps: number;
    duration: number;
}