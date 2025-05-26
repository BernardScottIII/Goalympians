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
import {FieldValue} from "firebase-admin/firestore";

admin.initializeApp();
const db = admin.firestore();

type Workout = {
  id: string;
  userId: string;
  name: string;
  description: string;
  date: Date;
}

export const updateWorkoutCount = v2.firestore
  .onDocumentCreated("/workouts/{id}", async (event) => {
    try {
      // get the user_id from the workout document
      const snapshot = event.data;
      if (!snapshot) return;

      const newWorkout = snapshot.data() as Workout;

      // Navigate to users/{user_id}/insights/
      //  where {insight_id}.name == workout_count
      const insightSnapshot =
      await db.collection(`users/${newWorkout.userId}/insights`)
        .where("name", "==", "workout_count")
        .get();

      if (insightSnapshot.empty) {
        console.log("No matching documents");
        return;
      }

      const updatePromises: Promise<FirebaseFirestore.WriteResult>[] = [];

      // data.count += 1
      insightSnapshot.forEach((doc) => {
        const updatePromise = doc.ref.update({
          "data.count": FieldValue.increment(1),
        });
        updatePromises.push(updatePromise);
      });

      await Promise.all(updatePromises);
    } catch (error) {
      console.error("Error updating matching documents");
      console.log(error);
    }
  });
