import {Timestamp} from "firebase-admin/firestore";

export type User = {
  "date_created": Timestamp,
  "email": string,
  "streak_data": {"current_streak": number, "streak_threshold": number},
  "streak_valid_days": {
    "sunday": boolean,
    "monday": boolean,
    "tuesday": boolean,
    "wednesday": boolean,
    "thursday": boolean,
    "friday": boolean,
    "saturday": boolean
  },
  "user_id": string,
  "using_dark_mode": boolean
}
