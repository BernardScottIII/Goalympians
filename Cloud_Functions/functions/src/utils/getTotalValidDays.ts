import {User} from "../types/user";

/**
 * Returns a count representing the number of days which a user has recorded
 * at least one workout.
 * @param {User} user - Document representing the currently authenticated user.
 * @return {number} The number of days in which a user has recorded at lease one
 * workout.
 */
export function getTotalValidDays(user: User): number {
  const week = user.streak_valid_days;
  let validCount = 0;
  for (const day in week) {
    if (user.streak_valid_days[day as keyof typeof user.streak_valid_days]) {
      validCount++;
    }
  }
  return validCount;
}
