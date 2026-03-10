# Trainer-Client Workout Assignment Architecture

This document outlines the backend architecture required to support a Trainer-Client relationship, where a Trainer creates and assigns specific exercises/workouts to a Client, and the Client can only see and log what has been assigned to them.

---

## 1. Core Concepts & Roles

- **Trainer**: Can create custom exercises, view their clients, assign exercises/workouts to clients for specific dates, and view clients' logged progress.
- **Client**: Can only view workouts/exercises assigned to them by their trainer for a specific date, and can log their sets/reps against those assigned exercises.
- **Global Exercises vs. Custom Exercises**: The app can still have a global library of exercises (read-only), but Trainers can also create *Custom Exercises* specifically for their clients.

---

## 2. Updated Database Schema (MongoDB / Mongoose)

### A. User Schema (Adding Roles & Relationships)
We need to distinguish between Trainers and Clients, and link a Client to their Trainer.

```javascript
const UserSchema = new mongoose.Schema({
  name: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  role: { type: String, enum: ['trainer', 'client'], required: true },
  trainerId: { 
    type: mongoose.Schema.Types.ObjectId, 
    ref: 'User', 
    // Populated only if role === 'client'
  }
}, { timestamps: true });
```

### B. Exercise Schema (Global vs Trainer-Created)
Modify the exercise schema so we know if an exercise is globally available or created by a specific trainer.

```javascript
const ExerciseSchema = new mongoose.Schema({
  name: { type: String, required: true },
  imageUrl: { type: String },
  // ... other fields (level, calories, videoUrl, etc.)

  isGlobal: { type: Boolean, default: false },
  createdBy: { 
    type: mongoose.Schema.Types.ObjectId, 
    ref: 'User', // The Trainer who created this custom exercise
    required: function() { return !this.isGlobal; } 
  }
}, { timestamps: true });
```

### C. Assigned Workout Schema (The Core Feature)
This links a Client, a Date, and the Exercises the Trainer wants them to do.

```javascript
// What the trainer assigns
const AssignedExerciseSchema = new mongoose.Schema({
  exerciseId: { type: mongoose.Schema.Types.ObjectId, ref: 'Exercise', required: true },
  targetSets: { type: Number, default: 3 },
  targetReps: { type: Number, default: 10 },
  targetWeight: { type: Number }, // Optional target weight suggested by Trainer
  notes: { type: String } // e.g., "Keep your back straight"
});

const WorkoutPlanSchema = new mongoose.Schema({
  trainerId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  clientId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  date: { type: String, required: true }, // YYYY-MM-DD
  exercises: [AssignedExerciseSchema]
}, { timestamps: true });

// Prevent duplicate plans for the same client on the same date
WorkoutPlanSchema.index({ clientId: 1, date: 1 }, { unique: true });
```

### D. Workout Log Schema (Client logging their actual progress)
Remains similar to the previous document, but it should probably link back to the Assigned Workout so the Trainer can compare target vs. actual.

```javascript
const WorkoutSetSchema = new mongoose.Schema({
  reps: { type: Number, required: true },
  weight: { type: Number },
});

const WorkoutProgressSchema = new mongoose.Schema({
  exerciseId: { type: mongoose.Schema.Types.ObjectId, ref: 'Exercise', required: true },
  sets: [WorkoutSetSchema]
});

const WorkoutLogSchema = new mongoose.Schema({
  clientId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  date: { type: String, required: true }, // YYYY-MM-DD
  progress: [WorkoutProgressSchema]
}, { timestamps: true });
```

---

## 3. API Endpoints Structure

### For Trainers (`/api/trainer/*`)
Middleware requires `req.user.role === 'trainer'`.

1. **`POST /api/trainer/exercises`**
   - **Purpose**: Trainer creates a custom exercise (e.g., a specific mobility drill).

2. **`GET /api/trainer/clients`**
   - **Purpose**: List all clients linked to this trainer (`User.find({ trainerId: req.user._id })`).

3. **`POST /api/trainer/workout-plans`**
   - **Purpose**: Assigns a workout to a specific client for a specific date.
   - **Body**: `{ "clientId": "id", "date": "YYYY-MM-DD", "exercises": [ { "exerciseId": "id", "targetSets": 3, "targetReps": 12 } ] }`

4. **`GET /api/trainer/clients/:clientId/logs?date=YYYY-MM-DD`**
   - **Purpose**: Trainer views what the Client actually logged for that assigned day.

---

### For Clients (`/api/client/*`)
Middleware requires `req.user.role === 'client'`.

1. **`GET /api/client/workout-plans?date=YYYY-MM-DD`**
   - **Purpose**: Replaces the generic "Exercise Catalog". The Client fetches this to see *only* the exercises assigned to them for today.
   - **Response Details**: The backend populates the `exerciseId` so the client gets the `name`, `imageUrl`, `videoUrl`, along with `targetSets` and `notes` from the Trainer.

2. **`POST /api/client/logs`**
   - **Purpose**: Client starts their workout and logs their actual sets/reps. (Similar to `addSetToExercise`).
   - **Validation Rule**: The backend should verify that the `exerciseId` the client is logging actually exists in their `WorkoutPlan` for that date.

---

## 4. How the Frontend Flow Changes

1. **App Load**: User logs in. App checks role (`client` or `trainer`).
2. **Client Dashboard (`workouts_screen.dart`)**: Instead of fetching *all* exercises via `ExercisesProvider`, the app calls `GET /api/client/workout-plans?date=2024-03-12`.
3. **Display**: The UI renders a list of the assigned exercises under the "Today's Plan" section. If the list is empty, display an "Empty State" message indicating the trainer hasn't assigned a workout yet.
4. **Logging**: When the client taps an assigned exercise, they enter their actual reps/weight. This calls the `POST /api/client/logs` to hit the `WorkoutLog` schema.
