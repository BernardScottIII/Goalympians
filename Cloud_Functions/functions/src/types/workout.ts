import {Timestamp} from "firebase-admin/firestore";

export type Workout = {
  id: string;
  userId: string;
  name: string;
  description: string;
  date: Timestamp;
}
