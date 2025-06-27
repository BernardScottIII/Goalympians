import * as v2 from "firebase-functions/v2";
import * as admin from "firebase-admin";
import { FieldValue, Timestamp } from "firebase-admin/firestore";
import { Workout } from "../types/workout"
import { currentAndNextMonthStart } from "../utils/currentAndNextMonthStart";
import { ResistanceSet, RunSet, SwimSet, WorkoutActivity } from "../types/activity";
import { sumResistanceSetFields, sumRunSetFields, sumSwimSetFields } from "../utils/setSummation";
import { WorkoutInsight } from "../types/insight";
import { validateResistanceSetInsights, validateRunSetInsights, validateSwimSetInsights } from "../utils/calcHighestSetValue";

const db = admin.firestore();

export const updateTotalSets = v2.firestore
    .onDocumentUpdated("workouts/{workout_id}/activities/{activity_id}", async (event) => {
        try {
            const previous = event.data?.before
            const current = event.data?.after

            const previousData = previous?.data() as WorkoutActivity;
            const currentData = current?.data() as WorkoutActivity;

            // console.log(previousData);
            // console.log(currentData);

            // subtract current.data.activity_sets.count - previous.data.activity_sets.count
            const numActivitySetsDifference = currentData.activity_sets.length - previousData.activity_sets.length;

            const parentWorkoutSnapshot =
            await db.doc(`workouts/${event.params.workout_id}`).get();

            const parentWorkout = parentWorkoutSnapshot.data() as Workout;

            const { currentMonthStart, nextMonthStart } = currentAndNextMonthStart(parentWorkout.date.toDate());

            const startCurrentMonth = Timestamp.fromDate(currentMonthStart);
            const startNextMonth = Timestamp.fromDate(nextMonthStart);

            const insightSnapshot =
            await db.collection(`users/${parentWorkout.userId}/workout_insights`)
                .where("date", ">=", startCurrentMonth)
                .where("date", "<", startNextMonth)
                .get();

            const updatePromises: Promise<FirebaseFirestore.WriteResult>[] = [];

            // take the difference (positive or negative) and add it to user/{user_id}/workout_insights/{insight_id}.total_sets
            insightSnapshot.forEach((doc) => {
                const updatePromise = doc.ref.update({
                    "total_sets": FieldValue.increment(numActivitySetsDifference),
                });
                updatePromises.push(updatePromise);
            });

            await Promise.all(updatePromises);
        } catch (error) {
            console.error("Error updating documents");
            console.log(error);
        }
    });

