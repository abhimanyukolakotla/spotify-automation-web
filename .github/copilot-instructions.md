<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

# Spotify Automation Web App — Copilot Instructions

## Project Overview
This is a full-stack web application with:
- **Backend**: Spring Boot 3 (Java 17) with Spring Security OAuth2, Spring Data JPA, H2
- **Frontend**: React 18 (TypeScript) with React Router, Axios, Lucide React

## Key Architecture
- Spring Boot backend runs on port **8080**
- React frontend runs on port **3000** (proxies API calls to 8080)
- OAuth2 login via Spotify (configured in `application.properties`)
- Songs are stored in H2 in-memory DB per user, grouped by `DayOfWeek`

## Backend Packages
- `config` – Security, CORS, AppConfig (RestTemplate bean)
- `controller` – AuthController, ScheduledSongController, SpotifyController
- `model` – ScheduledSong entity
- `repository` – ScheduledSongRepository (JPA)
- `service` – ScheduledSongService
- `dto` – ScheduledSongRequest

## Frontend Structure
- `src/context/AuthContext.tsx` – Auth state, login/logout
- `src/pages/LoginPage.tsx` – Spotify login page
- `src/pages/Dashboard.tsx` – Main dashboard with day tabs
- `src/components/SongCard.tsx` – Individual song display
- `src/components/SearchModal.tsx` – Search Spotify and add song to a day
- `src/components/Navbar.tsx` – Top nav with user info
- `src/api.ts` – All Axios API calls

## Coding Conventions
- Use functional React components with TypeScript
- Use CSS modules per component (same name .css file)
- Dark theme: background `#0d0d0d / #1a1a2e`, accent `#1DB954` (Spotify green)
- Spring Boot controllers use `@AuthenticationPrincipal OAuth2User` for user identity
