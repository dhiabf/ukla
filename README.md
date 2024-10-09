# ukla
# Ukla Recipe App

## Overview

The Ukla Recipe App is a Flutter-based application that allows users to upload, manage, and view recipes accompanied by instructional videos. This project utilizes Azure Blob Storage for storing video content and PostgreSQL for managing recipe data. The application provides a seamless user experience for both uploading recipes and retrieving recipe details along with their corresponding videos.

## Features

- **Video Uploads**: Users can upload recipe videos to Azure Blob Storage.
- **Recipe Management**: Store recipe details in a PostgreSQL database, including title, creator, steps, and duration.
- **API Integration**: A Node.js server handles API calls for uploading and fetching recipes.

## Architecture

- **Frontend**: Flutter application.
- **Backend**: Node.js server for API endpoints.
- **Database**: PostgreSQL for storing recipe and user data.
- **Storage**: Azure Blob Storage for video files.

## Technical Implementation

### Azure Blob Storage

The application uses Azure Blob Storage to store videos uploaded by users. Each recipe video is uploaded to a designated container named `recipes`. This allows for scalable storage and efficient retrieval of video files.

### PostgreSQL Database

The PostgreSQL database is used to store recipe details and steps in two separate tables:
- `ukla_recipes`: Stores general information about the recipes, such as title, creator ID, video URL, and duration.
- `recipe_steps`: Contains individual steps related to each recipe, ensuring that the instructional details are well-organized.

### Node.js API

The API is built using Node.js and Express. It includes endpoints for uploading recipes and retrieving them. The following summarizes the key API calls:

- **POST `/upload-recipe`**: 
  - Accepts video files and recipe data in the request.
  - Validates the input and uploads the video to Azure Blob Storage.
  - Inserts recipe information into the PostgreSQL database.
  
- **GET `/recipes`**: 
  - Retrieves a list of all recipes stored in the database.
  
- **GET `/recipes/:id`**: 
  - Fetches detailed information about a specific recipe along with its steps.
