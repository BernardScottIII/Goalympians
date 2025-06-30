/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import * as v2 from "firebase-functions/v2";
import * as admin from "firebase-admin";
import {FieldValue, Timestamp} from "firebase-admin/firestore";
import {currentAndNextMonthStart} from "../utils/currentAndNextMonthStart";
import {Workout} from "../types/workout";
import {WorkoutInsight} from "../types/insight";
import {User} from "../types/user";
import { user } from "firebase-functions/v1/auth";

const db = admin.firestore();

export const updateWorkoutCount = v2.firestore
  .onDocumentCreated("/workouts/{id}", async (event) => {
    try {
      // get the user_id from the workout document
      const snapshot = event.data;
      if (!snapshot) return;

      const newWorkout = snapshot.data() as Workout;

      // Conversion of Firestore Timestamp to JS Date
      const date = newWorkout.date.toDate();

      const {
        currentMonthStart,
        nextMonthStart,
      } = currentAndNextMonthStart(date);

      const startCurrentMonth = Timestamp.fromDate(currentMonthStart);
      const startNextMonth = Timestamp.fromDate(nextMonthStart);

      const insightSnapshot =
      await db.collection(`users/${newWorkout.userId}/workout_insights`)
        .where("date", ">=", startCurrentMonth)
        .where("date", "<", startNextMonth)
        .get();

      if (insightSnapshot.empty) {
        console.log("No matching documents");
        return;
      }

      var userSnapshot =
      await db.doc(`users/${newWorkout.userId}`).get();
      let userDocument = userSnapshot.data() as User;

      let newWorkoutDate: Date = newWorkout.date.toDate();
      let dayOfWeek: string = newWorkoutDate
      .toLocaleString('en-us', {weekday: 'long'})
      .toLowerCase();

      if(!userDocument.streak_valid_days[
        dayOfWeek as keyof typeof userDocument.streak_valid_days
      ]) {
        // userDocument.streak_valid_days[
        //   dayOfWeek as keyof typeof userDocument.streak_valid_days
        // ] = true;

        let dayKey: string = `streak_valid_days.${dayOfWeek}`;

        const userUpdatePromise = userSnapshot.ref.update({
          [dayKey]: true,
        });

        Promise.all([userUpdatePromise]);
      }

      const updatePromises: Promise<FirebaseFirestore.WriteResult>[] = [];

      // data.workout_count += 1
      insightSnapshot.forEach((doc) => {
        let insightSnapshot = doc.data() as WorkoutInsight;
        

        const updatePromise = doc.ref.update({
          "workout_count": FieldValue.increment(1),
        });
        updatePromises.push(updatePromise);
      });

      await Promise.all(updatePromises);
    } catch (error) {
      console.error("Error updating matching documents");
      console.log(error);
    }
  });
