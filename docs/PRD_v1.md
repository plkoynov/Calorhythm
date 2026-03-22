# PRD – Simple Fitness Tracker App

## 1. App Purpose

The app helps users track physical activity and calculates burned calories for each exercise. It is designed to be **simple, intuitive, and fast**, focusing on quick home workouts.

**Key goals:**

- Track exercises using a timer per exercise
- Calculate burned calories based on exercise intensity and user weight
- Optionally adjust calories using repetitions
- Maintain a history of workouts
- Provide easy access to daily, weekly, and monthly statistics

---

## 2. Target Platform

- Cross-platform (iOS and Android)
- Works offline; all data is stored locally on the device

---

## 3. Core Features

### 3.1 User Profile

- Users can enter and update their **weight** and **height**
- The app uses the profile data to calculate calories burned
- Each workout session stores the user’s weight at the time of the session for accurate history

---

### 3.2 Exercises

- Fixed list of exercises imported from a reference source (e.g., MET values PDF)
- Each exercise includes:
  - Name
  - MET value
  - Reference repetitions per minute (for optional multiplier)
- Users select an exercise from a tile-based interface (tiles show name, icon, and color)

---

### 3.3 Timer Per Exercise

- Each exercise session has a **start/stop timer**
- After stopping:
  - If applicable, the user is asked to enter the **number of repetitions**
  - If the optional multiplier is enabled, calories are adjusted based on reps
  - Otherwise, calories are calculated from exercise intensity, weight, and duration
- Calories burned are displayed after completing the exercise

---

### 3.4 Calorie Calculation

#### Base Formula

Calories burned are calculated using the MET formula:

Calories = MET × Weight (kg) × Duration (hours)

Where:

- **MET** = metabolic equivalent value of the exercise
- **Weight** = user's weight in kilograms
- **Duration** = exercise time converted to hours

---

#### Optional Rep-Based Multiplier

If the multiplier option is enabled and repetitions are entered, the calorie calculation is adjusted based on exercise pace.

1. Calculate user pace:

User Pace = Repetitions ÷ Duration (minutes)

2. Compare with reference pace:

Multiplier = User Pace ÷ Reference Pace

3. Clamp the multiplier to a reasonable range:

0.6 ≤ Multiplier ≤ 1.8

4. Adjust calories:

Adjusted Calories = Base Calories × Multiplier

If the multiplier feature is disabled, the base MET calculation is used.

---

### 3.5 Workout History

The app stores information for all completed exercises:

- Start time of the session (UTC)
- Exercise name
- Duration
- Repetitions (if applicable)
- Calories burned

Users can view full history in a dedicated screen.

---

## 4. Bottom Navigation Menu

### Home

Overview of user activity:

- Number of exercises completed
- Calories burned today
- Calories burned this week
- Calories burned this month

---

### Exercises

- Tiles for most frequent exercises
- Each tile shows exercise name, color, and icon
- Selecting a tile opens the **exercise timer**

Timer screen:

- Start and Stop buttons
- Display of elapsed time

After stopping:

- Prompt for repetitions if applicable
- Display calories burned

---

### History

- Full list of past workouts
- Each entry shows:
  - Start time
  - Exercise name
  - Duration
  - Repetitions (if applicable)
  - Calories burned

---

### Profile

User settings including:

- Weight
- Height

Users can update weight for accuracy if it changes.

---

## 5. UI/UX Guidelines

- Clean and minimal interface
- Bottom navigation bar with four tabs
- Exercise tiles visually distinct using colors and icons
- Timer screen clearly displays elapsed time
- Calories burned displayed after each exercise
- Optional toggle for rep multiplier
- History screen shows a clear, scrollable list of sessions
- Home screen provides a quick summary using tiles or charts

---

## 6. Optional Features

- Rep-based calorie multiplier (switchable on/off)
- Future expansion may include more detailed statistics or additional exercises

---

## Summary

This PRD describes a **simple, user-friendly fitness app** focused on **timer-based exercise tracking**, **calorie calculation using MET values**, **optional repetition-based intensity adjustment**, and **local workout history**. The document defines product behavior while leaving implementation decisions to engineering.
