import {
  ResistanceSet,
  RunSet,
  SwimSet,
  WorkoutActivity,
} from "../types/activity";
import {WorkoutInsight} from "../types/insight";

/**
 * Checks the current activity and sees if it breaks any records. Only use when
 * currentActivity.set_type is ResistanceSet
 * @param {WorkoutInsight} currentInsight - The user's insight document for the
 * current month
 * @param {WorkoutActivity} currentActivity - The activity to be analyzed
 */
export function validateResistanceSetInsights(
  currentInsight: WorkoutInsight,
  previousActivity: WorkoutActivity,
  currentActivity: WorkoutActivity
) {
  const prevSets = previousActivity.activity_sets as ResistanceSet[];
  const currSets = currentActivity.activity_sets as ResistanceSet[];

  // just set to zero to force recomputation
  if (
    currentActivity.id == currentInsight.activity_id_most_weight ||
    currentActivity.id == currentInsight.activity_id_most_repetitions
  ) {
    // If the current activity's id matches the id of the set with the PR...
    // AND the sets const does NOT include the PR set...
    //    How do we determine if the set has gone missing?
    //    compare previous and current Activity
    //    If previous activity contains PR
    //    AND  current activity does not
    // set value to -1
    // set set_index to -1
    // set id to ""

    if (!currSets.includes(prevSets[currentInsight.highest_weight_set_index])) {
      // The drawback with this is that if the PR exists in another workout,
      // this function won't be able to see it
      currentInsight.activity_id_most_weight = "";
      currentInsight.highest_weight_value = -1;
      currentInsight.highest_weight_set_index = -1;
    }

    if (!currSets.includes(prevSets[currentInsight.highest_repetitions_set_index])) {
      currentInsight.activity_id_most_repetitions = "";
      currentInsight.highest_repetitions_value = -1;
      currentInsight.highest_repetitions_set_index = -1;
    }
  }

  for (const set of currSets) {
    if (set.weight > currentInsight.highest_weight_value) {
      currentInsight.highest_weight_value = set.weight;
      currentInsight.highest_weight_set_index = set.set_index;
      currentInsight.activity_id_most_weight = currentActivity.id;
    }

    if (set.repetitions > currentInsight.highest_repetitions_value) {
      currentInsight.highest_repetitions_value = set.repetitions;
      currentInsight.highest_repetitions_set_index = set.set_index;
      currentInsight.activity_id_most_repetitions = currentActivity.id;
    }
  }
}

/**
 * Checks the current activity and sees if it breaks any records. Only use when
 * currentActivity.set_type is RunSet
 * @param {WorkoutInsight} currentInsight - The user's insight document for the
 * current month
 * @param {WorkoutActivity} currentActivity - The activity to be analyzed
 */
export function validateRunSetInsights(
  currentInsight: WorkoutInsight,
  previousActivity: WorkoutActivity,
  currentActivity: WorkoutActivity
) {
  const prevSets = previousActivity.activity_sets as RunSet[];
  const currSets = currentActivity.activity_sets as RunSet[];

  if (
    currentActivity.id == currentInsight.activity_id_most_run_distance ||
    currentActivity.id == currentInsight.activity_id_most_elevation ||
    currentActivity.id == currentInsight.activity_id_most_run_duration
  ) {
    if (!currSets.includes(prevSets[currentInsight.highest_run_distance_set_index])) {
      currentInsight.activity_id_most_run_distance = "";
      currentInsight.highest_run_distance_value = -1;
      currentInsight.highest_run_distance_set_index = -1;
    }

    if (!currSets.includes(prevSets[currentInsight.highest_elevation_set_index])) {
      currentInsight.activity_id_most_elevation = "";
      currentInsight.highest_elevation_value = -1;
      currentInsight.highest_elevation_set_index = -1;
    }

    if (!currSets.includes(prevSets[currentInsight.highest_run_duration_set_index])) {
      currentInsight.activity_id_most_run_duration = "";
      currentInsight.highest_run_duration_value = -1;
      currentInsight.highest_run_duration_set_index = -1;
    }
  }

  for (const set of currSets) {
    if (set.distance > currentInsight.highest_run_distance_value) {
      currentInsight.highest_run_distance_value = set.distance;
      currentInsight.highest_run_distance_set_index = set.set_index;
      currentInsight.activity_id_most_run_distance = currentActivity.id;
    }

    if (set.elevation > currentInsight.highest_elevation_value) {
      currentInsight.highest_elevation_value = set.elevation;
      currentInsight.highest_elevation_set_index = set.set_index;
      currentInsight.activity_id_most_elevation = currentActivity.id;
    }

    if (set.duration > currentInsight.highest_run_duration_value) {
      currentInsight.highest_run_duration_value = set.duration;
      currentInsight.highest_run_duration_set_index = set.set_index;
      currentInsight.activity_id_most_run_duration = currentActivity.id;
    }
  }
}

/**
 * Checks the current activity and sees if it breaks any records. Only use when
 * currentActivity.set_type is SwimSet
 * @param {WorkoutInsight} currentInsight - The user's insight document for the
 * current month
 * @param {WorkoutActivity} currentActivity - The activity to be analyzed
 */
export function validateSwimSetInsights(
  currentInsight: WorkoutInsight,
  previousActivity: WorkoutActivity,
  currentActivity: WorkoutActivity
) {
  const prevSets = previousActivity.activity_sets as SwimSet[];
  const currSets = currentActivity.activity_sets as SwimSet[];

  if (
    currentActivity.id == currentInsight.activity_id_most_swim_distance ||
    currentActivity.id == currentInsight.activity_id_most_laps ||
    currentActivity.id == currentInsight.activity_id_most_swim_duration
  ) {
    if (!currSets.includes(prevSets[currentInsight.highest_swim_distance_set_index])) {
      currentInsight.activity_id_most_swim_distance = "";
      currentInsight.highest_swim_distance_value = -1;
      currentInsight.highest_swim_distance_set_index = -1;
    }

    if (!currSets.includes(prevSets[currentInsight.highest_laps_set_index])) {
      currentInsight.activity_id_most_laps = "";
      currentInsight.highest_laps_value = -1;
      currentInsight.highest_laps_set_index = -1;
    }

    if (!currSets.includes(prevSets[currentInsight.highest_swim_duration_set_index])) {
      currentInsight.activity_id_most_swim_duration = "";
      currentInsight.highest_swim_duration_value = -1;
      currentInsight.highest_swim_duration_set_index = -1;
    }
  }

  for (const set of currSets) {
    if (set.distance > currentInsight.highest_swim_distance_value) {
      currentInsight.highest_swim_distance_value = set.distance;
      currentInsight.highest_swim_distance_set_index = set.set_index;
      currentInsight.activity_id_most_run_distance = currentActivity.id;
    }

    if (set.laps > currentInsight.highest_laps_value) {
      currentInsight.highest_laps_value = set.laps;
      currentInsight.highest_laps_set_index = set.set_index;
      currentInsight.activity_id_most_laps = currentActivity.id;
    }

    if (set.duration > currentInsight.highest_swim_duration_value) {
      currentInsight.highest_swim_duration_value = set.duration;
      currentInsight.highest_swim_duration_set_index = set.set_index;
      currentInsight.activity_id_most_swim_duration = currentActivity.id;
    }
  }
}
