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
import {User} from "../types/user";
import {getTotalValidDays} from "../utils/getTotalValidDays";
import { getWeek } from "../utils/getWeekNumber";

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

      const userSnapshot =
      await db.doc(`users/${newWorkout.userId}`).get();
      const userDocument = userSnapshot.data() as User;

      const newWorkoutDate: Date = newWorkout.date.toDate();
      const dayOfWeek: string = newWorkoutDate
        .toLocaleString("en-us", {weekday: "long"})
        .toLowerCase();
      const dayOfWeekKey =
      dayOfWeek as keyof typeof userDocument.streak_valid_days;

      if (
        !userDocument.streak_valid_days[dayOfWeekKey] &&
        getWeek(newWorkoutDate) == getWeek(new Date())
      ) {
        userDocument.streak_valid_days[dayOfWeekKey] = true;

        const dayKey = `streak_valid_days.${dayOfWeek}`;

        let streakIncrement = 0;

        if (
          getTotalValidDays(userDocument) ==
          userDocument.streak_data.streak_threshold
        ) {
          streakIncrement = 1;
        }

        const weeklyStreakPromise = userSnapshot.ref.update({
          "streak_data.current_streak": FieldValue.increment(streakIncrement),
        });

        const workoutDayPromise = userSnapshot.ref.update({
          [dayKey]: true,
        });

        Promise.all([workoutDayPromise, weeklyStreakPromise]);
      }

      const updatePromises: Promise<FirebaseFirestore.WriteResult>[] = [];

      // data.workout_count += 1
      insightSnapshot.forEach((doc) => {
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
