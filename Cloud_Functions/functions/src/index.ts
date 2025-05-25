/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// import {onRequest} from "firebase-functions/v2/https";
import * as v2 from "firebase-functions/v2";
import * as v1 from "firebase-functions/v1";
// import * as logger from "firebase-functions/logger";

type Indexable = {[key:string]:string};

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// export const helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

export const helloworld = v2.https.onRequest((request, response) => {
  // debugger;
  const name = request.params[0].replace("/", "");
  const items: Indexable = {lamp: "This is a lamp", chair: "This is a chair"};
  const message = items[name];
  response.send(`<h1>${message}</h1>`);
});

type Sku = { name: string; usd: number; eur?: number };
const USD_TO_EUROS = 0.95;
// Tell Firestore at what path we want to trigger the update
export const newsku = v1.firestore.document("/inventory/{sku}")
  .onCreate((snapshot) => {
    const data = snapshot.data() as Sku;
    const balls: Sku = {name: "bals", usd: 69};
    balls.eur = balls.usd * USD_TO_EUROS;
    const eur = data.usd * USD_TO_EUROS;
    return snapshot.ref.set({eur, ...data}, {merge: true});
  });

/*
let id = UUID()
    let userId: String
    let exerciseName: String
    let usedInWorkouts: Int
    let totalRepetitionsRecorded: Int
    let setType: SetType
*/

type ActivityInsight = {
  id: string;
  userId: string;
  exerciseName: string;
  usedInWorkouts: number;
  totalRepetitionsRecorded: number;
  setType: string;
}

// export const updateinsight =
// v1.firestore.document("/users/{user_id}/insights/{insight_id}")
export const updateinsight = v1.firestore.document("/workouts/{id}")
  .onUpdate((change, context) => {
    const temp: ActivityInsight = {
      id: "1234",
      userId: "2345",
      exerciseName: "test exercise",
      usedInWorkouts: 12,
      totalRepetitionsRecorded: 23,
      setType: "resistance set",
    };
    console.log(temp);
    const newValue = change.after.data();
    const previousValue = change.before.data();
    console.log(previousValue);
    console.log(newValue);

    return change.after.ref.set( newValue, {merge: true});
  });
