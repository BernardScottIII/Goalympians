"use strict";
/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.updateWorkoutCount = void 0;
const v2 = __importStar(require("firebase-functions/v2"));
// import * as v1 from "firebase-functions/v1";
const admin = __importStar(require("firebase-admin"));
const firestore_1 = require("firebase-admin/firestore");
admin.initializeApp();
const db = admin.firestore();
exports.updateWorkoutCount = v2.firestore
    .onDocumentCreated("/workouts/{id}", async (event) => {
    try {
        // get the user_id from the workout document
        const snapshot = event.data;
        if (!snapshot)
            return;
        const newWorkout = snapshot.data();
        // Navigate to users/{user_id}/insights/
        //  where {insight_id}.name == workout_count
        const insightSnapshot = await db.collection(`users/${newWorkout.userId}/insights`)
            .where("name", "==", "workout_count")
            .get();
        if (insightSnapshot.empty) {
            console.log("No matching documents");
            return;
        }
        const updatePromises = [];
        // data.count += 1
        insightSnapshot.forEach((doc) => {
            const updatePromise = doc.ref.update({
                "data.count": firestore_1.FieldValue.increment(1),
            });
            updatePromises.push(updatePromise);
        });
        await Promise.all(updatePromises);
    }
    catch (error) {
        console.error("Error updating matching documents");
        console.log(error);
    }
});
//# sourceMappingURL=index.js.map