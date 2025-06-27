import { ResistanceSet, RunSet, SwimSet } from "../types/activity";

export function sumResistanceSetFields(previous_sets: ResistanceSet[], current_sets: ResistanceSet[]): ResistanceSet {
    var weightDifference = 0;
    var repetitionsDifference = 0;

    current_sets.forEach((set) => {
        weightDifference += set.weight
        repetitionsDifference += set.repetitions
    });

    previous_sets.forEach((set) => {
        weightDifference -= set.weight
        repetitionsDifference -= set.repetitions
    });

    return { 
        set_index: -1, 
        weight: weightDifference, 
        repetitions: repetitionsDifference 
    };
}

export function sumRunSetFields(previous_sets: RunSet[], current_sets: RunSet[]): RunSet {
    var distanceDifference = 0;
    var elevationDifference = 0;
    var durationDifference = 0;

    current_sets.forEach((set) => {
        distanceDifference += set.distance
        elevationDifference += set.elevation
        durationDifference += set.duration
    });

    previous_sets.forEach((set) => {
        distanceDifference -= set.distance
        elevationDifference -= set.elevation
        durationDifference -= set.duration
    });

    return { 
        set_index: -1, 
        distance: distanceDifference, 
        elevation: elevationDifference, 
        duration: durationDifference 
    };
}

export function sumSwimSetFields(previous_sets: SwimSet[], current_sets: SwimSet[]): SwimSet {
    var distanceDifference = 0;
    var lapsDifference = 0;
    var durationDifference = 0;

    current_sets.forEach((set) => {
        distanceDifference += set.distance
        lapsDifference += set.laps
        durationDifference += set.duration
    });

    previous_sets.forEach((set) => {
        distanceDifference -= set.distance
        lapsDifference -= set.laps
        durationDifference -= set.duration
    });

    return { 
        set_index: -1, 
        distance: distanceDifference, 
        laps: lapsDifference, 
        duration: durationDifference 
    };
}