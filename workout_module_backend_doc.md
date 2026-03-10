# Workout Module Overview & Backend Documentation

## 1. Frontend Overview (Flutter)
The workout module is responsible for managing exercises, browsing categories, logging workouts, and tracking history. It follows a structured UI + Provider architecture.

### Key Components

#### State Management (`/provider/workout_provider.dart`)
- **`ExercisesProvider`**: Stores a list of pre-defined exercises, handles text-based search, and keeps a list of currently selected/logged exercises.
- **`WorkoutProgressProvider`**: Maintains the user's workout tracking history by date. It maps a `DateTime` to a list of `WorkoutProgress` (which contains exercises and sets).
- **Core Models**:
  - `Exercise`: Contains details like id, name, imageUrl, level, intensity, calories, and video links.
  - `WorkoutSet`: Contains `reps` (int) and `weight` (double?).
  - `WorkoutProgress`: Represents an exercise logged for a specific date, containing a list of `WorkoutSet`.

#### Screens (`/ui`)
- **`workouts_screen.dart`**: Dashboard. Shows categories and a date selector.
- **`exercises_screen.dart`**: Browsing exercises list.
- **`exercise_details_screen.dart`**: Detailed information/video for an exercise.
- **`workout_progress_screen.dart`**: The active logging screen where users add sets/reps.
- **`session_log_screen.dart` & `session_log_details_screen.dart`**: History tracking for past dates.

---

## 2. Backend Architecture (Recommended Node.js / Express structure)

To build a backend supporting this module, you need a database (like MongoDB or PostgreSQL). Below is the recommended schema and API structure assuming MongoDB (Mongoose), as Document DBs map nicely to this structure.

### Proposed Database Schema

#### `Exercise` Collection
Stores the universal library of exercises.
```javascript
const ExerciseSchema = new mongoose.Schema({
  name: { type: String, required: true },
  imageUrl: { type: String, required: true },
  level: { type: String, enum: ['beginner', 'intermediate', 'advanced'], default: 'intermediate' },
  averageMinutes: { type: Number, default: 10 },
  intensity: { type: String, enum: ['low', 'moderate', 'high'], default: 'moderate' },
  description: { type: String },
  calories: { type: Number },
  goodFor: [{ type: String }],
  videoUrl: { type: String },
  videoThumbnailUrl: { type: String },
  videoDurationMinutes: { type: Number }
}, { timestamps: true });
```

#### `WorkoutLog` Collection
Stores a user's daily progress and corresponding sets.
```javascript
const WorkoutSetSchema = new mongoose.Schema({
  reps: { type: Number, required: true },
  weight: { type: Number }, // optional
});

const WorkoutProgressSchema = new mongoose.Schema({
  exerciseId: { type: mongoose.Schema.Types.ObjectId, ref: 'Exercise', required: true },
  exerciseName: { type: String, required: true }, // Cached name for faster loads
  sets: [WorkoutSetSchema]
});

const WorkoutLogSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  date: { type: String, required: true }, // Format: YYYY-MM-DD
  progress: [WorkoutProgressSchema]
}, { timestamps: true });

// Avoid duplicate logs for the same user on the same date
WorkoutLogSchema.index({ userId: 1, date: 1 }, { unique: true });
```

---

## 3. Recommended APIs to Create

### A. Exercise Catalog APIs
These APIs fetch the global library of exercises.

1. **`GET /api/exercises`**
   - **Purpose:** Fetch all exercises (used by `ExercisesProvider`).
   - **Query Params:** `?search=xx` (optional) to filter by name.
   - **Response:** Array of `Exercise` objects.

2. **`GET /api/exercises/:id`**
   - **Purpose:** Fetch detailed info for a single exercise.

---

### B. Workout Logging APIs
These APIs replace `WorkoutProgressProvider` by saving user logs to the database.

1. **`GET /api/workout-logs?date=YYYY-MM-DD`**
   - **Purpose:** Fetch the user's workout progress for a specific date.
   - **Response:** 
     ```json
     {
       "date": "2024-03-12",
       "progress": [
         {
           "exerciseId": "abc123id",
           "exerciseName": "Push Ups",
           "sets": [{ "reps": 10, "weight": null }]
         }
       ]
     }
     ```

2. **`POST /api/workout-logs/exercises`**
   - **Purpose:** Add an exercise to a specific day (`addExerciseToWorkout`).
   - **Body:** `{ "date": "YYYY-MM-DD", "exerciseId": "id", "exerciseName": "name" }`
   
3. **`DELETE /api/workout-logs/exercises`**
   - **Purpose:** Remove an exercise entirely from a date.
   - **Body:** `{ "date": "YYYY-MM-DD", "exerciseId": "id" }`

4. **`POST /api/workout-logs/sets`**
   - **Purpose:** Add a new set to a given exercise on a certain day (`addSetToExercise`).
   - **Body:** `{ "date": "YYYY-MM-DD", "exerciseId": "id", "reps": 10, "weight": 20 }`

5. **`PUT /api/workout-logs/sets/:setIndex`**
   - **Purpose:** Update a specific set's reps or weight (`updateSet`).
   - **Body:** `{ "date": "YYYY-MM-DD", "exerciseId": "id", "reps": 12, "weight": 22 }`

6. **`DELETE /api/workout-logs/sets/:setIndex`**
   - **Purpose:** Delete a set (`removeSetFromExercise`).
   - **Body:** `{ "date": "YYYY-MM-DD", "exerciseId": "id" }`

### Summary
To transition this module to a real backend, you just need to swap out the in-memory lists inside the `ChangeNotifier` providers with straightforward HTTP calls using a package like `http` or `dio`. The frontend state already perfectly mimics the expected schema of a NoSQL database document.
