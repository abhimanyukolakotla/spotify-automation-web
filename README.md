# 🎵 Spotify Scheduler

A full-stack web app to schedule your favorite Spotify songs for each day of the week.

## Features
- 🔐 **Spotify OAuth2 Login** — Secure authentication via Spotify
- 📅 **Day-based Scheduling** — Add songs to any day of the week (Monday–Sunday)
- 🔍 **Spotify Search** — Search and add songs directly from Spotify's catalog
- ▶️ **Play Songs** — Trigger playback on your active Spotify device
- 🗑️ **Remove Songs** — Remove scheduled songs anytime

## Tech Stack
| Layer | Tech |
|-------|------|
| Backend | Spring Boot 3, Spring Security, OAuth2 Client, Spring Data JPA |
| Database | H2 (in-memory, dev) |
| Frontend | React 18, TypeScript, React Router, Axios |
| UI Icons | Lucide React |

## Prerequisites
- Java 17+
- Node.js 18+
- Maven 3.8+
- A [Spotify Developer App](https://developer.spotify.com/dashboard) with:
  - Redirect URI: `http://localhost:8080/login/oauth2/code/spotify`

## Setup

### 1. Configure Spotify credentials
Edit `backend/src/main/resources/application.properties`:
```properties
spring.security.oauth2.client.registration.spotify.client-id=YOUR_CLIENT_ID
spring.security.oauth2.client.registration.spotify.client-secret=YOUR_CLIENT_SECRET
```
Or set environment variables:
```bash
export SPOTIFY_CLIENT_ID=your_client_id
export SPOTIFY_CLIENT_SECRET=your_client_secret
```

### 2. Run the Backend
```bash
cd backend
./mvnw spring-boot:run
```
Backend starts at **http://localhost:8080**

### 3. Run the Frontend
```bash
cd frontend
npm install
npm start
```
Frontend starts at **http://localhost:3000**

## Usage
1. Open http://localhost:3000
2. Click **Login with Spotify**
3. Authorize the app on Spotify
4. You'll be redirected to the Dashboard
5. Select a day tab, click **+ Add Song**, search, and add!

## Project Structure
```
spotify_automation_web/
├── backend/                   # Spring Boot app
│   └── src/main/java/com/spotify/automation/
│       ├── config/            # Security, CORS, beans
│       ├── controller/        # REST controllers
│       ├── model/             # JPA entities
│       ├── repository/        # JPA repos
│       ├── service/           # Business logic
│       └── dto/               # Request DTOs
└── frontend/                  # React app
    └── src/
        ├── api.ts             # API client
        ├── context/           # Auth context
        ├── pages/             # Login, Dashboard
        └── components/        # SongCard, SearchModal, Navbar
```
