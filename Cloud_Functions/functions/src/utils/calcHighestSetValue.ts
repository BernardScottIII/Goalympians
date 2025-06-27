import { ResistanceSet, RunSet, SwimSet, WorkoutActivity } from "../types/activity";
import { WorkoutInsight } from "../types/insight";

export function validateResistanceSetInsights(
    currentInsight: WorkoutInsight,
    currentActivity: WorkoutActivity
) {
    const sets = currentActivity.activity_sets as ResistanceSet[];
    for(let set of sets) {
        if(set.weight > currentInsight.highest_weight_value) {
            currentInsight.highest_weight_value = set.weight;
            currentInsight.highest_weight_set_index = set.set_index;
            currentInsight.activity_id_most_weight = currentActivity.id;
        }

        if(set.repetitions > currentInsight.highest_repetitions_value) {
            currentInsight.highest_repetitions_value = set.repetitions;
            currentInsight.highest_repetitions_set_index = set.set_index;
            currentInsight.activity_id_most_repetitions = currentActivity.id;
        }
    }
}

export function validateRunSetInsights(
    currentInsight: WorkoutInsight,
    currentActivity: WorkoutActivity
) {
    const sets = currentActivity.activity_sets as RunSet[];
    for(let set of sets) {
        if(set.distance > currentInsight.highest_run_distance_value) {
            currentInsight.highest_run_distance_value = set.distance;
            currentInsight.highest_run_distance_set_index = set.set_index;
            currentInsight.activity_id_most_run_distance = currentActivity.id;
        }

        if(set.elevation > currentInsight.highest_elevation_value) {
            currentInsight.highest_elevation_value = set.elevation;
            currentInsight.highest_elevation_set_index = set.set_index;
            currentInsight.activity_id_most_elevation = currentActivity.id;
        }

        if(set.duration > currentInsight.highest_run_duration_value) {
            currentInsight.highest_run_duration_value = set.duration;
            currentInsight.highest_run_duration_set_index = set.set_index;
            currentInsight.activity_id_most_run_duration = currentActivity.id;
        }
    }
}

export function validateSwimSetInsights(
    currentInsight: WorkoutInsight,
    currentActivity: WorkoutActivity
) {
    const sets = currentActivity.activity_sets as SwimSet[];
    for(let set of sets) {
        if(set.distance > currentInsight.highest_swim_distance_value) {
            currentInsight.highest_swim_distance_value = set.distance;
            currentInsight.highest_swim_distance_set_index = set.set_index;
            currentInsight.activity_id_most_run_distance = currentActivity.id;
        }

        if(set.laps > currentInsight.highest_laps_value) {
            currentInsight.highest_laps_value = set.laps;
            currentInsight.highest_laps_set_index = set.set_index;
            currentInsight.activity_id_most_laps = currentActivity.id;
        }

        if(set.duration > currentInsight.highest_swim_duration_value) {
            currentInsight.highest_swim_duration_value = set.duration;
            currentInsight.highest_swim_duration_set_index = set.set_index;
            currentInsight.activity_id_most_swim_duration = currentActivity.id;
        }
    }
}