export const updateTotalWeight = v2.firestore
    .onDocumentUpdated("workouts/{workout_id}/activities/{activity_id}", async (event) => {
        try {
            const previous = event.data?.before
            const current = event.data?.after

            const previousData = previous?.data() as WorkoutActivity;
            const currentData = current?.data() as WorkoutActivity;
            
            // I don't know why TypeScript is upset, but it shouldn't be
            if (currentData.activity_sets.length === 0) {
                console.log("array is empty");
                return;
            }

            // sum up all vals in all sets of previous.activity_sets
            // sum up all vals in all sets of current.activity_sets

            // effectively do current - previous on sets and reps
            // add the difference to the workout insight

            const parentWorkoutSnapshot =
            await db.doc(`workouts/${event.params.workout_id}`).get();

            const parentWorkout = parentWorkoutSnapshot.data() as Workout;

            const { currentMonthStart, nextMonthStart } = currentAndNextMonthStart(parentWorkout.date.toDate());

            const startCurrentMonth = Timestamp.fromDate(currentMonthStart);
            const startNextMonth = Timestamp.fromDate(nextMonthStart);

            const insightSnapshot =
            await db.collection(`users/${parentWorkout.userId}/workout_insights`)
                .where("date", ">=", startCurrentMonth)
                .where("date", "<", startNextMonth)
                .get();

            const updatePromises: Promise<FirebaseFirestore.WriteResult>[] = [];

            // take the difference (positive or negative) and add it to user/{user_id}/workout_insights/{insight_id}.total_sets
            insightSnapshot.forEach((doc) => {
                var updatePromise: Promise<admin.firestore.WriteResult>
                var currentInsight = doc.data() as WorkoutInsight;
                var insightUpdates: ResistanceSet | RunSet | SwimSet;

                switch (currentData.set_type) {
                    case "resistance_set":
                        insightUpdates = sumResistanceSetFields(
                            previousData.activity_sets as ResistanceSet[],
                            currentData.activity_sets as ResistanceSet[]
                        ) as ResistanceSet;
                        validateResistanceSetInsights(
                            currentInsight,
                            currentData
                        );
                        updatePromise = doc.ref.update({
                            "total_weight": FieldValue.increment(insightUpdates.weight),
                            "highest_weight_value": currentInsight.highest_weight_value,
                            "highest_weight_set_index": currentInsight.highest_weight_set_index,
                            "activity_id_most_weight": currentInsight.activity_id_most_weight,
                            "total_repetitions": FieldValue.increment(insightUpdates.repetitions),
                            "highest_repetitions_value": currentInsight.highest_repetitions_value,
                            "highest_repetitions_set_index": currentInsight.highest_repetitions_set_index,
                            "activity_id_most_repetitions": currentInsight.activity_id_most_repetitions
                        });
                        break;
                    case "run_set":
                        insightUpdates = sumRunSetFields(
                            previousData.activity_sets as RunSet[],
                            currentData.activity_sets as RunSet[]
                        ) as RunSet;
                        validateRunSetInsights(
                            currentInsight,
                            currentData
                        )
                        updatePromise = doc.ref.update({
                            "total_run_distance": FieldValue.increment(insightUpdates.distance),
                            "highest_run_distance_value": currentInsight.highest_run_distance_value,
                            "highest_run_distance_set_index": currentInsight.highest_run_distance_set_index,
                            "activity_id_most_run_distance": currentInsight.activity_id_most_run_distance,
                            "total_elevation": FieldValue.increment(insightUpdates.elevation),
                            "highest_elevation_value": currentInsight.highest_elevation_value,
                            "highest_elevation_set_index": currentInsight.highest_elevation_set_index,
                            "activity_id_most_elevation": currentInsight.activity_id_most_elevation,
                            "total_run_duration": FieldValue.increment(insightUpdates.duration),
                            "highest_run_duration_value": currentInsight.highest_run_duration_value,
                            "highest_run_duration_set_index": currentInsight.highest_run_duration_set_index,
                            "activity_id_most_run_duration": currentInsight.activity_id_most_run_duration,
                        });
                        break;
                    case "swim_set":
                        insightUpdates = sumSwimSetFields(
                            previousData.activity_sets as SwimSet[],
                            currentData.activity_sets as SwimSet[]
                        ) as SwimSet;
                        validateSwimSetInsights(
                            currentInsight,
                            currentData
                        )
                        updatePromise = doc.ref.update({
                            "total_swim_distance": FieldValue.increment(insightUpdates.distance),
                            "highest_swim_distance_value": currentInsight.highest_swim_distance_value,
                            "highest_swim_distance_set_index": currentInsight.highest_swim_distance_set_index,
                            "activity_id_most_swim_distance": currentInsight.activity_id_most_swim_distance,
                            "total_laps": FieldValue.increment(insightUpdates.laps),
                            "highest_laps_value": currentInsight.highest_laps_value,
                            "highest_laps_set_index": currentInsight.highest_laps_set_index,
                            "activity_id_most_laps": currentInsight.activity_id_most_laps,
                            "total_swim_duration": FieldValue.increment(insightUpdates.duration),
                            "highest_swim_duration_value": currentInsight.highest_swim_duration_value,
                            "highest_swim_duration_set_index": currentInsight.highest_swim_duration_set_index,
                            "activity_id_most_swim_duration": currentInsight.activity_id_most_swim_duration,
                        });
                        break;
                    default: 
                        throw SyntaxError("Modified Set has malformed set_type: Invalid Set Type.");
                }
                
                updatePromises.push(updatePromise);
            });

            await Promise.all(updatePromises);

        } catch (error) {
            console.error("Error updating document");
            console.log(error);
        }
    });
