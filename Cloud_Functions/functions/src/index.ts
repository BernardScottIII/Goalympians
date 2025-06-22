/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import * as v2 from "firebase-functions/v2";
// import * as v1 from "firebase-functions/v1";
import * as admin from "firebase-admin";
import {FieldValue, Timestamp} from "firebase-admin/firestore";

admin.initializeApp();
const db = admin.firestore();

type Workout = {
  id: string;
  userId: string;
  name: string;
  description: string;
  date: Timestamp;
}

function currentAndNextMonthStart(date: Date): {
  currentMonthStart: Date;
  nextMonthStart: Date;
} {
  const currentYear = date.getUTCFullYear();
  const currentMonth = date.getUTCMonth();

  const currentMonthStart = new Date(Date.UTC(currentYear, currentMonth, 1));

  const nextMonthStart = new Date(Date.UTC(currentYear, currentMonth+1, 1));

  return { currentMonthStart, nextMonthStart };
}

export const updateWorkoutCount = v2.firestore
  .onDocumentCreated("/workouts/{id}", async (event) => {
    try {
      // get the user_id from the workout document
      const snapshot = event.data;
      if (!snapshot) return;

      const newWorkout = snapshot.data() as Workout;

      // Conversion of Firestore Timestamp to JS Date
      const date = newWorkout.date.toDate();

      // Define the specific month whose data we're interested in updating
      const { currentMonthStart, nextMonthStart } = currentAndNextMonthStart(date);

      const startCurrentMonth = Timestamp.fromDate(currentMonthStart);
      const startNextMonth = Timestamp.fromDate(nextMonthStart);

      // Navigate to users/{user_id}/workout_insights
      //  where {workout_insight_id}.date.month == newWorkout.date.month
      const insightSnapshot =
      await db.collection(`users/${newWorkout.userId}/workout_insights`)
        .where("date", ">=", startCurrentMonth)
        .where("date", "<", startNextMonth)
        .get();

      if (insightSnapshot.empty) {
        console.log("No matching documents");
        return;
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
