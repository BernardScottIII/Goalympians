import * as v2 from "firebase-functions/v2";
import * as admin from "firebase-admin";
import {WorkoutActivity} from "../types/activity";
import {Workout} from "../types/workout";
import {FieldValue, Timestamp} from "firebase-admin/firestore";
import {currentAndNextMonthStart} from "../utils/currentAndNextMonthStart";
import {WorkoutInsight} from "../types/insight";

const db = admin.firestore();

export const updateExerciseCounts = v2.firestore
  .onDocumentCreated("workouts/{workout_id}/activities/{activity_id}",
    async (event) => {
      try {
        const snapshot = event.data;
        if (!snapshot) return;

        const parentWorkoutSnapshot =
        await db.doc(`workouts/${event.params.workout_id}`).get();
        if (!parentWorkoutSnapshot) return;

        const newActivity = snapshot.data() as WorkoutActivity;
        const parentWorkout = parentWorkoutSnapshot.data() as Workout;

        const {
          currentMonthStart,
          nextMonthStart,
        } = currentAndNextMonthStart(parentWorkout.date.toDate());

        const startCurrentMonth = Timestamp.fromDate(currentMonthStart);
        const startNextMonth = Timestamp.fromDate(nextMonthStart);

        const insightSnapshot =
        await db.collection(`users/${parentWorkout.userId}/workout_insights`)
          .where("date", ">=", startCurrentMonth)
          .where("date", "<", startNextMonth)
          .get();

        const updatePromises: Promise<FirebaseFirestore.WriteResult>[] = [];

        insightSnapshot.forEach((doc) => {
          const exerciseOccurrenceId =
          `exercise_occurrence_counts.${newActivity.exercise_id}`;

          const currentInsight = doc.data() as WorkoutInsight;
          // if thisExerciseId.FieldValue.increment(1) >
          // exerciseOccurrenceCounts[exerciseIdMostActivities]
          // exerciseIdMostActivities = thisExerciseId
          let exerciseIdGreatestCount =
          currentInsight.exercise_id_most_activities;

          if (
            currentInsight.exercise_occurrence_counts[
              newActivity.exercise_id] + 1 >
            currentInsight.exercise_occurrence_counts[
              currentInsight.exercise_id_most_activities] ||
            currentInsight.exercise_id_most_activities == ""
          ) {
            currentInsight.exercise_id_most_activities =
            newActivity.exercise_id;

            exerciseIdGreatestCount = newActivity.exercise_id;
          }

          const updatePromise = doc.ref.update({
            "total_sets": FieldValue.increment(1),
            [exerciseOccurrenceId]: FieldValue.increment(1),
            "exercise_id_most_activities": exerciseIdGreatestCount,
          });
          updatePromises.push(updatePromise);
        });
      } catch (error) {
        console.error("Error updating matching documents");
        console.log(error);
      }
    }
  );
