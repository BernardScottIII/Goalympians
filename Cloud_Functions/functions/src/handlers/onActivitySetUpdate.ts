import * as v2 from "firebase-functions/v2";
import * as admin from "firebase-admin";
import { FieldValue, Timestamp } from "firebase-admin/firestore";
import { Workout } from "../types/workout"
import { currentAndNextMonthStart } from "../utils/currentAndNextMonthStart";
import { ResistanceSet, RunSet, SwimSet, WorkoutActivity } from "../types/activity";

const db = admin.firestore();

export const updateTotalSets = v2.firestore
    .onDocumentUpdated("workouts/{workout_id}/activities/{activity_id}", async (event) => {
        try {
            const previous = event.data?.before
            const current = event.data?.after

            const previousData = previous?.data() as WorkoutActivity;
            const currentData = current?.data() as WorkoutActivity;

            console.log(previousData);
            console.log(currentData);

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

            var insightUpdates: ResistanceSet | RunSet | SwimSet;

            // Use the set_type in the parent workout to find which set type to use
            switch (currentData.set_type) {
                case "resistance_set": 
                    insightUpdates = sumResistanceSetFields(
                        previousData.activity_sets as [ResistanceSet],
                        currentData.activity_sets as [ResistanceSet]
                    ) as ResistanceSet;
                    break;
                case "run_set": 
                    insightUpdates = sumRunSetFields(
                        previousData.activity_sets as [RunSet],
                        currentData.activity_sets as [RunSet]
                    ) as RunSet;
                    break;
                case "swim_set": 
                    insightUpdates = sumSwimSetFields(
                        previousData.activity_sets as [SwimSet],
                        currentData.activity_sets as [SwimSet]
                    ) as SwimSet;
                    break;
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
                switch (currentData.set_type) {
                    case "resistance_set":
                        insightUpdates = insightUpdates as ResistanceSet;
                        updatePromise = doc.ref.update({
                            "total_weight": FieldValue.increment(insightUpdates.weight),
                            "total_repetitions": FieldValue.increment(insightUpdates.repetitions)
                        });
                        break;
                    case "run_set":
                        insightUpdates = insightUpdates as RunSet;
                        updatePromise = doc.ref.update({
                            "total_run_distance": FieldValue.increment(insightUpdates.distance),
                            "total_elevation": FieldValue.increment(insightUpdates.elevation),
                            "total_run_duration": FieldValue.increment(insightUpdates.duration),
                        });
                        break;
                    case "swim_set":
                        insightUpdates = insightUpdates as SwimSet;
                        updatePromise = doc.ref.update({
                            "total_swim_distance": FieldValue.increment(insightUpdates.distance),
                            "total_laps": FieldValue.increment(insightUpdates.laps),
                            "total_swim_duration": FieldValue.increment(insightUpdates.duration),
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

function sumResistanceSetFields(previous_sets: ResistanceSet[], current_sets: ResistanceSet[]): ResistanceSet {
    var weightDifference = 0;
    var repetitionsDifference = 0;

    current_sets.forEach((set) => {
        weightDifference += set.weight
        repetitionsDifference += set.repetitions
    });

    previous_sets.forEach((set) => {
        weightDifference -= set.weight
        repetitionsDifference -= set.repetitions
    });

    // send the update
    return { setIndex: -1, weight: weightDifference, repetitions: repetitionsDifference } as ResistanceSet;
}

function sumRunSetFields(previous_sets: RunSet[], current_sets: RunSet[]): RunSet {
    var distanceDifference = 0;
    var elevationDifference = 0;
    var durationDifference = 0;

    current_sets.forEach((set) => {
        distanceDifference += set.distance
        elevationDifference += set.elevation
        durationDifference += set.duration
    });

    previous_sets.forEach((set) => {
        distanceDifference -= set.distance
        elevationDifference -= set.elevation
        durationDifference -= set.duration
    });

    return { 
        setIndex: -1, 
        distance: distanceDifference, 
        elevation: elevationDifference, 
        duration: durationDifference 
    } as RunSet;
}

function sumSwimSetFields(previous_sets: SwimSet[], current_sets: SwimSet[]): SwimSet {
    var distanceDifference = 0;
    var lapsDifference = 0;
    var durationDifference = 0;

    current_sets.forEach((set) => {
        distanceDifference += set.distance
        lapsDifference += set.laps
        durationDifference += set.duration
    });

    previous_sets.forEach((set) => {
        distanceDifference -= set.distance
        lapsDifference -= set.laps
        durationDifference -= set.duration
    });

    return { 
        setIndex: -1, 
        distance: distanceDifference, 
        laps: lapsDifference, 
        duration: durationDifference 
    } as SwimSet;
}