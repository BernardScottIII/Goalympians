import {ResistanceSet, RunSet, SwimSet} from "../types/activity";

/**
 * This function returns the difference of every weight and repetition value
 * between the two lists of ResistanceSets
 * @param {ResistanceSet[]} previousSets - List of sets in the
 * WorkoutActivity before an update
 * @param {ResistanceSet[]} currentSets - List of sets in the
 * WorkoutActivity after an update
 * @return {ResistanceSet} - A set containing the difference in weight and
 * repetition values for both lists
 */
export function sumResistanceSetFields(
  previousSets: ResistanceSet[],
  currentSets: ResistanceSet[]
): ResistanceSet {
  let weightDifference = 0;
  let repetitionsDifference = 0;

  currentSets.forEach((set) => {
    weightDifference += set.weight;
    repetitionsDifference += set.repetitions;
  });

  previousSets.forEach((set) => {
    weightDifference -= set.weight;
    repetitionsDifference -= set.repetitions;
  });

  return {
    set_index: -1,
    weight: weightDifference,
    repetitions: repetitionsDifference,
  };
}

/**
 * This function returns the difference of every weight and repetition value
 * between the two lists of RunSets
 * @param {RunSet[]} previousSets - List of sets in the WorkoutActivity
 * before an update
 * @param {RunSet[]} currentSets - List of sets in the WorkoutActivity after
 * an update
 * @return {RunSet} - A set containing the difference in distance, elevation,
 * and duration values for both lists
 */
export function sumRunSetFields(
  previousSets: RunSet[],
  currentSets: RunSet[]
): RunSet {
  let distanceDifference = 0;
  let elevationDifference = 0;
  let durationDifference = 0;

  currentSets.forEach((set) => {
    distanceDifference += set.distance;
    elevationDifference += set.elevation;
    durationDifference += set.duration;
  });

  previousSets.forEach((set) => {
    distanceDifference -= set.distance;
    elevationDifference -= set.elevation;
    durationDifference -= set.duration;
  });

  return {
    set_index: -1,
    distance: distanceDifference,
    elevation: elevationDifference,
    duration: durationDifference,
  };
}

/**
 * This function returns the difference of every weight and repetition value
 * between the two lists of SwimSets
 * @param {SwimSet[]} previousSets - List of sets in the WorkoutActivity
 * before an update
 * @param {SwimSet[]} currentSets - List of sets in the WorkoutActivity after
 * an update
 * @return {SwimSet} - A set containing the difference in distance, laps, and
 * duration values for both lists
 */
export function sumSwimSetFields(
  previousSets: SwimSet[],
  currentSets: SwimSet[]
): SwimSet {
  let distanceDifference = 0;
  let lapsDifference = 0;
  let durationDifference = 0;

  currentSets.forEach((set) => {
    distanceDifference += set.distance;
    lapsDifference += set.laps;
    durationDifference += set.duration;
  });

  previousSets.forEach((set) => {
    distanceDifference -= set.distance;
    lapsDifference -= set.laps;
    durationDifference -= set.duration;
  });

  return {
    set_index: -1,
    distance: distanceDifference,
    laps: lapsDifference,
    duration: durationDifference,
  };
}
