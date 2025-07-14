import {Timestamp} from "firebase-admin/firestore";
import {WorkoutInsight} from "../types/insight";

/**
 * Creates a WorkoutInsight object with all default values
 * @return {WorkoutInsight} The object with blank values.
 */
export function createNewInsight(): WorkoutInsight {
  return {
    id: "",
    date: Timestamp.fromDate(new Date()),
    workout_count: 0,
    total_sets: 0,
    total_repetitions: 0,
    total_weight: 0,
    total_run_distance: 0,
    total_run_duration: 0,
    total_elevation: 0,
    total_swim_distance: 0,
    total_swim_duration: 0,
    total_laps: 0,
    exercise_id_most_activities: "",
    exercise_occurrence_counts: {},
    activity_id_most_elevation: "",
    activity_id_most_laps: "",
    activity_id_most_run_distance: "",
    activity_id_most_run_duration: "",
    activity_id_most_swim_distance: "",
    activity_id_most_swim_duration: "",
    activity_id_most_repetitions: "",
    activity_id_most_weight: "",
    highest_weight_value: 0,
    highest_weight_set_index: 0,
    highest_laps_value: 0,
    highest_laps_set_index: 0,
    highest_run_distance_value: 0,
    highest_run_distance_set_index: 0,
    highest_swim_distance_value: 0,
    highest_swim_distance_set_index: 0,
    highest_elevation_value: 0,
    highest_elevation_set_index: 0,
    highest_run_duration_value: 0,
    highest_run_duration_set_index: 0,
    highest_swim_duration_value: 0,
    highest_swim_duration_set_index: 0,
    highest_repetitions_value: 0,
    highest_repetitions_set_index: 0,
    exercise_set_counts: {},
    exercise_id_most_sets: "",
  };
}
