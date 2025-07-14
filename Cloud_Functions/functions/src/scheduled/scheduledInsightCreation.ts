import * as admin from "firebase-admin";
import {User} from "../types/user";
import {createNewInsight} from "../utils/createNewInsight";
import {onSchedule} from "firebase-functions/v2/scheduler";

const db = admin.firestore();

export const createNewMonthInsight =
onSchedule("1 of month 00:00", async () => {
  try {
    const usersSnapshot = await db.collection("users").get();

    const updatePromises: Promise<FirebaseFirestore.WriteResult>[] = [];

    usersSnapshot.forEach(async (userDoc) => {
      const userData = userDoc.data() as User;

      const newInsightRef =
      db.collection(`users/${userData.user_id}/workout_insights`).doc();

      const newInsightId = newInsightRef.id;
      const insightData = createNewInsight();
      insightData.id = newInsightId;

      const updatePromise = newInsightRef.set(insightData);
      updatePromises.push(updatePromise);
    });

    await Promise.all(updatePromises);
  } catch (error) {
    console.error("Error creating this month's insights document");
    console.log(error);
  }
});

export const resetWeeklyStreak = onSchedule("every sunday 00:00", async () => {
  try {
    const usersSnapshot = await db.collection("users").get();

    const updatePromises: Promise<FirebaseFirestore.WriteResult>[] = [];

    usersSnapshot.forEach(async (userDoc) => {
      const userData = userDoc.data() as User;
      userData.streak_valid_days;

      const updatePromise = userDoc.ref.update({
        "streak_valid_days": {
          monday: false,
          tuesday: false,
          wednesday: false,
          thursday: false,
          friday: false,
          saturday: false,
          sunday: false,
        },
      });

      updatePromises.push(updatePromise);
    });

    await Promise.all(updatePromises);
  } catch (error) {
    console.error("Error resetting weekly streaks.");
    console.log(error);
  }
});
